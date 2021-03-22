package com.sap.mobile.mahlwerk.test.pages;

import android.app.Activity;

import androidx.test.InstrumentationRegistry;
import androidx.test.uiautomator.UiDevice;
import androidx.test.uiautomator.UiObject;
import androidx.test.uiautomator.UiSelector;

import com.sap.mobile.mahlwerk.test.core.UIElements;
import com.sap.mobile.mahlwerk.test.core.Utils;

import static androidx.test.espresso.Espresso.onView;
import static androidx.test.espresso.action.ViewActions.click;
import static androidx.test.espresso.assertion.ViewAssertions.matches;
import static androidx.test.espresso.matcher.ViewMatchers.isDisplayed;
import static androidx.test.espresso.matcher.ViewMatchers.withId;

public class ErrorPage {
    private static final int WAIT_TIMEOUT = 2000;
    UiDevice device;
    Activity activity;

    public ErrorPage(Activity activity) {
        this.activity = activity;
        device = UiDevice.getInstance(InstrumentationRegistry.getInstrumentation());
    }

    public String getErrorTitle() throws InterruptedException {
        UiObject usernameField = device.findObject(new UiSelector()
                .resourceId(UIElements.ErrorScreen.titleResourceId));
        usernameField.waitForExists(WAIT_TIMEOUT);
        // For some reason android.R.id.alertTitle isn't defined, so we have to use getIdentifier.
        return Utils.getStringFromUiWithId(activity.getResources().getIdentifier("alertTitle", "id", "android"));
    }

    public String getErrorMessage() throws InterruptedException {
        UiObject usernameField = device.findObject(new UiSelector()
                .resourceId(UIElements.ErrorScreen.messageResourceId));
        usernameField.waitForExists(WAIT_TIMEOUT);
        return Utils.getStringFromUiWithId(UIElements.ErrorScreen.messageId);
    }

    public void dismiss() {
        onView(withId(UIElements.ErrorScreen.okButton)).check(matches(isDisplayed())).perform(click());
    }
}
