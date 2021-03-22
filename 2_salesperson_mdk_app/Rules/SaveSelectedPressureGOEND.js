
var clientAPI;

export default function SaveSelectedCustomerGOEND(context) {
	
	context.getPageProxy().getClientData()["SavedSelectedPressure"] = context.getPageProxy().getActionBinding().pressure;
	
	return context.executeAction('/Mahlwerk_Sales/Actions/NewOrder/NavToNewMachineOrder.action');
}

