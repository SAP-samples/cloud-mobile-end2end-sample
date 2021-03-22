package com.sap.mobile.mahlwerk.logon

import android.content.Context
import com.sap.cloud.mobile.foundation.common.EncryptionError
import com.sap.cloud.mobile.foundation.common.EncryptionState
import com.sap.cloud.mobile.foundation.common.EncryptionUtil
import com.sap.cloud.mobile.foundation.securestore.OpenFailureException
import com.sap.cloud.mobile.foundation.securestore.SecureKeyValueStore
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import java.util.*
import javax.crypto.Cipher

/**
 * Manages access to encrypted key-value-stores used throughout the application. Two stores are implemented: The
 * [passcodePolicyStore] and the [applicationStore]. The former is used to store information that needs to be available
 * prior to unlocking the app, such as the passcode policy. The latter is used to store any other information, such as
 * user credentials and access tokens.
 */
class SecureStoreManager(private val applicationContext: Context) {

    /** Secure key-value-store that is protected by a default encryption key. */
    private var passcodePolicyStore: SecureKeyValueStore

    /**
     * Secure key-value-store that is optionally protected by user-supplied input, such as a passcode, fingerprint or
     * other biometric data. If the user does not choose to supply such input, it is encrypted using a default
     * encryption key.
     */
    private var applicationStore: SecureKeyValueStore

    /** @return true if passcode (and optionally biometric) protection is enabled */
    var isUserPasscodeSet: Boolean = false
        private set
        get() {
            return EnumSet.of(EncryptionState.PASSCODE_ONLY, EncryptionState.PASSCODE_BIOMETRIC)
                .contains(applicationStoreState)
        }

    /** Indicates current application store encryption status */
    var applicationStoreState: EncryptionState? = null
        private set
        get() {
            return EncryptionUtil.getState(APP_SECURE_STORE_PCODE_ALIAS)
        }

    /** Indicates whether the user completed onboarding */
    var isOnboarded: Boolean
        set(value) {
            doWithPasscodePolicyStore { passcodePolicyStore -> passcodePolicyStore.put(IS_ONBOARDED, value) }
        }
        get() {
            return getWithPasscodePolicyStore { passcodePolicyStore: SecureKeyValueStore ->
                passcodePolicyStore.getBoolean(IS_ONBOARDED)
            } ?: false
        }

//    }

    /** Time frame in days for which passcodes are valid before a new one needs to be created */
    var passcodeExpirationTimeFrame: Int
        set(value) {
            doWithPasscodePolicyStore { passcodePolicyStore ->
                passcodePolicyStore.put(
                    PASSCODE_EXPIRATION_TIME_FRAME_DAYS,
                    value
                )
            }
        }
        get() {
            return getWithPasscodePolicyStore { passcodePolicyStore ->
                passcodePolicyStore.getInt(PASSCODE_EXPIRATION_TIME_FRAME_DAYS)
            } ?: -1
        }

    /** The timestamp (milliseconds) at which the passcode expires */
    var passcodeExpiresAt: Long = 0
        private set
        get() {
            if (passcodeExpirationTimeFrame > 0) {
                val expiresAt = getWithPasscodePolicyStore { passcodePolicyStore ->
                    passcodePolicyStore.getSerializable<Calendar>(ClientPolicyManager.KEY_PC_WAS_SET_AT)
                }
                if (expiresAt != null) {
                    val expiration = expiresAt.add(Calendar.DAY_OF_YEAR, passcodeExpirationTimeFrame)
                    LOGGER.info("Passcode expires at: " + expiration.toString())
                    return expiresAt.timeInMillis
                }
            }
            return 0
        }

    /** A timeout (seconds) of user inactivity before encrypted stores should automatically be closed. */
    var passcodeLockTimeout: Int
        set(value) {
            doWithPasscodePolicyStore { passcodePolicyStore ->
                passcodePolicyStore.put(
                    PASSCODE_POLICY_LOCK_TIMEOUT,
                    value
                )
            }
        }
        get() {
            return getWithPasscodePolicyStore { passcodePolicyStore ->
                passcodePolicyStore.getInt(
                    PASSCODE_POLICY_LOCK_TIMEOUT
                )
            } ?: -1
        }

    /** Indicates the server-side passcode policy status. */
    var isPasscodePolicyEnabled: Boolean
        set(value) {
            doWithPasscodePolicyStore { passcodePolicyStore ->
                passcodePolicyStore.put(
                    IS_PASSCODE_POLICY_ENABLED,
                    value
                )
            }
        }
        get() {
            return getWithPasscodePolicyStore { passcodePolicyStore ->
                passcodePolicyStore.getBoolean(
                    IS_PASSCODE_POLICY_ENABLED
                )
            } ?: true
        }

    /** Indicates whether the currently set passcode has expired. */
    var isPasscodeExpired: Boolean = false
        private set
        get() {
            return if (isPasscodePolicyEnabled && passcodeExpirationTimeFrame != 0) {
                System.currentTimeMillis() - passcodeExpiresAt > 0
            } else {
                false
            }
        }

