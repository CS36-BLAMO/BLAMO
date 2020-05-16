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
  LogInfo logInfo;
  List<Unit> units;
  List<Test> tests;
  List<String> lines = [];

  //returns a CSVExporter object with an initialized object handler (relies on object handler to handle Unit/Test/Loginfo I/O)
  CSVExporter(this.stateData){
    objectHandler = new ObjectHandler(stateData.currentProject);
  }

  /*Initializes the exporting process, this depends on local buildCSVLines(), formatLinesToString(), and csvWrite().
  *Additionally, this depends on the currentState.currentDocument and currentState.currentProject to be set appropriately
  */
  Future<String> exportToCSV() async{
    String toWrite;
    await getData();
    buildCSVLines();
    toWrite = formatLinesToString();
    //debugPrint("toWrite: $toWrite");
    String response = await csvWrite(toWrite, stateData.currentDocument);
    return response;
  }

  //Gets the stored logInfo/Units/Tests by calling the object handler and building the local lists for each respective category.
  Future<int> getData() async{
    //gets the logInfo data for the currentDocument
    logInfo = await objectHandler.getLogInfoData(stateData.currentDocument);
    try{
      //gets the List<units> data for the currentDocument
      units = await objectHandler.getUnitsData(stateData.unitList, stateData.currentDocument);
    } catch (e){
      debugPrint("(CSV)ERROR getting units");
    }

    try{
      //gets the List<test> data for the currentDocument
      tests = await objectHandler.getTestsData(stateData.testList, stateData.currentDocument);
    } catch (e){
      debugPrint("(CSV)ERROR getting tests");
    }
    //debugPrint("SUCCESS");
    return 0;
  }

  //Loops through all of the tests and builds the rows for the CSV
  void buildCSVLines(){
    String header = "OBJECTID,Test Type,PROJECT,Number,Client,LATITUDE,LONGITUDE,Projection,North,East,Location,Elevation Datum,Borehole ID,Date Started,Date Completed,Surface Elevation (ft),Contractor/Driller,Method,Logged By,Checked By,Begin Depth (ft),End Depth (ft),Soil Type,Description,Moisture Content,Dry Density (pcf),Liquid Limit (%),Plastic Limit (%),Fines (%),Blows 1st,Blows 2nd,Blows 3rd,N Value";
    lines.add(header);

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

  //Formats the parsed Tags to be locally readable
  String formatTags(String tags){
    String formattedTags;
    //debugPrint("(CSV)tags: $tags");
    if(tags != "[]") {
      List<String> parsedList;
      formattedTags = tags.substring(2, tags.length - 2);
      //debugPrint("(CSV)tagsFormatted: $formattedTags");
      parsedList = formattedTags.split("\",\"");
      formattedTags = '';
      for (int i = 0; i < parsedList.length; i++) {
        //debugPrint("(CSV) parsedList $i: ${parsedList[i]}");
        formattedTags += parsedList[i] + "; ";
      }

      //debugPrint("(CSV)tagsFormatted: $formattedTags");
    } else {
      formattedTags = "";
    }
    return formattedTags;
  }

  //loops through lines[] to build the string that is written into the csv file
  String formatLinesToString(){
    String formattedString = '';
    for(int i = 0; i < lines.length; i++){
      formattedString = formattedString + lines[i] + '\n';
    }
    return formattedString;
  }

  //creates and writes to the CSV file
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
  /*void testStuff() async{
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

  }*/

}