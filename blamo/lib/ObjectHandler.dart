import 'package:blamo/File_IO/FileHandler.dart';
import 'package:flutter/cupertino.dart';
import 'package:gson/gson.dart';


//TOREMOVE
/*import 'package:flutter/cupertino.dart';
import 'package:blamo/BoreholeList.dart';
import 'package:blamo/PDF/pdf_classes.dart';
import 'dart:convert';*/

//ParseJSON/BUILD OBJECT DONE: OBject -> JSON, JSON->Object
//Unit,TEST,LogInfo
//Save passed in object from UI to local storage: Obj -> JSON -> File
//Unit,Test,LogInfo
//Retrieve string from fileName/Docname 
//UNIT,TEST,LogInfo
//Return Object for get
//UNIT,TEST,LogInfo

//This will be the backend object that accepts requests from UI/features-does fileI/O and
//returns object requested
class ObjectHandler {
  PersistentStorage storage;

  ObjectHandler(String projectName){
    storage = new PersistentStorage();
    storage.changeProjectName(projectName);
  }

  //Can we make a generic function to parse JSON from storage and map it to correct object properties?
  // Or just do a dif parser for each?
  //TODO GENERIC JSON PARSER?
  Unit parseUnitJSON(String unitJSON) {
    Unit newUnitToBuild;
    if(unitJSON == "oops!"){
      newUnitToBuild = Unit();
    } else {
      newUnitToBuild = new Unit.fromJSON(gson.decode(unitJSON));
    }
    /*debugPrint("-----unitJSON Decoded-----\n"
        + "Begin Depth: ${newUnitToBuild.depthUB}\n"
        + "End Depth: ${newUnitToBuild.depthLB}\n"
        + "Method: ${newUnitToBuild.unitMethods}"
        + "Drilling: ${newUnitToBuild.drillingMethods}"
        + "Fill Tag: ${newUnitToBuild.tags}");*/
    return newUnitToBuild;
  }

  Test parseTestJSON(String testJSON) {
    Test newTestToBuild;
    if(testJSON == "oops!"){
      newTestToBuild = Test();
    } else {
      newTestToBuild = new Test.fromJSON(gson.decode(testJSON));
    }
    /*debugPrint("-----testJSON Decoded-----\n"
      + "beginTest: ${newTestToBuild.beginTest}\n"
      + "endTest: ${newTestToBuild.endTest}\n"
      + "soilType: ${newTestToBuild.soilType}\n"
      + "moistureContent: ${newTestToBuild.moistureContent}\n"
      + "dryDensity: ${newTestToBuild.dryDensity}\n"
      + "liquidLimit: ${newTestToBuild.liquidLimit}\n"
      + "plasticLimit: ${newTestToBuild.plasticLimit}\n"
      + "fines: ${newTestToBuild.fines}\n"
      + "blows1: ${newTestToBuild.blows1}\n"
      + "blows2: ${newTestToBuild.blows2}\n"
      + "blows3: ${newTestToBuild.blows3}\n"
      + "blowCount: ${newTestToBuild.blowCount}\n"
      + "tags: ${newTestToBuild.tags}\n"
    );*/
    return newTestToBuild;
  }