    /** Indicates status about the opennes of the Application store */
    var isApplicationStoreOpen: Boolean = false
        private set
        get() {
            return applicationStore.isOpen
        }

    /**
     * Creates a new secure store manager bound to the current application context and initializes the encryption
     * utilities required for encryption operations on secure key-value-stores.
     */
    init {
        EncryptionUtil.initialize(applicationContext)
        passcodePolicyStore = SecureKeyValueStore(applicationContext, PASSCODE_SECURE_STORE_NAME)
        applicationStore = SecureKeyValueStore(
            applicationContext,
            APP_SECURE_STORE_NAME
        )
    }

    /**
     * Allows retrieving values from the passcode policy store while managing resources. The opened store instance is
     * passed to [function] and it is closed after the function completes. This method is guarded by
     * [PASSCODE_POLICY_STORE_LOCK]
     *
     * @param [function] Function to perform with the passcode policy store.
     */
    fun <T> getWithPasscodePolicyStore(function: (SecureKeyValueStore) -> T?): T? {
        synchronized(PASSCODE_POLICY_STORE_LOCK) {
            return try {
                openPasscodePolicyStore()
                function(passcodePolicyStore)
            } catch (e: OpenFailureException) {
                LOGGER.error("Passcode secure store couldn't be created at startup.", e)
                null
            } catch (e: EncryptionError) {
                LOGGER.error("Passcode secure store couldn't be created at startup.", e)
                null
            } finally {
                passcodePolicyStore.close()
            }
        }
    }

    /**
     * Allows operations on the passcode policy store while managing resources. The opened store instance is passed to
     * [action] and it is closed after the action completes. This method is guarded by [PASSCODE_POLICY_STORE_LOCK].
     *
     * @param [action] Action to perform with the passcode policy store.
     */
    fun <T> doWithPasscodePolicyStore(action: (SecureKeyValueStore) -> T) {
        synchronized(PASSCODE_POLICY_STORE_LOCK) {
            try {
                openPasscodePolicyStore()
                action(passcodePolicyStore)
            } catch (e: OpenFailureException) {
                LOGGER.error("Passcode secure store couldn't be created at startup.", e)
            } catch (e: EncryptionError) {
                LOGGER.error("Passcode secure store couldn't be created at startup.", e)
            } finally {
                passcodePolicyStore.close()
            }
        }
    }

    /**
     * Allows retrieving values from the application store.
     *
     * @param [function] Function to perform with the passcode policy store
     */
    fun <T> getWithApplicationStore(function: (SecureKeyValueStore) -> T?): T? {
        return function(applicationStore)
    }

    fun doWithApplicationStore(action: (SecureKeyValueStore) -> Unit) {
        //Objects.requireNonNull(action)
        if (!isApplicationStoreOpen) {
            throw IllegalStateException("Application store has not been unlocked yet.")
        }
        action(applicationStore)
    }

    /**
     * Reopens the application store with the provided passcode. This should be done whenever the encryption key (e.g.
     * user passcode) is changed. The provided passcode data is cleared from memory after the operation completes,
     * regardless if it is successful or fails.
     *
     * @param [passcode] new passcode
     * @throws [EncryptionError] if the store cannot be decrypted
     * @throws [OpenFailureException] if the store cannot be opened for other reasons
     */
    @Throws(EncryptionError::class, OpenFailureException::class)
    fun reOpenApplicationStoreWithPasscode(passcode: CharArray) {
        applicationStore.close()
        openApplicationStore(passcode)
    }

    /**
     * Opens the passcode policy store with the default encryption key. The encryption key is cleared from memory after
     * the operation completes, regardless if it was successful or not.
     *
     * @throws [EncryptionError] if the passcode policy store cannot be decrypted
     * @throws [OpenFailureException] if opening the store fails for other reasons
     */
    @Throws(EncryptionError::class, OpenFailureException::class)
    private fun openPasscodePolicyStore() {
        if (!passcodePolicyStore.isOpen) {
            var passcodePolicyStoreKey: ByteArray? = null
            try {
                passcodePolicyStoreKey = EncryptionUtil.getEncryptionKey(PASSCODE_SECURE_STORE_PCODE_ALIAS)
                passcodePolicyStore.open(passcodePolicyStoreKey)
            } finally {
                if (passcodePolicyStoreKey != null) {
                    Arrays.fill(passcodePolicyStoreKey, 0.toByte())
                }
            }
        }
    }

    /**
     * Opens the application store with the default encryption key. The key is cleared from memory after the operation
     * completes, regardless if it is successful or fails.
     *
     * @throws [EncryptionError] if the store cannot be decrypted
     * @throws [OpenFailureException] if the store cannot be opened for other reasons
     */
    @Throws(EncryptionError::class, OpenFailureException::class)
    fun openApplicationStore() {
        if (EnumSet.of(EncryptionState.NO_PASSCODE, EncryptionState.INIT).contains(applicationStoreState)) {
            openApplicationStore(EncryptionUtil.getEncryptionKey(APP_SECURE_STORE_PCODE_ALIAS))
        } else {
            throw OpenFailureException(
                "Expected application store state NO_PASSCODE or INIT but got ${applicationStoreState}",
                null
            )
        }
    }

