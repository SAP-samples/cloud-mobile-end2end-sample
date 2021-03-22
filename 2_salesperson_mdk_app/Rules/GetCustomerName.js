/**
* Returns Customer Name
* @param {IClientAPI} context
*/
export default function GetCustomerName(context) {
    let customerName = context.getPageProxy().binding.CompanyName;
    return customerName;
}