  LogInfo parseLogInfoJSON(String logInfoJSON) {
    LogInfo newLogInfoToBuild;
    if(logInfoJSON == "oops!"){
      newLogInfoToBuild = LogInfo();
    } else {
      newLogInfoToBuild = new LogInfo.fromJSON(gson.decode(logInfoJSON));
    }
    /*debugPrint("------logInfoJSON Decoded-----\n"
      + "projectName: ${newLogInfoToBuild.projectName}\n"
      + "startDate: ${newLogInfoToBuild.startDate}\n"
      + "endDate: ${newLogInfoToBuild.endDate}\n"
      + "driller: ${newLogInfoToBuild.driller}\n"
      + "projectGeologist: ${newLogInfoToBuild.projectGeologist}\n"
      + "recorder: ${newLogInfoToBuild.recorder}\n"
      + "northing: ${newLogInfoToBuild.northing}\n"
      + "easting: ${newLogInfoToBuild.easting}\n"
      + "highway: ${newLogInfoToBuild.highway}\n"
      + "county: ${newLogInfoToBuild.county}\n"
      + "purpose: ${newLogInfoToBuild.purpose}\n"
      + "equipment: ${newLogInfoToBuild.equipment}\n"
      + "objectID: ${newLogInfoToBuild.objectID}\n"
      + "testType: ${newLogInfoToBuild.testType}\n"
      + "project: ${newLogInfoToBuild.project}\n"
      + "number: ${newLogInfoToBuild.number}\n"
      + "client: ${newLogInfoToBuild.client}\n"
      + "lat: ${newLogInfoToBuild.lat}\n"
      + "long: ${newLogInfoToBuild.long}\n"
      + "location: ${newLogInfoToBuild.location}\n"
      + "elevationDatum: ${newLogInfoToBuild.elevationDatum}\n"
      + "boreholeID: ${newLogInfoToBuild.boreholeID}\n"
      + "surfaceElevation: ${newLogInfoToBuild.surfaceElevation}\n"
      + "contractor: ${newLogInfoToBuild.contractor}\n"
      + "method: ${newLogInfoToBuild.method}\n"
      + "loggedBy: ${newLogInfoToBuild.loggedBy}\n"
      + "checkedBy: ${newLogInfoToBuild.checkedBy}\n"
      + "holeNo: ${newLogInfoToBuild.holeNo}\n"
      + "eANo: ${newLogInfoToBuild.eANo}\n"
      + "keyNo: ${newLogInfoToBuild.keyNo}\n"
      + "startCardNo: ${newLogInfoToBuild.startCardNo}\n"
      + "groundElevation: ${newLogInfoToBuild.groundElevation}\n"
      + "tubeHeight: ${newLogInfoToBuild.tubeHeight}\n"
    );*/
    return newLogInfoToBuild;
  }


/*Saves data for the various pages/objects users will fill out
* saveUnitData -> Saves the state of a unit page to Local storage. Takes in unitFileName, the document name to save under, and a unit object to save
* saveTestData -> aves the state of a Test page to Local storage Takes in testFileName, the document name to save under, and a test object to save
* saveLogInfoData -> aves the state of a logInfo page to Local storage. Takes in the Document to save under and the LogInfo object to save.
*/
  Future<void> saveUnitData(String unitName, String documentName, Unit unitObj) async{
    String unitJSON = gson.encode({
      "depthUB": new Double(unitObj.depthUB),
      "depthLB": new Double(unitObj.depthLB),
      "drillingMethods": unitObj.drillingMethods,
      "notes": unitObj.notes,
      "tags": unitObj.tags
    });

    //---Debug
    //debugPrint("------UnitJSON Encoded------\n" + unitJSON + "\n");
    parseUnitJSON(unitJSON);

    await storage.overWriteUnit(documentName, unitName, unitJSON);
  }
  Future<void> saveTestData(String testName, String document, Test testObj) async{
    //TODO SAVE TEST PAGE INTO STORAGE
    String testJSON = gson.encode({
      "testType": testObj.testType,
      "beginTest": new Double(testObj.beginTest),
      "endTest": new Double(testObj.endTest),
      "percentRecovery": testObj.percentRecovery,
      "soilDrivingResistance": testObj.soilDrivingResistance,
      "rockDiscontinuityData": testObj.rockDiscontinuityData,
      "rockQualityDesignation": testObj.rockQualityDesignation,
      "moistureContent": testObj.moistureContent,
      "dryDensity": testObj.dryDensity,
      "liquidLimit": testObj.liquidLimit,
      "plasticLimit": testObj.plasticLimit,
      "fines": testObj.fines,
      "blows1": testObj.blows1,
      "blows2": testObj.blows2,
      "blows3": testObj.blows3,
      "blowCount": testObj.blowCount,
      "tags" : testObj.tags
    });
    //debugPrint("------TestJSON Encoded------\n" + testJSON + "\n");
    parseTestJSON(testJSON);

    await storage.overWriteTest(document, testName, testJSON);
  }

  Future<void> saveLogInfoData(String document, LogInfo logInfoObj) async{
    String logInfoJSON = gson.encode({
      "project": logInfoObj.project,
      "number": logInfoObj.number,
      "client": logInfoObj.client,
      "highway": logInfoObj.highway,
      "county": logInfoObj.county,
      "projection": logInfoObj.projection,
      "north": logInfoObj.north,
      "east": logInfoObj.east,
      "lat": logInfoObj.lat,
      "long": logInfoObj.long,
      "location": logInfoObj.location,
      "elevationDatum": logInfoObj.elevationDatum,
      "tubeHeight": logInfoObj.tubeHeight,
      "boreholeID": logInfoObj.boreholeID,
      "startDate": logInfoObj.startDate,
      "endDate": logInfoObj.endDate,
      "surfaceElevation": logInfoObj.surfaceElevation,
      "contractor": logInfoObj.contractor,
      "equipment": logInfoObj.equipment,
      "method": logInfoObj.method,
      "loggedBy": logInfoObj.loggedBy,
      "checkedBy": logInfoObj.checkedBy
    });
    //debugPrint("------LogInfoJSON Encoded------\n" + logInfoJSON + "\n");
    parseLogInfoJSON(logInfoJSON);

    await storage.overWriteLogInfo(document, logInfoJSON);
  }

