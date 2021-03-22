package com.sap.mobile.mahlwerk.test.pages;


import androidx.test.InstrumentationRegistry;
import androidx.test.uiautomator.UiDevice;
import androidx.test.uiautomator.UiObject;
import androidx.test.uiautomator.UiObjectNotFoundException;
import androidx.test.uiautomator.UiSelector;

import com.sap.mobile.mahlwerk.test.core.AbstractLoginPage;
import com.sap.mobile.mahlwerk.test.core.Credentials;
import com.sap.mobile.mahlwerk.test.core.UIElements;
import com.sap.mobile.mahlwerk.test.core.WizardDevice;

import static androidx.test.espresso.Espresso.onView;
import static androidx.test.espresso.action.ViewActions.click;
import static androidx.test.espresso.assertion.ViewAssertions.matches;
import static androidx.test.espresso.matcher.RootMatchers.isDialog;
import static androidx.test.espresso.matcher.ViewMatchers.isDisplayed;
import static androidx.test.espresso.matcher.ViewMatchers.withId;

public class LoginPage {

    public static class BasicAuthPage extends AbstractLoginPage {

        public BasicAuthPage() {
            uiDevice = UiDevice.getInstance(InstrumentationRegistry.getInstrumentation());
        }

        @Override
        public void authenticate() {

            UiObject usernameField = uiDevice.findObject(new UiSelector()
                    .resourceId(UIElements.LoginScreen.BasicAuthScreen.usernameID));
            usernameField.waitForExists(WAIT_TIMEOUT);

            // Click to the input field
            WizardDevice.fillInputField(UIElements.LoginScreen.BasicAuthScreen.usernameText, Credentials.USERNAME);
            WizardDevice.fillInputField(UIElements.LoginScreen.BasicAuthScreen.passwordText, Credentials.PASSWORD);

            // Click Login on the dialog
            onView(withId(UIElements.LoginScreen.BasicAuthScreen.okButton)).inRoot(isDialog()).check(matches(isDisplayed())).perform(click());
        }

        public void useWrongCredentials() {

            UiObject usernameField = uiDevice.findObject(new UiSelector()
                    .resourceId(UIElements.LoginScreen.BasicAuthScreen.usernameID));
            usernameField.waitForExists(WAIT_TIMEOUT);

            // Click to the input field
            WizardDevice.fillInputField(UIElements.LoginScreen.BasicAuthScreen.usernameText, Credentials.WRONGUSERNAME);
            WizardDevice.fillInputField(UIElements.LoginScreen.BasicAuthScreen.passwordText, Credentials.WRONGPASSWORD);

            // Click Login on the dialog
            onView(withId(UIElements.LoginScreen.BasicAuthScreen.okButton)).inRoot(isDialog()).check(matches(isDisplayed())).perform(click());
        }
    }

    public static class WebviewPage extends AbstractLoginPage {

        public WebviewPage() {
            uiDevice = UiDevice.getInstance(InstrumentationRegistry.getInstrumentation());
        }

        @Override
        public void authenticate() {
            fillCredentials();
            // Check whether it's oauth or not
            UiObject authButton = uiDevice.findObject(new UiSelector()
                    .resourceId(UIElements.LoginScreen.OauthScreen.oauthAuthorizeButton));
            if (authButton.waitForExists(WAIT_TIMEOUT)) {
                // Oauth case
                clickAuthorizeButton();
            }
        }

        private void fillCredentials() {

            UiObject usernameField = uiDevice.findObject(new UiSelector()
                    .resourceId(UIElements.LoginScreen.OauthScreen.oauthUsernameText));

            usernameField.waitForExists(WAIT_TIMEOUT);

            UiObject passwordField = uiDevice.findObject(new UiSelector()
                    .resourceId(UIElements.LoginScreen.OauthScreen.oauthPasswordText));

            UiObject logonButton = uiDevice.findObject(new UiSelector()
                    .resourceId(UIElements.LoginScreen.OauthScreen.oauthLogonButton));


            try {
                usernameField.clearTextField();
                usernameField.setText(Credentials.USERNAME);
                passwordField.clearTextField();
                passwordField.setText(Credentials.PASSWORD);
                logonButton.click();
            } catch (UiObjectNotFoundException e) {
                // TODO error handling
            }

        }

        private void useWrongCredentials() {

            UiObject usernameField = uiDevice.findObject(new UiSelector()
                    .resourceId(UIElements.LoginScreen.OauthScreen.oauthUsernameText));

            usernameField.waitForExists(WAIT_TIMEOUT);

            UiObject passwordField = uiDevice.findObject(new UiSelector()
                    .resourceId(UIElements.LoginScreen.OauthScreen.oauthPasswordText));

            UiObject logonButton = uiDevice.findObject(new UiSelector()
                    .resourceId(UIElements.LoginScreen.OauthScreen.oauthLogonButton));


            try {
                usernameField.clearTextField();
                usernameField.setText(Credentials.WRONGUSERNAME);
                passwordField.clearTextField();
                passwordField.setText(Credentials.WRONGPASSWORD);
                logonButton.click();
            } catch (UiObjectNotFoundException e) {
                // TODO error handling
            }

        }

        private void clickAuthorizeButton() {
            UiObject authButton = uiDevice.findObject(new UiSelector()
                    .resourceId(UIElements.LoginScreen.OauthScreen.oauthAuthorizeButton));
            try {
                authButton.clickAndWaitForNewWindow();
            } catch (UiObjectNotFoundException e) {
                // TODO error handling
            }
        }

    }

    public static class NoAuthPage extends AbstractLoginPage {

        @Override
        public void authenticate() {
            // in no-auth case we don't need to authenticate
        }
    }


}
