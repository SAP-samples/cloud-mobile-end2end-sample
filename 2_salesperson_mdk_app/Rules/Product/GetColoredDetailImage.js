
import { fileExists } from './FileUtils/FileExists';
import { imageToPath } from './FileUtils/ImageToPath';
import { pathToFile } from './FileUtils/PathToFile';

export default function GetDetailImage(context) {
	let prod = context.binding;
  console.log(prod.ProductId);
  
  //Get the filename based on the ProductId's value
  const fileName = imageToPath(prod, 'MachineColorsID', 'ProductImages');
  if (fileExists(fileName)) {
    //If the file exist, just return the file name
    return fileName;
  }
	
}