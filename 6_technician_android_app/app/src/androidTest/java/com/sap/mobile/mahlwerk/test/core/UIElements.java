package com.sap.mobile.mahlwerk.test.core;

import com.sap.mobile.mahlwerk.R;

public class UIElements {

    public static class WelcomePage {
        public static int getStartedButton = R.id.launchscreen_button_primary;
        public static int getStartedText = R.id.launchscreen_title;
    }

    public static class ActivationPage {
        public static int startButton = R.id.activationscreen_button_discovery;
        public static int emailText = R.id.activation_email_address;
    }

    public static class LoginScreen {
        // Login screen elements including Basic / Oauth / SAML / Noauth elements

        public static class BasicAuthScreen {
            public static String usernameID = "com.sap.mobile.mahlwerk:id/username";
            public static int usernameText = R.id.username;
            public static int passwordText = R.id.password;
            public static int okButton = android.R.id.button1;

        }

        public static class OauthScreen {
            public static String oauthUsernameText = "j_username";
            public static String oauthPasswordText = "j_password";
            public static String oauthLogonButton = "logOnFormSubmit";
            public static String oauthAuthorizeButton = "buttonAuthorize";
        }
    }
     public static class OfflineScreen {
         public static String progressBar = "com.sap.mobile.mahlwerk:id/progressbar";
         public static int progressbar = R.id.progressbar;
     }
    public static class PasscodeScreen {
        // Passcode screen elements including the all pages
        public static int createPasscodeText = R.id.passcode_field;
        public static int verifyPasscodeText = createPasscodeText;
        public static int enterPasscodeText = createPasscodeText;
        public static int nextButton = R.id.done_button;
        public static int secondNextButton = R.id.second_done_button;
        public static int cancelButton = R.id.skip_button;
        public static int useDefaultButton = R.id.skip_button;
        public static int reachedRetryLimitTitle = R.string.max_retries_title;
        public static int reachedRetryLimitMessage = R.string.max_attempts_reached_message;
        public static int backButton = R.id.cancel_button;
        public static int retryLimitDialog = R.id.action_bar_root;
        public static int resetAppButton = android.R.id.button2;
    }

    public static class SetFingerprintPage {
        //Set fingerprint page elements
        public static int confirmFingerprintLabel = R.id.confirm_fingerprint_detail_label;
        public static int skipFingerpintButton = R.id.confirm_fingerprint_try_password_button;
    }

    public static class ErrorScreen {
        public static String titleResourceId = "android:id/alertTitle";
        public static String messageResourceId = "android.R.id/message";
        public static int messageId = android.R.id.message;
        public static int okButton = android.R.id.button1;
    }

    public static class NoUIScreen{
        public static String helloWorldTextID = "Hello World!";
    }

}
