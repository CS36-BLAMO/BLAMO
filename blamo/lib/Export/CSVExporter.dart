import 'dart:html';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:blamo/ObjectHandler.dart';
import 'package:blamo/Boreholes/BoreholeList.dart';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class CSVExporter {
  ObjectHandler objectHandler;
  StateData stateData;
  StateData tempData;
  LogInfo logInfo;
  List<Unit> units;
  List<Test> tests;
  List<String> lines = [];

  List<String> PROJECT = [];
  List<String> POINT = [];
  List<String> REMARKS = [];
  List<String> WATER_LEVELS = [];
  List<String> WELL = [];
  List<String> LITHOLOGY = [];
  List<String> SAMPLE = [];

  CSVExporter(this.stateData){
    objectHandler = new ObjectHandler(stateData.currentProject);
    tempData = new StateData("/Export");
    tempData.currentProject = stateData.currentProject;
    tempData.list = stateData.list;
    tempData.unitList = stateData.unitList;
    tempData.testList = stateData.testList;
  }

  Future<String> exportToCSV() async{
    String toWrite;
    await getData();
    buildCSVLines();
    toWrite = formatLinesToString();
    debugPrint("toWrite: $toWrite");
    String response = await csvWrite(toWrite, stateData.currentDocument);
    return response;
  }


  Future<String> exportProjectToCSV() async {
    String toWrite;
    String header = "PointID"
        +",Name"
        +",Highway"
        +",Geologist"
        +",County"
        +",EA_Number"
        +",Input Units"
        +",Output Units"
        +",Depth Log Page"
        +","
        +",PointID"
        +",North"
        +",East"
        +",Equipment"
        +",Start_Date"
        +",End_Date"
        +",Purpose"
        +",Driller"
        +",Recorder"
        +",HoleDepth"
        +",Key_No"
        +",Start_Card_No"
        +",Bridge_No"
        +",Elevation"
        +",Depth Log Page"
        +",Tube_Height"
        +",Plunge"
        +","
        +",PointID"
        +",Depth"
        +",Description"
        +",Show_Pointer"
        +","
        +",PointID"
        +",DateTime"
        +",Depth"
        +",Note"
        +","
        +",PointID"
        +",Depth"
        +",Bottom"
        +",Graphic"
        +","
        +",PointID"
        +",Depth"
        +",Bottom"
        +",Graphic"
        +",Description"
        +",Formation"
        +","
        +",PointID"
        +",Depth"
        +",Bottom"
        +",Type"
        +",Number"
        +",Recovery"
        +",Driving_Resist"
        +",N Value"
        +",Discontinuities"
        +",Percent_Moist"
        +",RQD"
        +",Description"
        +",Soil_Name"
        +",USCS"
        +",Soil_Color"
        +",Plasticity"
        +",Moisture"
        +",Consistency"
        +",Soil_Texture"
        +",Soil_Structure"
        +",Soil_Other"
        +",Soil_Origin"
        +",Rock_Name"
        +",Rock_Color"
        +",Weathering"
        +",Hardness"
        +",Rock_Structure"
        +",Rock_Other"
        +",Formation";
    lines.add(header);
    for(int i = 0; i < tempData.list.length; i++){
      debugPrint('tempData.list[$i]: ${tempData.list[i]}');
      if(tempData.list[i] != ''){
        tempData.currentDocument = tempData.list[i];
        await tempData.storage.setStateData(tempData);
        await getProjectData();
        await new Future.delayed(new Duration(milliseconds: 100));
        buildProjectSegment();
        buildPointSegment();
        buildRemarksSegment();
        buildWaterLevelsSegment();
        buildWellSegment();
        buildLithologySegment();
        buildSampleSegment();
      }
    }
    toWrite = formatProjectLinesToString();
    debugPrint('Writing to csv: \n $toWrite');
  }

  Future<int> getData() async{
    logInfo = await objectHandler.getLogInfoData(stateData.currentDocument);
    try{
      units = await objectHandler.getUnitsData(stateData.unitList, stateData.currentDocument);
    } catch (e){
      debugPrint("(CSV)ERROR getting units");
    }

    try{
      tests = await objectHandler.getTestsData(stateData.testList, stateData.currentDocument);
    } catch (e){
      debugPrint("(CSV)ERROR getting tests");
    }
    debugPrint("SUCCESS");
    return 0;
  }

  Future<int> getProjectData() async{
    logInfo = await objectHandler.getLogInfoData(tempData.currentDocument);
    try{
      units = await objectHandler.getUnitsData(tempData.unitList, tempData.currentDocument);
    } catch (e){
      debugPrint("(CSV)ERROR getting units");
    }
    try{
      tests = await objectHandler.getTestsData(tempData.testList, tempData.currentDocument);
    } catch (e){
      debugPrint("(CSV)ERROR getting tests");
    }
    debugPrint("SUCCESS");
    return 0;
  }

  String scrubData(String toScrub){
    if(toScrub != null){
      return toScrub.replaceAll(",", " ").replaceAll('\n', '') + ",";
    } else {
      return ",";
    }
  }

  String scrubDataDouble(double toScrub){
    if(toScrub != null){
      return "%" + toScrub.toString() + ",";
    } else {
      return ",";
    }
  }

  void buildCSVLines(){
    String header = "OBJECTID,Test Type,PROJECT,Number,Client,LATITUDE,LONGITUDE,Projection,North,East,Location,Elevation Datum,Borehole ID,Date Started,Date Completed,Surface Elevation (ft),Contractor/Driller,Method,Logged By,Checked By,Begin Depth (ft),End Depth (ft),Soil Type,Description,Moisture Content,Dry Density (pcf),Liquid Limit (%),Plastic Limit (%),Fines (%),Blows 1st,Blows 2nd,Blows 3rd,N Value";
    lines.add(header);

    //TODO - Update CSV format

    for(int i = 0; i < tests.length; i++){
      lines.add("$i,"
          "${tests[i].testType.replaceAll(",", " ").replaceAll('\n', '')},"
          "${logInfo.project.replaceAll(",", " ").replaceAll('\n', '')},"
          "${logInfo.number.replaceAll(",", " ").replaceAll('\n', '')},"
          "${logInfo.client.replaceAll(",", " ").replaceAll('\n', '')},"
          "${logInfo.lat.replaceAll(",", " ").replaceAll('\n', '')},"
          "${logInfo.long.replaceAll(",", " ").replaceAll('\n', '')},"
          "${logInfo.projection.replaceAll(",", " ").replaceAll('\n', '')},"
          "${logInfo.north.replaceAll(",", " ").replaceAll('\n', '')},"
          "${logInfo.east.replaceAll(",", " ").replaceAll('\n', '')},"
          "${logInfo.location.replaceAll(",", " ").replaceAll('\n', '')},"
          "${logInfo.elevationDatum.replaceAll(",", " ").replaceAll('\n', '')},"
          "${logInfo.boreholeID.replaceAll(",", " ").replaceAll('\n', '')},"
          "${logInfo.startDate},"
          "${logInfo.endDate},"
          "${logInfo.surfaceElevation.replaceAll(",", " ").replaceAll('\n', '')},"
          "${logInfo.contractor.replaceAll(",", " ").replaceAll('\n', '')},"
          "${logInfo.method.replaceAll(",", " ").replaceAll('\n', '')},"
          "${logInfo.loggedBy.replaceAll(",", " ").replaceAll('\n', '')},"
          "${logInfo.checkedBy.replaceAll(",", " ").replaceAll('\n', '')},"
          "${tests[i].beginTest},"
          "${tests[i].endTest},"
          ","
          "${formatTags(tests[i].tags)},"
          "${tests[i].moistureContent.replaceAll(",", " ").replaceAll('\n', '')},"
          "${tests[i].dryDensity.replaceAll(",", " ").replaceAll('\n', '')},"
          "${tests[i].liquidLimit.replaceAll(",", " ").replaceAll('\n', '')},"
          "${tests[i].plasticLimit.replaceAll(",", " ").replaceAll('\n', '')},"
          "${tests[i].fines.replaceAll(",", " ").replaceAll('\n', '')},"
          "${tests[i].blows1.replaceAll(",", " ").replaceAll('\n', '')},"
          "${tests[i].blows2.replaceAll(",", " ").replaceAll('\n', '')},"
          "${tests[i].blows3.replaceAll(",", " ").replaceAll('\n', '')},"
          "${tests[i].blowCount.replaceAll(",", " ").replaceAll('\n', '')}");
    }
  }

  void buildProjectCSVLines() {
//    String header = "OBJECTID,Test Type,PROJECT,Number,Client,LATITUDE,LONGITUDE,Projection,North,East,Location,Elevation Datum,Borehole ID,Date Started,Date Completed,Surface Elevation (ft),Contractor/Driller,Method,Logged By,Checked By,Begin Depth (ft),End Depth (ft),Soil Type,Description,Moisture Content,Dry Density (pcf),Liquid Limit (%),Plastic Limit (%),Fines (%),Blows 1st,Blows 2nd,Blows 3rd,N Value";
//    lines.add(header);
    //TODO SizeofTest
    for (int i = 0; i < tests.length; i++) {
      lines.add("$i,"
          + scrubData(tests[i].testType)
          + scrubData(logInfo.project)
          + scrubData(logInfo.number)
          + scrubData(logInfo.client)
          + scrubData(logInfo.lat)
          + scrubData(logInfo.long)
          + scrubData(logInfo.projection)
          + scrubData(logInfo.north)
          + scrubData(logInfo.east)
          + scrubData(logInfo.location)
          + scrubData(logInfo.elevationDatum)
          + scrubData(logInfo.boreholeID)
          + scrubData(logInfo.startDate)
          + scrubData(logInfo.endDate)
          + scrubData(logInfo.surfaceElevation)
          + scrubData(logInfo.contractor)
          + scrubData(logInfo.method)
          + scrubData(logInfo.loggedBy)
          + scrubData(logInfo.checkedBy)
          + scrubData("${tests[i].beginTest}")
          + scrubData("${tests[i].endTest}")
          + ","
          + scrubData(formatTags(tests[i].tags))
          + scrubData(tests[i].moistureContent)
          + scrubData(tests[i].dryDensity)
          + scrubData(tests[i].liquidLimit)
          + scrubData(tests[i].plasticLimit)
          + scrubData(tests[i].fines)
          + scrubData(tests[i].blows1)
          + scrubData(tests[i].blows2)
          + scrubData(tests[i].blows3)
          + scrubData(tests[i].blowCount)
          + "\n\n"
      );
    }
  }

  String buildProjectSegment() {
    PROJECT.add(
          scrubData(logInfo.project)
        + "," //Name
        + scrubData(logInfo.highway)
        + scrubData(logInfo.loggedBy)
        + scrubData(logInfo.county)
        + scrubData(logInfo.number)
        + "," //Input Units
        + "," //Output Units
        + "," //Depth Log page
    );
  }

  String buildPointSegment() {
    POINT.add(
        scrubData(logInfo.project)
      + scrubData(logInfo.north)
      + scrubData(logInfo.east)
      + scrubData(logInfo.equipment)
      + scrubData(logInfo.startDate)
      + scrubData(logInfo.endDate)
      + "," //Purpose
      + "," //Driller
      + scrubData(logInfo.loggedBy)
      + "," //Hole Depth
      + "," //Key_No
      + "," //Start_Card_No
      + "," //Bridge_No
      + scrubData(logInfo.surfaceElevation)
      + "," //Depth Log
      + scrubData(logInfo.tubeHeight)
      + "," //Plunge
    );
  }

  String buildRemarksSegment() {
    REMARKS.add(
        scrubData(logInfo.project)
      + "," //Depth
      + "," //Description
      + "," //Show_Pointer
    );
  }

  String buildWaterLevelsSegment() {
    WATER_LEVELS.add(
        scrubData(logInfo.project)
      + "," //DateTime
      + "," //Depth
      + "," //Note
    );
  }

  String buildWellSegment() {
    WELL.add(
        scrubData(logInfo.project)
      + "," //Depth
      + "," //Bottom
      + "," //Graphic
    );
  }

  String buildLithologySegment() {
    for(int i = 0; i < units.length; i++){
      LITHOLOGY.add(
          scrubData(logInfo.project)
        + scrubData("${units[i].depthLB}")
        + scrubData("${units[i].depthUB}")
        + "," //Grapic
        + scrubData(formatTags(units[i].tags))
        + "," //Formation
      );
    }
  }

  String buildSampleSegment() {
    for(int i = 0; i < tests.length; i++){
      SAMPLE.add(
          scrubData(logInfo.project)
        + scrubData("${tests[i].beginTest}")
        + scrubData("${tests[i].endTest}")
        + scrubData(tests[i].testType)
        + scrubData(i.toString())
        + scrubDataDouble(tests[i].percentRecovery)
        + scrubData(tests[i].soilDrivingResistance)
        + "," //N_value
        + scrubData(tests[i].rockDiscontinuityData)
        + "," //Percent Moisture
        + "," //RQD
        + scrubData(formatTags(tests[i].tags))
        + "," //Soil_Name
        + "," //USCS
        + "," //Soil_Color
        + scrubData(tests[i].moistureContent)
        + "," //Consistency
        + "," //Soil_Texture
        + "," //Soil_Structure
        + "," //Soil_Other
        + "," //Soil_Origin
        + "," //Rock_Name
        + "," //Rock_Color
        + "," //Weathering
        + "," //Hardness
        + "," //Rock_Structure
        + "," //Rock_Other
        + "," //Formation
      );
    }
  }

  String formatTags(String tags){
    String formattedTags;
    debugPrint("(CSV)tags: $tags");
    if(tags != "[]") {
      List<String> parsedList;
      formattedTags = tags.substring(2, tags.length - 2);
      debugPrint("(CSV)tagsFormatted: $formattedTags");
      parsedList = formattedTags.split("\",\"");
      formattedTags = '';
      for (int i = 0; i < parsedList.length; i++) {
        debugPrint("(CSV) parsedList $i: ${parsedList[i]}");
        formattedTags += parsedList[i] + "; ";
      }

      debugPrint("(CSV)tagsFormatted: $formattedTags");
    } else {
      formattedTags = "";
    }
    return formattedTags;
  }

  String formatLinesToString(){
    String formattedString = '';
    for(int i = 0; i < lines.length; i++){
      formattedString = formattedString + lines[i] + '\n';
    }
    return formattedString;
  }

  String formatProjectLinesToString(){
    String formattedString = '';
    List<int> tempArray = [PROJECT.length, POINT.length, REMARKS.length, WATER_LEVELS.length, WELL.length, LITHOLOGY.length, SAMPLE.length];
    int bound = 0;
    for(int i = 0; i < tempArray.length; i++){
      if(bound < tempArray[i]){
        bound = tempArray[i];
      }
    }
    for(int i = 0; i < bound; i++){
      //Check if there is a project to append for the given index
      if(i >= PROJECT.length){

      } else {

      }

      //Check if there is a point to append for the given index
      if(i >= POINT.length){

      } else {

      }

      //Check if there is a remark to append for the given index
      if(i >= REMARKS.length){

      } else {

      }

      //Check if there is a water_level to append for the given index
      if(i >= WATER_LEVELS.length){

      } else {

      }

      //Check if there is a well to append for the given index
      if(i >= WELL.length){

      } else {

      }

      //Check if there is a lithology to append for the given index
      if(i >= LITHOLOGY.length){

      } else {

      }

      //Check if there is a sample to append for the given index
      if(i >= SAMPLE.length){

      } else {

      }
    }
    return formattedString;
  }

  Future<String> csvWrite(String toWrite, String csvName) async {
    await new Future.delayed(new Duration(milliseconds: 50));
    PermissionStatus permission =
    await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    if (permission.toString() != "PermissionStatus.granted") {
      await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    }
    await new Future.delayed(new Duration(milliseconds: 50));
    permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    if (permission.toString() != "PermissionStatus.granted"){
      Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.storage]);
      print("Permission denied. PDF write cancelled."); // TODO - Better handle permission denied case.
    } else {
      final output = await getExternalStorageDirectory();
      String filepathCSV = "${output.path}/${stateData.currentProject}_$csvName.csv";
      //String filepathTXT = "${output.path}/$csvName.txt";
      final file = File(filepathCSV);
      debugPrint("(CSV) printing csv to: $filepathCSV");
      await file.writeAsString(toWrite);
      debugPrint("(CSV) done writing csv");
      return "done";
    }
    return "failed";
  }

  //testing
  void testStuff() async{
    String toWrite;
    debugPrint("(CSV) Currentdoc: ${stateData.currentDocument}");
    for(int i = 0; i < stateData.unitList.length; i++){
      debugPrint("(CSV) unitList at $i: ${stateData.unitList[i]}");
    }
    for(int i = 0; i < stateData.testList.length; i++){
      debugPrint("(CSV) testList at $i: ${stateData.testList[i]}");
    }

    await getData();

    debugPrint("(CSV)LogInfo: ${logInfo.project}");
    for(int i = 0; i < units.length; i++){
      debugPrint("(CSV) units at $i: ${units[i].depthLB}");
    }
    for(int i = 0; i < tests.length; i++){
      debugPrint("(CSV) tests at $i: ${tests[i].beginTest}");
    }

    buildCSVLines();

    for(int i = 0; i < lines.length; i++){
      debugPrint("(CSV) lines to print:  ${lines[i]}");
    }

    toWrite = formatLinesToString();

    debugPrint("(CSV) formatted String: $toWrite");

    csvWrite(toWrite, "Testing");

  }

}