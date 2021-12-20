# Salesperson App
This application is used by Mahlwerk Store's Sales Persons to place Orders on the Customer's behalf. The salesperson can scan the Machine's Barcode from the template and show the machine details to the customers. The salesperson can also add customers through this application.

## Overview
Mahlwerk Sales Person application is a cross platform mobile application built using SAP Mobile Development Kit.

## Architecture
This application fetches data using the OData end points form Mahlwerk's Mobile Backend. SAP Mobile Services handles the user Authentication and Identitiy management for this application

### MDK Client Version
MDK 6.1 or higher

## Setup & Run

#### Configure a new MDK application in Mobile Services cockpit
1. Navigate to [SAP Mobile Services cockpit](https://developers.sap.com/tutorials/fiori-ios-hcpms-setup.html).
2. On the home screen, select **Create new app**.
    ![MDK](./Screenshots/img-1.png)
3. In **Basic Info** step, provide the required information and click **Next**.

    | Field | Value |
    |----|----|
    | `ID` | com.sap.mdk.salesperson |
    | `Name` | SAP MDK Demo App |

    ![MDK](./Screenshots/img-2.png)

    > If you are configuring this app in a trial account, make sure to select **License Type** as *lite*.

4. In **Assign Features** step, choose **Mobile Development Kit Application** from the dropdown and then click **Finish**.

    ![MDK](./Screenshots/img-3.png)

    >If you see a _Confirm Finish_ window, click **OK**.

    Once you have created your application, you see a list of default features have been automatically assigned to the app.

    ![MDK](./Screenshots/img-4.png)


#### Create a new destination to your MDK Mobile application

1. Click **Mobile Connectivity**.  

    ![MDK](./Screenshots/img-5.png)

2. Click the **Create** icon to add a new destination.

    ![MDK](./Screenshots/img-6.png)

3. In **Basic Info** step, provide the required information and click **Next**.

    | Field | Value |
    |----|----|
    | `Destination Name` | Mahlwerk |
    | `URL` | Your backend OData Service URL generated in [previous exercise](/1_backend_odata_service) |

    ![MDK](./Screenshots/img-7.png)

4. For this tutorial, there is no Custom Headers, Annotations required. Click **Next** to navigate to further steps.

5. Since the current implementation of the OData service doesn't provide any authentication, keep the default **SSO Mechanism** in **Destination Configuration** step as *No Authentication*, click **Next** and then click **Finish**.   


#### Clone Git repository in your SAP Business Application Studio space and deploy MDK project

1. Go to your SAP Business Application Studio space.

2. Clone git repository and upload this folder to SAP's Business Apllication Studio's workspace.

3. Right click `Application.app` in `2_salesperson_mdk_app` folder and select `MDK:Deploy`. 
    ![MDK](./Screenshots/img-8.png)

4. Select deploy target as **Mobile Services**.

   MDK editor will deploy the metadata to Mobile Services.

    ![MDK](./Screenshots/img-9.png)

5. Select Mobile Services landscape, Application id of the application from Mobile services that you created in Mobile Services for this application.

 6. Wait for deploy to finish.

 #### Display the QR code for onboarding the Mobile app

 SAP Business Application Studio has a feature to generate QR code for onboarding the mobile app.

Click the `Application.app` to open it in MDK Application Editor and click **Application QR Code** icon.


 #### Test the application
1. **Download and install:** **SAP Mobile Services Client** on your [iOS](https://apps.apple.com/us/app/sap-mobile-services-client/id1413653544) or [Android](https://play.google.com/store/apps/details?id=com.sap.mobileservices.client) device (If you are connecting to `AliCloud` accounts then you will need to brand your [custom MDK client](cp-mobile-dev-kit-build-client) by allowing custom domains.)

2. Follow the steps to on-board the MDK client on [Android device](https://github.com/SAP-samples/cloud-mdk-tutorial-samples/blob/master/Onboarding-Android-client/Onboarding-Android-client.md) or [iOS device](https://github.com/SAP-samples/cloud-mdk-tutorial-samples/blob/master/Onboarding-iOS-client/Onboarding-iOS-client.md).


## Screenshots
*Coffee Machines* 
![Coffee Machines](./Screenshots/img-10.png)
*Machine Details* 
![Machine Details](./Screenshots/img-11.png)
*New Order > Select a customer*
 ![New Order > Select a customer](./Screenshots/img-12.png)
*Configuration > Select a color* 
![Configuration > Select a color](./Screenshots/img-13.png)
*Configuration > Select the Max Pressure*
 ![Configuration > Select the Max Pressure](./Screenshots/img-14.png)
*Order Summary*
 ![Order Summary](./Screenshots/img-15.png)
*Order being created*
 ![Order being created](./Screenshots/img-16.png)
*Customers*
 ![Customers](./Screenshots/img-17.png)
*Customer Details and Address*
 ![Customer Details](./Screenshots/img-18.png)
*Customer Machines*
 ![Customer Machine](./Screenshots/img-19.png)
*Machine Details*
 ![Customer Machine](./Screenshots/img-20.png)
*User Settings*
 ![User Settings](./Screenshots/img-21.png)
*User Actions*
 ![User Actions](./Screenshots/img-22.png)
*New Customer*
 ![New Customer](./Screenshots/img-24.png)
*Scan a barcode*
 ![Scanner result](./Screenshots/img-23.png)