    /**
     * Opens the application store with the provided encryption key. The key is cleared from memory after the operation
     * completes, regardless if it is successful or fails.
     *
     * @param [encryptionKey] the passcode to use
     * @throws [EncryptionError] if the store cannot be decrypted
     * @throws [OpenFailureException] if the store cannot be opened for other reasons
     */
    @Throws(OpenFailureException::class)
    private fun openApplicationStore(encryptionKey: ByteArray) {
        // Objects.requireNonNull(encryptionKey)
        try {
            if (!applicationStore.isOpen) {
                applicationStore.open(encryptionKey)
            }
        } finally {
            Arrays.fill(encryptionKey, 0.toByte())
        }
    }

    /**
     * Opens the application store with the provided cipher. The encryption key derived from the cipher is cleared from
     * memory after the operation completes, regardless if it is successful or fails.
     *
     * @param [cipher] the cipher to use
     * @throws [EncryptionError] if the store cannot be decrypted
     * @throws [OpenFailureException] if the store cannot be opened for other reasons
     */
    @Throws(OpenFailureException::class, EncryptionError::class)
    fun openApplicationStore(cipher: Cipher) {
        openApplicationStore(
            EncryptionUtil.getEncryptionKey(
                SecureStoreManager.APP_SECURE_STORE_PCODE_ALIAS, cipher
            )
        )
    }

    /**
     * Opens the application store with the provided passcode. The provided passcode data is cleared from memory after
     * the operation completes, regardless if it is successful or fails.
     *
     * @param [passcode] the passcode to use
     * @throws [EncryptionError] if the store cannot be decrypted
     * @throws [OpenFailureException] if the store cannot be opened for other reasons
     */
    @Throws(EncryptionError::class, OpenFailureException::class)
    fun openApplicationStore(passcode: CharArray) {
        try {
            openApplicationStore(
                EncryptionUtil.getEncryptionKey(
                    SecureStoreManager.APP_SECURE_STORE_PCODE_ALIAS, passcode
                )
            )
        } finally {
            Arrays.fill(passcode, ' ')
        }
    }

    fun closeApplicationStore() {
        if (isApplicationStoreOpen) {
            applicationStore.close()
        }
    }

    /**
     * Deletes and recreates the application encrypted key-value-stores, clearing the data within them. After resetting
     * the stores the user onboarding flow should be restarted so that the [applicationStore] can be securely
     * re-encrypted with user-provided credentials.
     */
    fun resetStores() {
        resetApplicationStore()
        resetPasscodePolicyStore()
    }

    /** Deletes the physical application store and any related encryption data. */
    private fun resetApplicationStore() {
        applicationStore.deleteStore(applicationContext)
        try {
            EncryptionUtil.delete(SecureStoreManager.APP_SECURE_STORE_PCODE_ALIAS)
        } catch (encryptionError: EncryptionError) {
            LOGGER.error("Encryption keys (Application Store) couldn't be cleared!")
        } finally {
            applicationStore = SecureKeyValueStore(applicationContext, APP_SECURE_STORE_NAME)
        }
    }

    /** Deletes the physical passcode policy store and any related encryption data. */
    private fun resetPasscodePolicyStore() {
        passcodePolicyStore.deleteStore(applicationContext)
        try {
            EncryptionUtil.delete(SecureStoreManager.PASSCODE_SECURE_STORE_PCODE_ALIAS)
        } catch (encryptionError: EncryptionError) {
            LOGGER.error("Encryption keys (Passcode Policy Store) couldn't be cleared!")
        } finally {
            passcodePolicyStore = SecureKeyValueStore(applicationContext, PASSCODE_SECURE_STORE_NAME)
        }
    }

    companion object {
        /** Identifier of the application secure store */
        private const val APP_SECURE_STORE_NAME = "APP_SECURE_STORE"

        /** Application secure store alias for encryption utility */
        const val APP_SECURE_STORE_PCODE_ALIAS = "app_pc_alias"

        /** Identifier of the application secure store */
        private const val PASSCODE_SECURE_STORE_NAME = "RLM_SECURE_STORE"

        /** Application secure store alias for encryption utility */
        private const val PASSCODE_SECURE_STORE_PCODE_ALIAS = "rlm_pc_alias"

        private const val IS_PASSCODE_POLICY_ENABLED = "isPasscodePolicyEnabled"
        private const val IS_ONBOARDED = "isOnboarded"
        private const val PASSCODE_POLICY_LOCK_TIMEOUT = "passwordPolicyLockTimeout"
        private const val PASSCODE_EXPIRATION_TIME_FRAME_DAYS = "passwordPolicyExpiresInNDays"

        /**
         * Lock preventing concurrent access to the passcode policy store, even between [SecureStoreManager] instances.
         */
        private val PASSCODE_POLICY_STORE_LOCK = Any()

        private val LOGGER: Logger = LoggerFactory.getLogger(SecureStoreManager::class.java)
    }
}
