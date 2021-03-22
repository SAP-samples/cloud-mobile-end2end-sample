package com.sap.mobile.mahlwerk.test.pages;

import androidx.test.InstrumentationRegistry;
import androidx.test.uiautomator.UiDevice;
import androidx.test.uiautomator.UiObject;
import androidx.test.uiautomator.UiSelector;

import com.pgssoft.espressodoppio.idlingresources.ViewIdlingResource;
import com.sap.mobile.mahlwerk.test.core.UIElements;

import static androidx.test.espresso.Espresso.onView;
import static androidx.test.espresso.action.ViewActions.click;
import static androidx.test.espresso.action.ViewActions.closeSoftKeyboard;
import static androidx.test.espresso.matcher.ViewMatchers.withId;
import static com.sap.mobile.mahlwerk.test.core.Constants.APPLICATION_AUTH_TYPE;

public class WelcomePage {

    // Default constructor
    public WelcomePage() {
        ViewIdlingResource viewIdlingResource = (ViewIdlingResource) new ViewIdlingResource(
                withId(UIElements.WelcomePage.getStartedButton)).register();

    }

    public void clickGetStarted() {
        // Close the soft keyboard first, since it might be covering the get started button.
        onView(withId(UIElements.WelcomePage.getStartedButton)).perform(closeSoftKeyboard(), click());
    }

public void waitForCredentials() {
        if (APPLICATION_AUTH_TYPE == APPLICATION_AUTH_TYPE.BASIC) {
            UiDevice uiDevice = UiDevice.getInstance(InstrumentationRegistry.getInstrumentation());
            UiObject usernameField = uiDevice.findObject(new UiSelector()
                    .resourceId(UIElements.LoginScreen.BasicAuthScreen.usernameID));
            usernameField.waitForExists(2000);
        } else if (APPLICATION_AUTH_TYPE == APPLICATION_AUTH_TYPE.OAUTH || APPLICATION_AUTH_TYPE == APPLICATION_AUTH_TYPE.SAML) {
            UiDevice uiDevice = UiDevice.getInstance(InstrumentationRegistry.getInstrumentation());
            UiObject usernameField = uiDevice.findObject(new UiSelector()
                    .resourceId(UIElements.LoginScreen.OauthScreen.oauthUsernameText));
            usernameField.waitForExists(2000);
        }
    }
}
