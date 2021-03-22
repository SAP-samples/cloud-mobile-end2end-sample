package com.sap.mobile.mahlwerk.logon

import ch.qos.logback.classic.Level
import com.sap.cloud.mobile.onboarding.passcode.PasscodePolicy
import java.io.Serializable

/**
 * Wrapper class which contains the client policies, which could arrive from the server. It contains the
 * [PasscodePolicy], the log settings and some boolean flags, e.g. whether passode policy is enabled.
 */
class ClientPolicy: Serializable {

    var isPasscodePolicyEnabled: Boolean? = null
    var passcodePolicy: PasscodePolicy? = null
    var logLevel: Level? = null
    var isLogEnabled: Boolean? = null

    companion object {
        private const val serialVersionUID: Long = 1
    }
}