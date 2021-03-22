export default function DeleteConfirmation(clientAPI) {
	let dialogs = clientAPI.nativescript.uiDialogsModule;
	return dialogs.confirm("Diesen Kunden löschen?").then((result) => {
		if (result === true) {
			return clientAPI.executeAction('/Mahlwerk_Sales/Actions/CustomerSet/DeleteCustomerEntity.action').then(
				(success) => Promise.resolve(success),
				(failure) => Promise.reject('Delete entity failed ' + failure));
		} else {
			return Promise.reject('user deferred!');
		}
	});
}