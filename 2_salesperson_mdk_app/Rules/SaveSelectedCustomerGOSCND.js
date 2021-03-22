
var clientAPI;

export default function SaveSelectedCustomerGOSCND(context) {
	
	context.getPageProxy().getClientData()["SavedSelectedCustomer"] = context.getPageProxy().getActionBinding().CustomerID + "";
	
	
	
	return context.executeAction('/Mahlwerk_Sales/Actions/NewOrder/NavigateToWizardSecond.action');
}

