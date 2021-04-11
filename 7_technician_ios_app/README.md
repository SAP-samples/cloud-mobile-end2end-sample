# Mahlwerk - Technician iOS App

![Header Image](images/header_ios.png)

## Overview 

This native iOS application is used by Mahlwerk's Technician to view and process various tasks.  

This application consumes Mahlwerk's Backend's Odata Service for fetching the task details and for all of its operations. 

## Architecture

- *SAP BTP SDK for iOS* is used for User Authentication, Fiori UI Controls, Onboarding and Offline Data Synchronization. 

## Build Setup
- Install the [SAP BTP SDK for iOS](https://developers.sap.com/tutorials/fiori-ios-hcpms-install-sdk.html) version 5 or newer.
- Clone this repository and execute `sh scripts/refreshframeworks.sh` in the this directory.
- Open `Mahlwerk.xcodeproj` in Xcode.

## Configure App to your Mobile services Credentials

-  Copy the *App ID* from Mobile services cockpit:
![Application Details AppID](images/AppId.png)

- Put the *App ID* into the highlighted place in *OnboardingFlowProvider.swift*:
![OnboardingFlowProvider.swift](images/OFP.png)

- Copy the *App Id* (see first step) & *Server URL* (from API Tab) from Mobile services cockpit and paste it in *ODataOnBoardingStep.swift*.
![ODataOnBoardingStep.swift](images/OOS.png)

- Change the *AppId, Redirect URL , Authorization End Point, Client Id, Token EndPoint* to your Application credentials in Mobile Services Cockpit. 
![Mobile Services Security Tab](images/Authorization.png)

- Copy *Client ID, Redirect Url, OAuth Authorization URL, OAuth Token URL* from Security Tab in SAP Mobile Services cockpit.

- Paste these credentials in *ConfigurationsProvider.plist* file
- Redirect URL in *OAUTH_REDIRECT_URL* & *endUserUI*
- Client Id in *OAUTH_CLIENT_ID*
- OAuth Authorization URL in *AUTH_END_POINT*
- OAuth Token URL in *TOKEN_END_POINT*

![ConfigurationProvider.plist file](images/ConfigProvider.png)

## Screenshots

<center>
<img align="center" src="images/Tasks.png" width="35%">

Browse different tasks
</center>
<br>
<center>
<img align="center" src="images/ScheduledTask.png" width="35%">

View task details
</center>
<br>
<center>
<img align="center" src="images/ChangeStatus.png" width="35%">

Update task status
</center>
<br>
<center>
<img align="center" src="images/Navigation.png" width="35%">

Display location of task
</center>
<br>
<center>
<img align="center" src="images/MapTasks.png" width="35%">

Display locations of all tasks
</center>
<br>
<center>
<img align="center" src="images/Profile.png" width="35%">

View customer details
</center>
