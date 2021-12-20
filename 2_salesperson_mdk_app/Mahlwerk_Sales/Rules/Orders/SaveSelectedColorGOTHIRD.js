
var clientAPI;

export default function SaveSelectedCustomerGOTHIRD(context) {
	
	context.getPageProxy().getClientData()["SavedSelectedColor"] = context.getPageProxy().getActionBinding().MachineColorsID + "";
	
	let pressure = {'Pressure':[{'pressure':"12,5"},{'pressure':"15,666"},{'pressure':"17,5"},{'pressure':"20,0"}]};
	context.getPageProxy().setActionBinding(pressure);
	
	return context.executeAction('/Mahlwerk_Sales/Actions/Orders/NavToOrders_ThirdWizard.action');
	
}

