package com.sap.mobile.mahlwerk.logon

import android.net.Uri

import com.sap.cloud.mobile.foundation.authentication.OAuth2Token
import com.sap.cloud.mobile.foundation.authentication.OAuth2TokenStore

/**
 * Class which is used to store OAuth tokens. The tokens are persisted in the application's
 * secure store via the SecureStoreManager.  OAuth tokens for URLs with different hosts are stored
 * separately.
 */
class SAPOAuthTokenStore(private val secureStoreManager: SecureStoreManager) : OAuth2TokenStore {

    override fun storeToken(oAuth2Token: OAuth2Token, url: String) {
        secureStoreManager.doWithApplicationStore { applicationStore ->
            applicationStore.put(
                key(url),
                oAuth2Token
            )
        }
    }

    override fun getToken(url: String): OAuth2Token? {
        var retVal: OAuth2Token? = null
        if (secureStoreManager.isApplicationStoreOpen) {
            retVal = secureStoreManager.getWithApplicationStore<OAuth2Token> { applicationStore ->
                applicationStore.getSerializable(key(url))
            }
        }
        return retVal
    }

    override fun deleteToken(url: String) {
        secureStoreManager.doWithApplicationStore { applicationStore ->
            applicationStore.remove(key(url))
        }
    }

    private fun key(url: String): String {
        return Uri.parse(url).host ?: ""
    }
}
