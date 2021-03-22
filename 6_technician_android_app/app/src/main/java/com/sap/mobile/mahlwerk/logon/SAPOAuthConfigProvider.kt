package com.sap.mobile.mahlwerk.logon

import android.content.Context

import com.sap.cloud.mobile.foundation.authentication.OAuth2Configuration

/**
 * This class provides the OAuth configuration object for the application.
 *
 */
object SAPOAuthConfigProvider {

    private val OAUTH_REDIRECT_URL = "<Enter Your Redirect URL here>"
    private val OAUTH_CLIENT_ID = "<Enter your Client ID here>"
    private val AUTH_END_POINT = "<Enter your OAuth Authorization URL here>"
    private val TOKEN_END_POINT = "<Enter your OAuth Token URL here>"

    @JvmStatic fun getOAuthConfiguration(context: Context): OAuth2Configuration {

        return OAuth2Configuration.Builder(context)
                .clientId(OAUTH_CLIENT_ID)
                .responseType("code")
                .authUrl(AUTH_END_POINT)
                .tokenUrl(TOKEN_END_POINT)
                .redirectUrl(OAUTH_REDIRECT_URL)
                .build()
    }


}
