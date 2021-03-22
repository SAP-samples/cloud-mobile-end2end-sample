let fs = require('tns-core-modules/file-system');
// keyProperty is the name of the property to be used as the filename
// imageGroup is a name that will be used as a folder to keep all related images together
export function imageToPath(bindingObject, keyProperty, imageGroup) {
	let key = bindingObject[keyProperty];
	let filename = `${key}.png`;
	var tempDir = fs.knownFolders.documents();
	var returnPath = ''; 
	if (imageGroup !== undefined) {
		if (!fs.Folder.exists(fs.path.join(tempDir.path, imageGroup))) {
			fs.Folder.fromPath(fs.path.join(tempDir.path, imageGroup));
		}
		returnPath = fs.path.join(tempDir.path, imageGroup, filename);
	} else {
		returnPath = fs.path.join(tempDir.path, filename);
	}
	return returnPath;
}