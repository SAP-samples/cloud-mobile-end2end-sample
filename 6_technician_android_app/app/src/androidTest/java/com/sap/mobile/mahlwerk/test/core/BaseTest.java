package com.sap.mobile.mahlwerk.test.core;

import androidx.test.uiautomator.UiDevice;

import org.junit.AfterClass;
import org.junit.BeforeClass;

import java.io.IOException;

import static androidx.test.InstrumentationRegistry.getInstrumentation;

public class BaseTest {

    @BeforeClass
    public static void setUp() {
        UiDevice uiDevice = UiDevice.getInstance(getInstrumentation());
        try {
            uiDevice.executeShellCommand("settings put secure show_ime_with_hard_keyboard 0");
            uiDevice.executeShellCommand("settings put global window_animation_scale 0");
            uiDevice.executeShellCommand("settings put global transition_animation_scale 0");
            uiDevice.executeShellCommand("settings put global animator_duration_scale 0");
        } catch (IOException e) {
            e.printStackTrace();
        }

    }

    @AfterClass
    public static void tearDown() {
        UiDevice uiDevice = UiDevice.getInstance(getInstrumentation());
        try {
            uiDevice.executeShellCommand("settings put secure show_ime_with_hard_keyboard 1");
            uiDevice.executeShellCommand("settings put global window_animation_scale 1");
            uiDevice.executeShellCommand("settings put global transition_animation_scale 1");
            uiDevice.executeShellCommand("settings put global animator_duration_scale 1");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
