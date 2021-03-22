
var clientAPI;

export default function CloseAllPages(context) {
	
	return (
	context.executeAction('/Mahlwerk_Sales/Actions/Service/SyncStartedMessage.action'),
	context.executeAction('/Mahlwerk_Sales/Actions/CloseModalPage_Complete.action'),
	context.executeAction('/Mahlwerk_Sales/Actions/ClosePage.action')
	)
}
