
var clientAPI;

export default function GetCurrentMachineColorsID(context) {

	context.getPageProxy().getClientData()["CurrentMachineColorsID"] = context.binding.MachineColorsID;	
	
	return context.executeAction('/Mahlwerk_Sales/Actions/CustomerSet/NavToCustomerSet_MachineDetail.action');

}
