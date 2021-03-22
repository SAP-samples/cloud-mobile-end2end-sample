import { fileExists } from './FileUtils/FileExists';
import { imageToPath } from './FileUtils/ImageToPath';
import { pathToFile } from './FileUtils/PathToFile';
import { writeSync } from './FileUtils/WriteSync';
import GetAllColoredProductImages from './GetAllColoredProductImages';

function ExecuteDownloadImage(prodBinding, fileName){
  console.log(`Preparing to downloading Product: (${prodBinding.ProductIndex}) - ${prodBinding.MachineID}`);
  
  //In this context 'this' is the PageProxy class that we set using the bind(pageProxy, ...) below...
  this.setActionBinding(prodBinding);
  //Must return the promised returned by executeAction to keep the chain alive.
  return this.executeAction('/Mahlwerk_Sales/Actions/Products/DownloadProductImage.action').then(result => {
    if (result && result.data) {
      console.log("Downloaded: " + fileName);
      const file = pathToFile(fileName);
      writeSync(this, file, result.data);
    }
    else {
      //This shouldn't really happen unless something is wrong with the data.
      console.log("NO DATA!!!!!!!");
    }
  });
}

export default function GetAllProductImages(context) {
  let pageProxy = context.getPageProxy();
  //Call read function to retrieve All Products (Products is the EntitySet with HasStream=true),
  // which mean each Product entity is also a media
	return context.read('/Mahlwerk_Sales/Services/Mahlwerk_Sales_MDK.service', 'MachineSet', []).then(result => {
		if (result) { // result should contains all of the Products entries
      var length = result.length;
      var latestPromise = Promise.resolve(); //Create the initial promise in the chain, this initial promise is resolved immediately.

      //Loop through the result and if any of the product image doesn't exist as a file in the device yet, then we download them.
      // Due to limitation in PageProxy.setActionBinding (there's only 1 copy of it), we must chain all download together, 
      // so that they are executed synchronously one by one using promise chain. 
      // We can't execute them in parallel because you can only have 1 copy of actionbinding, they'll end up download the same image over and over again.
      for (var i = 0; i < length; i++) {
        let prod = result.getItem(i);
        //Generate a filename using ProductId value and put them in the folder called ProductImages
        // This will be the image's filename
        const fileName = imageToPath(prod, 'MachineID', 'ProductImages');

        //Check if the file exist, only if the image file does not exists, then we start downloading it
        if (!fileExists(fileName)) {
          let prodBinding = {
            //ProductId and ProductIndex are not really needed, I only use them to debug and track order of files being downloaded
            'ProductIndex': i,
            'MachineID': prod.MachineID,
            'ProductReadLink': prod['@odata.readLink'] // This is the one needed by DownloadMedia action to download each image
          };
          //Wait for the latestPromise to be resolved before triggering the next image download
          // Use bind to set the 'this' context for the function and pass prodBinding and fileName into the function when it's executed
          // the newly returned promise is then set as to latestPromise variable for chaining purposes.
          latestPromise = latestPromise.then(ExecuteDownloadImage.bind(pageProxy, prodBinding, fileName));
        }
      }
      // Add a final chain to show a toast that all product images are downloaded.
      return latestPromise.then(function(){
        return GetAllColoredProductImages(this)
      }.bind(pageProxy));
		}
	});
}