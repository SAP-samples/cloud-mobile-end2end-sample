# Salesperson App
This application is used by Mahlwerk Store's Sales Persons to place Orders on the Customer's behalf. The salesperson can scan the Machine's Barcode from the template and show the machine details to the customers. The salesperson can also add customers through this application.

## Overview
Mahlwerk Sales Person application is a cross platform mobile application built using SAP Mobile Development Kit.

## Architecture
This application fetches data using the OData end points form Mahlwerk's Mobile Backend. SAP Mobile Services handles the user Authentication and Identitiy management for this application

### MDK Client Version
MDK 6.1 or higher

## Setup & Run

1. Goto your SAP Business Application Studio space.

2. Clone git repository and upload this folder to SAP's Business Apllication Studio's workspace.

3. Click on Bottom left of the window & select your mobile services organization.
![Mobile Services Organization](Images/1.png)

4. Select Space.
![Mobile Services Space](Images/2.png)

5. Go to *View*  in the menu section, and click on command Palette.
![See Command Palette](Images/3.png)

6. Search *MDK* and select *MDK : Deploy* . 
![Run MDK Deploy](Images/4.png)

7. Select the application to deploy.
![Select application](Images/5.png)

8. Select *Mobile Services* as the target.
![Select target](Images/6.png)

9. Select application id of the application from Mobile services that you created in Mobile Services for this application.
![Select APP Id from Mobile Services](Images/7.png)

10. Wait for deploy to finish.
![Deploying to Mobile Services](Images/8.png)

11. Finally, go to your Mobile Services Space and then go to *APIs Tab* and scan the QR code from the Mobile Services application on your device.
![App QR Code](Images/9.png)

## Screens
![Coffee Machines](Images/screens/1.jpeg)
![Machine Details](Images/screens/2.jpeg)
![New Order > Select a customer](Images/screens/3.jpeg)
![Configuration > Select a color](Images/screens/4.jpeg)
![Configuration > Select the Max Pressure](Images/screens/5.jpeg)
![Order Summary](Images/screens/6.jpeg)
![Order being created](Images/screens/7.jpeg)
![Customers](Images/screens/8.jpeg)
![Customer machines](Images/screens/9.jpeg)
![Customer Machine Details](Images/screens/10.jpeg)
![User Settings](Images/screens/11.jpeg)
![User Actions](Images/screens/12.jpeg)
![Scanner result](Images/screens/13.jpeg)
![New Customer](Images/screens/14.jpeg)


