package com.sap.mobile.mahlwerk.test.core;

import android.os.Build;
import android.os.RemoteException;
import android.os.SystemClock;

import androidx.test.espresso.ViewInteraction;
import androidx.test.rule.ActivityTestRule;
import androidx.test.uiautomator.By;
import androidx.test.uiautomator.UiDevice;
import androidx.test.uiautomator.UiObject;
import androidx.test.uiautomator.UiObjectNotFoundException;
import androidx.test.uiautomator.UiSelector;
import androidx.test.uiautomator.Until;

import com.sap.mobile.mahlwerk.R;

import java.io.IOException;

import static androidx.test.InstrumentationRegistry.getInstrumentation;
import static androidx.test.espresso.Espresso.onView;
import static androidx.test.espresso.action.ViewActions.click;
import static androidx.test.espresso.action.ViewActions.closeSoftKeyboard;
import static androidx.test.espresso.action.ViewActions.replaceText;
import static androidx.test.espresso.assertion.ViewAssertions.matches;
import static androidx.test.espresso.matcher.ViewMatchers.isDisplayed;
import static androidx.test.espresso.matcher.ViewMatchers.withId;

public class WizardDevice {

    public static boolean fromBackground = false;

    public static void putApplicationBackground(long wait, ActivityTestRule<?> activityTestRule) {
        // input keyevent 3
        UiDevice uiDevice = UiDevice.getInstance(getInstrumentation());
        try {
            uiDevice.executeShellCommand("input keyevent 3");
        } catch (IOException e) {
            e.printStackTrace();
        }
        if (wait == 0) {
            wait = 1000;
        }
        SystemClock.sleep(wait);
    }

    public static void reopenApplication() {
        fromBackground = true;
        UiDevice uiDevice = UiDevice.getInstance(getInstrumentation());
        try {
            uiDevice.pressRecentApps();
            if (Build.VERSION.SDK_INT >= 28) {
                // If you press the recent app twice, it will reopen the application
                SystemClock.sleep(200);
                uiDevice.pressRecentApps();
                return;
            }
        } catch (RemoteException e) {
            e.printStackTrace();
        }
        String appName = Utils.getResourceString(R.string.application_name);
        UiObject app = uiDevice.findObject(new UiSelector().text(appName));
        try {
            app.click();
            // Some devices need two clicks.
            app.click();
        } catch (UiObjectNotFoundException e) {
            e.printStackTrace();
        }
        uiDevice.wait(Until.hasObject(By.pkg("com.sap.mobile.mahlwerk").depth(0)),
                2000);
    }

    public static void fillInputField(int UIElement, String text) {
        // Click to the element
        onView(withId(UIElement)).perform(click()).check(matches(isDisplayed()));

        // Fill the text
        ViewInteraction exitText = onView(withId(UIElement)).check(matches(isDisplayed()));
        exitText.perform(replaceText(text), closeSoftKeyboard());

    }


}
