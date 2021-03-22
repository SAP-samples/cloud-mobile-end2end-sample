
export default function GetProductReadLink(context) {

    
  var binding = context.getPageProxy().getActionBinding();
  if (binding){
    console.log(`Downloading Product: (${binding.ProductIndex}) - ${binding.MachineColorsID}`);
    return binding.ProductReadLink;
  }
}