# Mahlwerk - Technician iOS App

![Header Image](images/Header_ios.png)

## Overview

This native iOS application is used by Mahlwerk's Technician to view and process various tasks.  

This application consumes Mahlwerk's Backend's Odata Service for fetching the task details and for all of its operations.

## Architecture

- *SAP BTP SDK for iOS* is used for User Authentication, Fiori UI Controls, Onboarding and Offline Data Synchronization.

## Build Setup

1. Install [Cocoapods](https://cocoapods.org/) dependency manager.
2. Install Apple Xcode IDE.
3. [Configure your machine](https://github.com/SAP-samples/cloud-sdk-ios-specs#obtaining-technical-user--password) for securely downloading the SAP BTP SDK for iOS frameworks
4. Clone the repository and run `pod install` in this directory.
5. Open `Mahlwerk.xcworkspace` in Xcode.

### Configure App to your Mobile services Credentials

1. Copy the *App ID* from Mobile services cockpit:
![Application Details AppID](images/AppId.png)

2. Copy the Destination Name (used as *Destination ID*) from the Mobile Connectivity feature of your app in Mobile services cockpit:
![OnboardingFlowProvider.swift](images/Destination.png)

3. Set the *App ID* as value for the field *Application Identifier* and *Destination ID* for *Destinations > Technician* of *AppParameters.plist* file:
![OnboardingFlowProvider.swift](images/AppParameters.png)

4. Update the *Redirect URL, Authorization End Point, Client Id, Token EndPoint* to your application credentials in *ConfigurationProvider.plist*.
![Mobile Services Security Tab](images/Authorization.png)

  | P List Label | Copy Value | Cockpit Location |
  | --- | --- | --- |
  | `clientID` | Client ID | Security Tab |
  | `redirectURL` | Redirect URL | Security Tab |
  | `oauth2.endUserUI` | Redirect URL | Security Tab |
  | `oauth2.authorizationEndpoint` | OAuth Authorization URL | Security Tab |
  | `oauth2.tokenEndpoint` | OAuth Token URL | Security Tab |
  | `host` | Redirect URL without the https protocol | Security Tab |

  ![ConfigurationProvider.plist file](images/ConfigProvider.png)

## Screenshots

<p align="center">
  <b>Browse different tasks:</b><br>
  <img src="images/Tasks.png" width="35%">
</p>
<br><br>

<p align="center">
  <b>View task details:</b><br>
  <img src="images/ScheduledTask.png" width="35%">
</p>
<br><br>

<p align="center">
  <b>Update task status:</b><br>
  <img src="images/ChangeStatus.png" width="35%">
</p>
<br><br>

<p align="center">
  <b>View location of task:</b><br>
  <img src="images/Navigation.png" width="35%">
</p>
<br><br>

<p align="center">
  <b>View locations of all tasks:</b><br>
  <img src="images/MapTasks.png" width="35%">
</p>
<br><br>

<p align="center">
  <b>View customer details:</b><br>
  <img src="images/Profile.png" width="35%">
</p>