  /*Retrieves the content from storage
  * retrieveLocalUnit()    -> gets the raw string value stored in a file for a unit (requires: unitName, documentName)
  * retrieveLocalTest()    -> gets the raw string value stored in a file for a test (requires: testName, documentName)
  * retrieveLocalLogInfo() -> gets the raw string value stored in a file for log info (requires: documentName)
  */
  Future<String> retrieveLocalUnit(String unitName, String documentName) async{
    //Take docname and unit name and get local storage
    String localUnitData;
    localUnitData = await storage.readUnit(documentName, unitName);
    //return string
    return localUnitData;
  }
  Future<String> retrieveLocalTest(String testName, String documentName) async{
    //Take docname and testName and get local storage String
    String localTestData;
    localTestData = await storage.readTest(documentName, testName);
    //return string
    return localTestData;
  }
  Future<String> retrieveLocalLogInfo(String documentName) async {
    String localLogInfo;
    localLogInfo = await storage.readLogInfo(documentName);
    //return string
    return localLogInfo;
  }

  /*Functions the UI calls to get data objects
  * getUnitData()        -> depends on retrieveLocalUnit() to get the raw string from the unit file, then parses it and returns a Unit object (requires: unitName, documentName)
  * getTestData()        -> depends on retrieveLocalTest() to get the raw string from the test file, then parses it and returns a Test object (requires: testName, documentName)
  * getLogInfoData()     -> depends on retrieveLocalLogInfo() to get the raw string from the logInfo file, then parses it and returns a LogInfo object (requires: documentName)
  * getUnitsData()       -> depends on getUnitData() to loop through a given list of unit names, building a list<unit> to return (requires: List<string> unitNames, documentName)
  * getTestsData()       -> depends on getTestData() to loop through a given list of test names, building a list<test> to return (requires: List<string> testNames, documentName)
  * getLogInfoDataJson() -> depends on retrieveLocalLogInfo() to get the raw string from the logInfo file, then returns the raw JSON string (requires: documentName)
  * getUnitsDataJSON()   -> depends on retrieveLocalUnit() to get a list of raw strings (JSON) to build the units from (requires: List<string> unitNames, documentName)
  * getTestsDataJSON()   -> depends on retrieveLocalTest() to get a list of raw strings (JSON) to build the tests from (requires: List<string> testNames, documentName)
  */

  Future<Unit> getUnitData(String unitName, String documentName) async {
    Unit returnUnitData = new Unit();
    String unitLocal = await retrieveLocalUnit(unitName,documentName);
    //take JSON and put into Unit object
    returnUnitData = parseUnitJSON(unitLocal);
    //return Unit object
    return returnUnitData;
  }
  Future<Test> getTestData(String testName, String documentName) async {
    Test returnTestData = new Test();
    String testLocal = await retrieveLocalTest(testName,documentName);
    //take JSON and put into Test object
    returnTestData = parseTestJSON(testLocal);
    //return Test Object
    return returnTestData;
  }
  Future<LogInfo> getLogInfoData(String documentName) async {
    LogInfo returnLogInfo = new LogInfo();
    //TODO return LogInfo Object
    String logInfoLocal = await retrieveLocalLogInfo(documentName);
    returnLogInfo = parseLogInfoJSON(logInfoLocal);
    return returnLogInfo;
  }
  // returns list of all units in doc, given list of unit names
  Future<List<Unit>> getUnitsData(List<String> unitNames, String documentName) async {
    List<Unit> returnUnitsData = [];
    for(int i = 0; i < unitNames.length; i++){
      Unit tempUnit = await getUnitData(unitNames[i], documentName);
      returnUnitsData.add(tempUnit);
    }
    return returnUnitsData;
  }

  // returns list of all tests in doc, given list of test names
  Future<List<Test>> getTestsData(List<String> testNames, String documentName) async {
    List<Test> returnTestsData = [];
    for(int i = 0; i < testNames.length; i++){
      Test tempTest = await getTestData(testNames[i], documentName);
      returnTestsData.add(tempTest);
    }
    return returnTestsData;
  }

  //Functions to get raw JSON data from file
  Future<String> getLogInfoDataJson(String documentName) async {
    String logInfoLocal = await retrieveLocalLogInfo(documentName);
    return logInfoLocal;
  }

