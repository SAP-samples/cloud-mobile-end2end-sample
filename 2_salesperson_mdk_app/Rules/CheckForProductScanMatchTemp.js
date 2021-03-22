export default function CheckForProductScanMatchTemp(context) {
	let pageProxy = context.getPageProxy();

	return pageProxy.read('/Mahlwerk_Sales/Services/Mahlwerk_Sales_MDK.service', 'MachineSet', [], `$filter=Name eq 'Mahlwerk 9000 X'`).then(function (result) {
		if (result && result.length > 0) {
			pageProxy.setActionBinding(result.getItem(0));
			return pageProxy.executeAction('/Mahlwerk_Sales/Actions/MachineSet/NavToMachineSet_Detail.action');

		} else {
			
			return pageProxy.executeAction('/Mahlwerk_Sales/Actions/CloseModalPage_Cancel.action');
		}
	});
	
}