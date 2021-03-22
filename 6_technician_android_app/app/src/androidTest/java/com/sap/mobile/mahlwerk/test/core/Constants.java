package com.sap.mobile.mahlwerk.test.core;

public class Constants {

    public enum AuthType {
        BASIC, OAUTH, SAML, NOAUTH
    }

    public enum OnboardingType {
        DISCOVERY_SERVICE, STANDARD
    }


    public final static AuthType APPLICATION_AUTH_TYPE = AuthType.OAUTH;
    public final static int NETWORK_REQUEST_TIMEOUT = 5000;

    public static OnboardingType ONBOARDING_TYPE = OnboardingType.STANDARD;

}
