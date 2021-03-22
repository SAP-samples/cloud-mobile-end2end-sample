package com.sap.mobile.mahlwerk.test.core;

import androidx.test.uiautomator.UiObject;
import androidx.test.uiautomator.UiObjectNotFoundException;
import androidx.test.uiautomator.UiSelector;

import static androidx.test.espresso.Espresso.onView;
import static androidx.test.espresso.action.ViewActions.click;
import static androidx.test.espresso.matcher.ViewMatchers.withId;

public abstract class AbstractPasscodePage {

    public void clickNext() {
        if (WizardDevice.fromBackground) {
            try {
                new UiObject(new UiSelector().resourceId("com.sap.mobile.mahlwerk:id/done_button")).click();
            } catch (UiObjectNotFoundException e) {
                e.printStackTrace();
            }
        } else {
            onView(withId(UIElements.PasscodeScreen.nextButton)).perform(click());
        }
    }

    public void clickSecondNext() {
        onView(withId(UIElements.PasscodeScreen.secondNextButton)).perform(click());
    }

    public void skipFingerprint() {
        onView(withId(UIElements.SetFingerprintPage.skipFingerpintButton)).perform(click());
    }

    public void clickCancelButton() {
        onView(withId(UIElements.PasscodeScreen.cancelButton)).perform(click());
    }

    public void clickDefault() {
        onView(withId(UIElements.PasscodeScreen.useDefaultButton)).perform(click());
    }
}
