
var clientAPI;

export default function SaveMachineInformation(context) {
	
	context.getPageProxy().getClientData()["SavedMachineName"] = context.binding.Name;
	context.getPageProxy().getClientData()["SavedMachineID"] = context.binding.MachineID;
	
}

