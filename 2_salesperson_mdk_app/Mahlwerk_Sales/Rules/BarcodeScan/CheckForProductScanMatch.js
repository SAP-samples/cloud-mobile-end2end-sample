export default function CheckForProductScanMatch(context) {
	let pageProxy = context.getPageProxy();
	pageProxy.dismissActivityIndicator()
	var actionResult = pageProxy.getActionResult('BarcodeScan');
	console.log("ActionResult " + actionResult);
	if (actionResult) {
		console.log("processing");
		let scanValue = actionResult.data;

		// Check if the scan value matches a Product ID
		return pageProxy.read('/Mahlwerk_Sales/Services/Mahlwerk_Sales_MDK.service', 'MachineSet', [], `$filter=Name eq '${scanValue}'`).then(function (result) {
			if (result && result.length > 0) {
				pageProxy.setActionBinding(result.getItem(0));
				return pageProxy.executeAction('/Mahlwerk_Sales/Actions/Machines/NavToMachineSet_Detail.action');

			} else {
				// No matching product found.  Display a message to the user
				 var message = pageProxy.localizeText('scan_no_match', [scanValue]);
				var title = pageProxy.localizeText('scan_product');
				var okCaption = pageProxy.localizeText('ok');
				pageProxy.setActionBinding({
					'Message': message,
					'Title': title,
					'OKCaption': okCaption
                });
                alert("No Machine Found");
				
			}
		});
	}
}