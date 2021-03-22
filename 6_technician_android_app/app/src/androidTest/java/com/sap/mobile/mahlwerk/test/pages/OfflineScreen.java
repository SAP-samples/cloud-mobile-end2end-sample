package com.sap.mobile.mahlwerk.test.pages;

import androidx.test.InstrumentationRegistry;
import androidx.test.uiautomator.UiDevice;
import androidx.test.uiautomator.UiObject;
import androidx.test.uiautomator.UiSelector;

import com.pgssoft.espressodoppio.idlingresources.ViewIdlingResource;
import com.sap.mobile.mahlwerk.test.core.UIElements;

import java.util.concurrent.TimeUnit;

import static androidx.test.espresso.matcher.ViewMatchers.withId;

public class OfflineScreen {

    private ViewIdlingResource viewIdlingResource;

    public OfflineScreen() {
        viewIdlingResource = (ViewIdlingResource) new ViewIdlingResource(
                withId(UIElements.OfflineScreen.progressbar)).register();
    }

    public void waitUntilPageIsOver() {
        UiDevice uiDevice = UiDevice.getInstance(InstrumentationRegistry.getInstrumentation());
        UiObject progressBar = uiDevice.findObject(new UiSelector()
                .resourceId(UIElements.OfflineScreen.progressBar));
        progressBar.waitUntilGone(TimeUnit.MINUTES.toMillis(7));
    }

    public void leavePage() {
        viewIdlingResource.unregister();
    }
}