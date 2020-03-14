import 'package:flutter/material.dart';
import 'package:blamo/ObjectHandler.dart';
import 'package:blamo/main.dart';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class CSVExporter {
  ObjectHandler objectHandler = new ObjectHandler();
  StateData stateData;

  LogInfo logInfo;
  List<Unit> units;
  List<Test> tests;
  List<String> lines = [];

  CSVExporter(this.stateData);

  void exportToCSV() async{
    String toWrite;
    await getData();
    buildCSVLines();
    toWrite = formatLinesToString();
    debugPrint("toWrite: $toWrite");
    csvWrite(toWrite, stateData.currentDocument);
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

  void buildCSVLines(){
    String header = "OBJECTID,Test Type,PROJECT,Number,Client,LATITUDE,LONGITUDE,North,East,Location,Elevation Datum,Borehole ID,Date Started,Date Completed,Surface Elevation (ft),Contractor/Driller,Method,Logged By,Checked By,Begin Depth (ft),End Depth (ft),Soil Type,Description,Moisture Content,Dry Density (pcf),Liquid Limit (%),Plastic Limit (%),Fines (%),Blows 1st,Blows 2nd,Blows 3rd,N Value";
    lines.add(header);

    //TODO SizeofTest
    for(int i = 0; i < tests.length; i++){
      lines.add("$i,"
          "${tests[i].testType.replaceAll(",", " ").replaceAll('\n', '')},"
          "${logInfo.project.replaceAll(",", " ").replaceAll('\n', '')},"
          "${logInfo.number.replaceAll(",", " ").replaceAll('\n', '')},"
          "${logInfo.client.replaceAll(",", " ").replaceAll('\n', '')},"
          "${logInfo.lat.replaceAll(",", " ").replaceAll('\n', '')},"
          "${logInfo.long.replaceAll(",", " ").replaceAll('\n', '')},"
          ","
          ","
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
          "${formatTags(tests[i].tags)},"
          ","
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

  void csvWrite(String toWrite, String csvName) async {
    await new Future.delayed(new Duration(milliseconds: 50));
    PermissionStatus permission =
    await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    if (permission.toString() != "PermissionStatus.granted") {
      Map<PermissionGroup, PermissionStatus> permissions =
      await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    }
    await new Future.delayed(new Duration(milliseconds: 50));
    permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    if (permission.toString() != "PermissionStatus.granted"){
      print("Permission denied. PDF write cancelled."); // TODO - Better handle permission denied case.
    } else {
      final output = await getExternalStorageDirectory();
      String filepathCSV = "${output.path}/$csvName.csv";
      String filepathTXT = "${output.path}/$csvName.txt";
      final file = File(filepathCSV);
      debugPrint("(CSV) printing csv to: $filepathCSV");
      await file.writeAsString(toWrite);
      debugPrint("(CSV) done writing csv");
      return;
    }
    return;
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