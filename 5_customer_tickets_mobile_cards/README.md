# Tickets App for Customer

## Overview

Mahlwerk Ticket Card gives you the details of the ticket you raised using Mahlwerk Machine Card. You can see the scheduled date, the status of your ticket, the machine you raised a ticket for, customer details and so on. It also provides the details of the Technician i.e. name, contact number, email id etc. You can call, text or email the technician using the card. The card also provides the capability to close the ticket upon resolution.

## Architecture

Mobile Cards is one of the offerings of SAP Mobile Services. It is a low code solution that helps businesses seamlessly mobilize their enterprise data. Using SAP Mobile Cards application you can see various cards showing different information to you in one app, that is, you don't have to download separate custom mobile applications.

See [Mobile Cards documentation](https://help.sap.com/doc/f53c64b93e5140918d676b927a3cd65b/Cloud/en-US/docs-en/guides/getting-started/mck/mck-overview.html) for details.

Mahlwerk Tickets Card is a SAP Mobile Card through which the customer can see their ticket's details on their device and can close a ticket for their issue when it is resolved.
The card can be reused for any use case and to do so, you just need to update your backend destination.

## Prerequisites

[Trial Account on SAP BTP](https://developers.sap.com/tutorials/hcp-create-trial-account.html)

[Set up SAP Mobile Cards](https://developers.sap.com/tutorials/cp-mobile-cards-setup.html)

[Set up Business Application Studio for Mobile Development](https://developers.sap.com/mission.mobile-cards-develop.html)

## Setup and Run

1. Clone the GitHub repository into your Business Application Studio.
2. Open metadata.json in the code editor and change the Connection (line 4) to point to your destination.

    **NOTE:** To create a destination: In your mobile services cockpit, go inside SAP Mobile Cards &rarr; Features &rarr; Mobile Connectivity. Click on create button, add destination name and URL of your backend service, click Next and then click Finish. 

3. Deploy and publish your Card.
4. Open your SAP Mobile Cards application and subscribe to the Mahlwerk Tickets Card by providing your Customer ID. 

    **NOTE:** If the cards are not visible, then do a pull refresh to see them.

**For Android Device:**

5. Tap on expand action button and you will see options like Call or Message or Email. Tap on Call if you want to call the technician and so on.
6. Tap on expand action button and Tap on Close Ticket. Your Ticket will be closed.

**For iOS Device:**

5. Tap on actions menu and you will see options like Call or Message or Email. Tap on Call if you want to call the technician and so on.
6. Tap on actions menu and Tap on Close Ticket. Your Ticket will be closed.

## Screenshot

### Android

#### Front

![Mahlwerk Ticket Card Android Front Screenshot](screens/android_front.png)

#### Back

![Mahlwerk Ticket Card Android Back Screenshot](screens/android_back.png)

### iOS

#### Front

![Mahlwerk Ticket Card iOS Front Screenshot](screens/ios_front1.png)
![Mahlwerk Ticket Card iOS Front Screenshot](screens/ios_front2.png)

#### Back

![Mahlwerk Ticket Card iOS Back Screenshot](screens/ios_back.png)

<hr>
© 2021 SAP SE
<hr>