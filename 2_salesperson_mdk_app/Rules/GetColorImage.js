
var clientAPI;
var imagePath;

export default function GetColorImage(clientAPI) {
	
	imagePath = '/Mahlwerk_Sales/Images/';
	imagePath = String(imagePath) + String(clientAPI.evaluateTargetPath('colorName'));
    imagePath = String(imagePath) + String('.png');
	return imagePath
}