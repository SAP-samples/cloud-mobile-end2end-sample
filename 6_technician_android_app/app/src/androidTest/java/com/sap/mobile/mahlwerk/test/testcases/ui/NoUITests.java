package com.sap.mobile.mahlwerk.test.testcases.ui;

import androidx.test.rule.ActivityTestRule;
import androidx.test.runner.AndroidJUnit4;

import com.sap.mobile.mahlwerk.logon.LogonActivity;
import com.sap.mobile.mahlwerk.test.core.BaseTest;
import com.sap.mobile.mahlwerk.test.core.Utils;
import com.sap.mobile.mahlwerk.test.pages.NoUIPage;

import org.junit.Rule;
import org.junit.Test;
import org.junit.runner.RunWith;

@RunWith(AndroidJUnit4.class)
public class NoUITests extends BaseTest {

    @Rule
    public ActivityTestRule<LogonActivity> activityTestRule = new ActivityTestRule<>(LogonActivity.class);

    @Test
    public void testNoUI() {

        // First do the onboarding flow
        Utils.doOnboarding();

        // Check NoUI screen
        NoUIPage noUIPage = new NoUIPage();

    }

}