  Future<List<String>> getUnitsDataJSON(List<String> unitNames,String documentName) async {
    List<String> returnUnitsData = [];
    for(int i = 0; i < unitNames.length; i++){
      String testLocal = await retrieveLocalTest(unitNames[i],documentName);
      returnUnitsData.add(testLocal);
    }
    return returnUnitsData;
  }

  Future<List<String>> getTestsDataJSON(List<String> testNames,String documentName) async{
    List<String> returnTestsData = [];
    for(int i = 0; i < testNames.length; i++){
      String testLocal = await retrieveLocalTest(testNames[i],documentName);
      returnTestsData.add(testLocal);
    }
    return returnTestsData;
  }

  /*---End Get Data---*/

  Future<String> getPathToFile(String documentName, String extension) async {
    String filePath;
    bool fileExists = await storage.checkForFile(documentName, extension);
    if(fileExists){
      filePath = await storage.getPathToFile(documentName, extension);
    }
    debugPrint("(OH)fileExists: $fileExists");
    debugPrint("(OH)filePath: $filePath");
    if(fileExists != false){
      return filePath;
    } else {
      debugPrint("OBJECT HANDLER - There is no compiled $extension version for $documentName");
      return null;
    }
  }
}

  /* Schemas for the JSON parsing
  *  LogInfo -> represents all of the fields within a log info page
  *  Unit    -> represents all of the fields within a unit page
  *  Test    -> represents all of the fields within a test page
  */

class Document {
  LogInfo logInfo;
  Tests tests;
  Units units;
}
class LogInfo {
  String project;
  String number;
  String client;
  String highway;
  String county;
  String projection;
  String north;
  String east;
  String lat;
  String long;
  String location;
  String elevationDatum;
  String tubeHeight;
  String boreholeID;
  String startDate;
  String endDate;
  String surfaceElevation;
  String contractor;
  String equipment;
  String method;
  String loggedBy;
  String checkedBy;

  LogInfo({
    this.project,
    this.number,
    this.client,
    this.highway,
    this.county,
    this.projection,
    this.north,
    this.east,
    this.lat,
    this.long,
    this.location,
    this.elevationDatum,
    this.tubeHeight,
    this.boreholeID,
    this.startDate,
    this.endDate,
    this.surfaceElevation,
    this.contractor,
    this.equipment,
    this.method,
    this.loggedBy,
    this.checkedBy

  });
  //Returns LogInfo object with mapped values from an already parsed JSON object
  factory LogInfo.fromJSON (Map<String, dynamic> parsedJSON) {

    return LogInfo(
        project: parsedJSON["project"],
        number: parsedJSON["number"],
        client: parsedJSON["client"],
        highway: parsedJSON["highway"],
        county: parsedJSON["county"],
        projection: parsedJSON["projection"],
        north: parsedJSON["north"],
        east: parsedJSON["east"],
        lat: parsedJSON["lat"],
        long: parsedJSON["long"],
        location: parsedJSON["location"],
        elevationDatum: parsedJSON["elevationDatum"],
        tubeHeight: parsedJSON["tubeHeight"],
        boreholeID: parsedJSON["boreholeID"],
        startDate: parsedJSON["startDate"],
        endDate: parsedJSON["endDate"],
        surfaceElevation: parsedJSON["surfaceElevation"],
        contractor: parsedJSON["contractor"],
        equipment: parsedJSON["equipment"],
        method: parsedJSON["method"],
        loggedBy: parsedJSON["loggedBy"],
        checkedBy: parsedJSON["checkedBy"]
    );
  }
}

class Units {
  List<Unit> units;
}

class Unit {
  double depthUB;
  double depthLB;
  String drillingMethods;
  String notes;
  String tags;

  //Unit constructor
  Unit({
    this.depthUB,
    this.depthLB,
    this.drillingMethods,
    this.notes,
    this.tags
  });

