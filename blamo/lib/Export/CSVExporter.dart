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
    String header = "OBJECTID,Test Type,PROJECT,Number,Client,LATITUDE,LONGITUDE,Projection,North,East,Location,Elevation Datum,Borehole ID,Date Started,Date Completed,Surface Elevation (ft),Contractor/Driller,Method,Logged By,Checked By,Begin Depth (ft),End Depth (ft),Soil Type,Description,Moisture Content,Dry Density (pcf),Liquid Limit (%),Plastic Limit (%),Fines (%),Blows 1st,Blows 2nd,Blows 3rd,N Value";
    lines.add(header);
    for(int i = 0; i < tempData.list.length; i++){
      debugPrint('tempData.list[$i]: ${tempData.list[i]}');
      if(tempData.list[i] != ''){
        tempData.currentDocument = tempData.list[i];
        await tempData.storage.setStateData(tempData);
        await getData();
        await new Future.delayed(new Duration(milliseconds: 100));
        buildCSVLines();
      }
    }
    toWrite = formatLinesToString();
    debugPrint('Writing to csv: \n $toWrite');
  }

  Future<int> getData() async{
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

  void buildCSVLines(){
//    String header = "OBJECTID,Test Type,PROJECT,Number,Client,LATITUDE,LONGITUDE,Projection,North,East,Location,Elevation Datum,Borehole ID,Date Started,Date Completed,Surface Elevation (ft),Contractor/Driller,Method,Logged By,Checked By,Begin Depth (ft),End Depth (ft),Soil Type,Description,Moisture Content,Dry Density (pcf),Liquid Limit (%),Plastic Limit (%),Fines (%),Blows 1st,Blows 2nd,Blows 3rd,N Value";
//    lines.add(header);

    //TODO SizeofTest
    for(int i = 0; i < tests.length; i++){
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