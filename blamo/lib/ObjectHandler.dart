import 'package:blamo/main.dart';
import 'package:blamo/File_IO/FileHandler.dart';
import 'package:blamo/PDF/pdf_classes.dart';
import 'package:gson/gson.dart';
import 'dart:convert';
//TOREMOVE
import 'package:flutter/cupertino.dart';

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
  PersistentStorage storage = new PersistentStorage();
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
      newTestToBuild = new Test.fromJSON(gson.decode(testJSON));
    } else {
      newTestToBuild = Test();
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
      newLogInfoToBuild = new LogInfo.fromJSON(gson.decode(logInfoJSON));
    } else {
      newLogInfoToBuild = LogInfo();
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


/*Saves data for the varios pages/objects users will fill out
* saveUnitData -> Saves the state of a unit page to Local storage. Takes in unitFileName, the document name to save under, and a unit object to save
* saveTestData -> aves the state of a Test page to Local storage Takes in testFileName, the document name to save under, and a test object to save
* saveLogInfoDataa -> aves the state of a logInfo page to Local storage. Takes in the Document to save under and the LogInfo object to save.
*/
  Future<void> saveUnitData(String unitName, String documentName, Unit unitObj) async{
     String unitJSON = gson.encode({
      "depthUB": unitObj.depthUB,
      "depthLB": unitObj.depthLB,
      "beginUnitDepth": unitObj.beginUnitDepth,
      "unitMethods": unitObj.unitMethods,
      "drillingMethods": unitObj.drillingMethods,
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
      "beginTest": testObj.beginTest,
      "endTest": testObj.endTest,
      "soilType": testObj.soilType,
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
      "projectName": logInfoObj.projectName,
      "startDate": logInfoObj.startDate,
      "endDate": logInfoObj.endDate,
      "driller": logInfoObj.driller,
      "projectGeologist": logInfoObj.projectGeologist,
      "recorder": logInfoObj.recorder,
      "northing": logInfoObj.northing,
      "easting": logInfoObj.easting,
      "highway": logInfoObj.highway,
      "county": logInfoObj.county,
      "purpose": logInfoObj.purpose,
      "equipment": logInfoObj.equipment,
      "objectID": logInfoObj.objectID,
      "testType": logInfoObj.testType,
      "project": logInfoObj.project,
      "number": logInfoObj.number,
      "client": logInfoObj.client,
      "lat": logInfoObj.lat,
      "long": logInfoObj.long,
      "location": logInfoObj.location,
      "elevationDatum": logInfoObj.elevationDatum,
      "boreholeID": logInfoObj.boreholeID,
      "surfaceElevation": logInfoObj.surfaceElevation,
      "contractor": logInfoObj.contractor,
      "method": logInfoObj.method,
      "loggedBy": logInfoObj.loggedBy,
      "checkedBy": logInfoObj.checkedBy,
      "holeNo": logInfoObj.holeNo,
      "eANo": logInfoObj.eANo,
      "keyNo": logInfoObj.keyNo,
      "startCardNo": logInfoObj.startCardNo,
      "groundElevation": logInfoObj.groundElevation,
      "tubeHeight": logInfoObj.tubeHeight
    });
    //debugPrint("------LogInfoJSON Encoded------\n" + logInfoJSON + "\n");
    parseLogInfoJSON(logInfoJSON);

    await storage.overWriteLogInfo(document, logInfoJSON);
  }

  /*Retrieves the content from storage
  *
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
   * Unit,Test,LogInfo
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
    //take JSON and put into Unit object
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
  
}
class Document {
  LogInfo logInfo;
  Tests tests;
  Units units;
}
class LogInfo {
  String projectName;
  String startDate;
  String endDate;
  String driller;
  String projectGeologist;
  String recorder;
  String northing;
  String easting;
  String highway;
  String county;
  String purpose;
  String equipment;
  String objectID;
  String testType;
  String project;
  String number;
  String client;
  String lat;
  String long;
  String location;
  String elevationDatum;
  String boreholeID;
  String surfaceElevation;
  String contractor;
  String method;
  String loggedBy;
  String checkedBy;
  double holeNo;
  double eANo;
  double keyNo;
  double startCardNo;
  double groundElevation;
  double tubeHeight;

  LogInfo({
    this.projectName,
    this.startDate,
    this.endDate,
    this.driller,
    this.projectGeologist,
    this.recorder,
    this.northing,
    this.easting,
    this.highway,
    this.county,
    this.purpose,
    this.equipment,
    this.objectID,
    this.testType,
    this.project,
    this.number,
    this.client,
    this.lat,
    this.long,
    this.location,
    this.elevationDatum,
    this.boreholeID,
    this.surfaceElevation,
    this.contractor,
    this.method,
    this.loggedBy,
    this.checkedBy,
    this.holeNo,
    this.eANo,
    this.keyNo,
    this.startCardNo,
    this.groundElevation,
    this.tubeHeight,
  });
  //Returns LogInfo object with mapped values from an already parsed JSON object
  factory LogInfo.fromJSON (Map<String, dynamic> parsedJSON) {
    double holeNoConverted = null;
    double eANoConverted = null;
    double keyNoConverted = null;
    double startCardNoConverted = null;
    double groundElevationConverted = null;
    double tubeHeightConverted = null; 

    if(parsedJSON["holeNo"] != "null"){
      holeNoConverted = parsedJSON["holeNo"].value;
    }if(parsedJSON["eANo"] != "null"){
      eANoConverted = parsedJSON["eANo"].value;
    }if(parsedJSON["keyNo"] != "null"){
      keyNoConverted = parsedJSON["keyNo"].value;
    }if(parsedJSON["startCardNo"] != "null"){
      startCardNoConverted = parsedJSON["startCardNo"].value;
    }if(parsedJSON["groundElevation"] != "null"){
      groundElevationConverted = parsedJSON["groundElevation"].value;
    }if(parsedJSON["tubeHeight"] != "null"){
      tubeHeightConverted = parsedJSON["tubeHeight"].value;
    }

    return LogInfo(
      holeNo: holeNoConverted,
      eANo: eANoConverted,
      keyNo: keyNoConverted,
      startCardNo: startCardNoConverted,
      groundElevation: groundElevationConverted,
      tubeHeight: tubeHeightConverted,
      projectName: parsedJSON["projectName"],
      startDate: parsedJSON["startDate"],
      endDate: parsedJSON["endDate"],
      driller: parsedJSON["driller"],
      projectGeologist: parsedJSON["projectGeologist"],
      recorder: parsedJSON["recorder"],
      northing: parsedJSON["northing"],
      easting: parsedJSON["easting"],
      highway: parsedJSON["highway"],
      county: parsedJSON["county"],
      purpose: parsedJSON["purpose"],
      equipment: parsedJSON["equipment"],
      objectID: parsedJSON["objectID"],
      testType: parsedJSON["testType"],
      project: parsedJSON["project"],
      number: parsedJSON["number"],
      client: parsedJSON["client"],
      lat: parsedJSON["lat"],
      long: parsedJSON["long"],
      location: parsedJSON["location"],
      elevationDatum: parsedJSON["elevationDatum"],
      boreholeID: parsedJSON["boreholeID"],
      surfaceElevation: parsedJSON["surfaceElevation"],
      contractor: parsedJSON["contractor"],
      method: parsedJSON["method"],
      loggedBy: parsedJSON["loggedBy"],
      checkedBy: parsedJSON["checkedBy"],
    );
  }
}

class Units {
  List<Unit> units;
}

class Unit {
  double depthUB;
  double depthLB;
  double beginUnitDepth;
  String unitMethods;
  String drillingMethods;
  String tags;

  //Unit constructor
  Unit({
    this.depthUB,
    this.depthLB,
    this.beginUnitDepth,
    this.unitMethods,
    this.drillingMethods,
    this.tags
  });

  // This returns the object from the JSON
  factory Unit.fromJSON (Map<String, dynamic> parsedJSON) {
    double depthUBConverted = null;
    double depthLBConverted = null;
    double beginUnitDepthConverted = null;
    if(parsedJSON["depthUB"] != "null"){
      depthUBConverted = parsedJSON["depthUB"].value;
    }
    if(parsedJSON["depthLB"] != "null"){
      depthLBConverted = parsedJSON["depthLB"].value;
    }
    if(parsedJSON["beginUnitDepth"] != "null"){
      beginUnitDepthConverted = parsedJSON["beginUnitDepth"].value;
    }
    /*debugPrint("beginDepthFromJSON: $beginDepthFromJSON, of type ${parsedJSON["beginUnitDepth"].runtimeType}\n"
        + "endDepthFromJSON: $endDepthFromJSON of type ${endDepthFromJSON.runtimeType}\n"
    );*/
    //debugPrint("Tags: ${parsedJSON["tags"]}\nIs of type${parsedJSON["tags"].runtimeType}");
    
    return Unit(
      depthUB: depthUBConverted,
      depthLB: depthLBConverted,
      beginUnitDepth: beginUnitDepthConverted,
      unitMethods: parsedJSON["unitMethods"],
      drillingMethods: parsedJSON["drillingMethods"],
      tags: parsedJSON["tags"]
    );
  }
}
class Tests {
  List<Test> tests;
}

class Test {
  double beginTest;
  double endTest;
  String soilType;
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
    this.beginTest,
    this.endTest,
    this.soilType,
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
    double beginTestConverted = null;
    double endTestConverted = null;

    if(parsedJSON["beginTest"] != "null"){
      beginTestConverted = parsedJSON["beginTest"].value;
    } 
    if(parsedJSON["endTest"]  != "null") {
      endTestConverted = parsedJSON["endTest"].value;
    } 
    return Test(
      beginTest: beginTestConverted,
      endTest: endTestConverted,
      soilType: parsedJSON["soilType"],
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