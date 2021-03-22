var fs = require('fs');

var directoryPathImages = "images/"
var directoryPathInitialData = "../src/main/resources/initial-data/"


var colors = ["red", "blue", "orange"];
var types = [{name: "1000L", id: 4}, {name: "2000", id: 1}, {name: "4000", id: 2}, {name: "5000S", id: 3}, {name: "9000X", id: 5}];

var output =[];
var ID = 1;
for (type of types) {
    for (color of colors){
        var baseFileContent = fs.readFileSync(directoryPathImages + `Mahlwerk${type.name}.${color}.png.base64`).toString("utf-8")
        baseFileContent = baseFileContent.trim();
        var entry = {
            "MachineColorsID": ID,
            "colorName": color,
            "MachineID": type.id,
            "$value": "data:image/png;base64," + baseFileContent
        }
        output.push(entry);
    }
    ID++;
}
fs.writeFileSync(directoryPathInitialData + "MachineColorsSet.json", JSON.stringify(output));