  // This returns the object from the JSON
  factory Unit.fromJSON (Map<String, dynamic> parsedJSON) {
    double depthUBConverted;
    double depthLBConverted;
    //Negative values are Strings for some reason, so check type
    if(parsedJSON["depthUB"] != "null" && parsedJSON["depthUB"].runtimeType.toString() == "Double"){
      depthUBConverted = parsedJSON["depthUB"].value;
    } else if(parsedJSON["depthUB"] != "null" && parsedJSON["depthUB"].runtimeType.toString() == "String"){
      depthUBConverted = double.parse(parsedJSON["depthUB"].replaceAll(new RegExp('d'), ''));
    }

    if(parsedJSON["depthLB"] != "null" && parsedJSON["depthLB"].runtimeType.toString() == "Double"){
      depthLBConverted = parsedJSON["depthLB"].value;
    } else if(parsedJSON["depthLB"] != "null" && parsedJSON["depthLB"].runtimeType.toString() == "String"){
      depthLBConverted = double.parse(parsedJSON["depthLB"].replaceAll(new RegExp('d'), ''));
    }
    /*debugPrint("beginDepthFromJSON: $beginDepthFromJSON, of type ${parsedJSON["beginUnitDepth"].runtimeType}\n"
        + "endDepthFromJSON: $endDepthFromJSON of type ${endDepthFromJSON.runtimeType}\n"
    );*/
    //debugPrint("Tags: ${parsedJSON["tags"]}\nIs of type${parsedJSON["tags"].runtimeType}");

    return Unit(
        depthUB: depthUBConverted,
        depthLB: depthLBConverted,
        drillingMethods: parsedJSON["drillingMethods"],
        notes: parsedJSON["notes"],
        tags: parsedJSON["tags"]
    );
  }
}
class Tests {
  List<Test> tests;
}

class Test {
  String testType;
  double beginTest;
  double endTest;
  double percentRecovery;
  String soilDrivingResistance;
  String rockDiscontinuityData;
  String rockQualityDesignation;
  String moistureContent;
  String dryDensity;
  String liquidLimit;
  String plasticLimit;
  String fines;
  String blows1;
  String blows2;
  String blows3;
  String blowCount;
  String tags;

  //Default constructor
  Test({
    this.testType,
    this.beginTest,
    this.endTest,
    this.percentRecovery,
    this.soilDrivingResistance,
    this.rockDiscontinuityData,
    this.rockQualityDesignation,
    this.moistureContent,
    this.dryDensity,
    this.liquidLimit,
    this.plasticLimit,
    this.fines,
    this.blows1,
    this.blows2,
    this.blows3,
    this.blowCount,
    this.tags
  });
  //Returns Test object from already parsed json(MAPS data to obj)
  factory Test.fromJSON(Map<String, dynamic> parsedJSON){
    double beginTestConverted;
    double endTestConverted;
    double percentRecoveryConverted;
    //Negative values are Strings for some reason, so check type
    if(parsedJSON["beginTest"] != "null" && parsedJSON["beginTest"].runtimeType.toString() == "Double"){
      beginTestConverted = parsedJSON["beginTest"].value;
    } else if(parsedJSON["beginTest"] != "null" && parsedJSON["beginTest"].runtimeType.toString() == "String"){
      beginTestConverted = double.parse(parsedJSON["beginTest"].replaceAll(new RegExp('d'), ''));
    }
    if(parsedJSON["endTest"] != "null" && parsedJSON["endTest"].runtimeType.toString() == "Double"){
      endTestConverted = parsedJSON["endTest"].value;
    } else if(parsedJSON["endTest"] != "null" && parsedJSON["endTest"].runtimeType.toString() == "String"){
      endTestConverted = double.parse(parsedJSON["endTest"].replaceAll(new RegExp('d'), ''));
    }
    if(parsedJSON["percentRecovery"] != "null" && parsedJSON["percentRecovery"].runtimeType.toString() == "Double"){
      percentRecoveryConverted = parsedJSON["percentRecovery"].value;
    } else if(parsedJSON["percentRecovery"] != "null" && parsedJSON["percentRecovery"].runtimeType.toString() == "String"){
      percentRecoveryConverted = double.parse(parsedJSON["percentRecovery"].replaceAll(new RegExp('d'), ''));
    }
    return Test(
        testType: parsedJSON["testType"],
        beginTest: beginTestConverted,
        endTest: endTestConverted,
        percentRecovery: percentRecoveryConverted,
        soilDrivingResistance: parsedJSON["soilDrivingResistance"],
        rockDiscontinuityData: parsedJSON["rockDiscontinuityData"],
        rockQualityDesignation: parsedJSON["rockQualityDesignation"],
        moistureContent: parsedJSON["moistureContent"],
        dryDensity: parsedJSON["dryDensity"],
        liquidLimit: parsedJSON["liquidLimit"],
        plasticLimit: parsedJSON["plasticLimit"],
        fines: parsedJSON["fines"],
        blows1: parsedJSON["blows1"],
        blows2: parsedJSON["blows2"],
        blows3: parsedJSON["blows3"],
        blowCount: parsedJSON["blowCount"],
        tags: parsedJSON["tags"]
    );

  }
}