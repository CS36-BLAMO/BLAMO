
import 'dart:io';
import 'dart:async';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:blamo/PDF/pdf_classes.dart';
import 'package:blamo/main.dart';
import 'package:blamo/ObjectHandler.dart' as handler;

Document pdf = Document();

// Victoria fields:
// Log info: ID, test type, project, number, client, lat, long, location, elevation datum, borehold id, start date, end date,
//          surface elevation, contractor, method, logged by, checked by
// Test/hole: Begin depth, end depth, soil type, description, moisture content, dry density, liquid limit, plastic limit,
//            fines, Blows 1, Blows 2, Blows 3, Blows count

Future<String> docCreate(StateData currentState) async{

  // Create levels from provided lists of tests and units 
  var tests = await getTests(currentState);
  var units = await getUnits(currentState);
  var loginfo = await getLogInfo(currentState.currentDocument);
  List<Level> levels = [];
  List<int> testIndexesStored = [];
  var testsToDisplay = [];
  for (var i = 0; i < tests.length; i++){
    testsToDisplay.add(tests[i]);
  }

//  var max_levels = [];
  var max_level_indeces = [];
  var max_level_size = 0.0;
  var max_box_height = 0.0;
  var tpm; // test per meter
  for (var i = 0; i < units.length; i++){ // TODO - need to add validator in Units page so that no Unit depths overlap.
    levels.add(new Level());
    levels[i].unit = units[i];
    levels[i].setDepth();
    print("Populating level "+i.toString());
    for (var k = 0; k < tests.length; k++){
      if (tests[k].beginTest > levels[i].endDepth && !testIndexesStored.contains(k)){ // TODO - confirm client is ok with this functionality in output. if a test is majority in another level but starts in another, which should it be in?
        levels[i].tests.add(tests[k]);
        testIndexesStored.add(k);
        print("Stored test"+(k+1).toString());
      }
    }
    tpm = levels[i].tests.length/(levels[i].unit.depthLB.abs() - levels[i].unit.depthUB.abs());
    if (tpm > max_level_size){
      max_level_size = tpm;
      //max_levels.clear();
      //max_levels.add(levels[i]);
      max_level_indeces.clear();
      max_level_indeces.add(i);
    }
    else if (tpm == max_level_size){
      //max_levels.add(levels[i]);
      max_level_indeces.add(i);
    }
  }

  // Convert levels to widgets
  List<Widget> widgetLevels = [];
  List<Widget> widgetTests = [];
  
  // Create test widgets
  for(var i = 0; i < levels.length; i++){
    widgetTests = [];
    String unitTags = levels[i].unit.tags;
    unitTags = unitTags.replaceAll('"', '');
    unitTags = unitTags.replaceAll('[','');
    unitTags = unitTags.replaceAll(']','');
    unitTags = unitTags.replaceAll(',', ', ');
    levels[i].tags = unitTags;
    for(var j = 0; j < levels[i].tests.length; j++){
      String testTags = levels[i].tests[j].tags;
      testTags = testTags.replaceAll('"', '');
      testTags = testTags.replaceAll('[','');
      testTags = testTags.replaceAll(']','');
      testTags = testTags.replaceAll(',', ', ');
      widgetTests.add(
        Container( 
          child: Text( // TESTS
            "("+levels[i].tests[j].beginTest.toString() + " to " + levels[i].tests[j].endTest.toString() + "m)\t|\t" + 
            "Soil tags: " + testTags + "\t|\t" + // TODO - clean up tag display
            "% Recovery: " + levels[i].tests[j].percentRecovery.toString() + "\t|\t" +
            "SDR: " + levels[i].tests[j].soilDrivingResistance + "\t|\t" +
            "RDD: " + levels[i].tests[j].rockDiscontinuityData + "\t|\t" +
            "RQD: " + levels[i].tests[j].rockQualityDesignation + "\t|\t" +
            "Moisture content: " + levels[i].tests[j].moistureContent + "\t|\t" +
            "Dry density: " + levels[i].tests[j].dryDensity + "\t|\t" +
            "Liquid limit: " + levels[i].tests[j].liquidLimit + "\t|\t" +
            "Plastic limit: " + levels[i].tests[j].plasticLimit + "\t|\t" +
            "Fines: " + levels[i].tests[j].fines + "\t|\t" +
            "Blows 1: " + levels[i].tests[j].blows1 + "\t|\t" +
            "Blows 2: " + levels[i].tests[j].blows2 + "\t|\t" + 
            "Blows 3: " + levels[i].tests[j].blows3 + "\t|\t" +
            "Blow count: " + levels[i].tests[j].blowCount, textScaleFactor: 0.65),
          decoration: BoxDecoration(border: new BoxBorder(left: true, top: true, right: true, bottom: true, color: PdfColors.black, width: 0.5)),
          padding: const EdgeInsets.all(5),
          width: 434
        ));
      testsToDisplay.remove(levels[i].tests[j]);
    }

    widgetLevels.add(
      Container(
        //decoration: BoxDecoration(border: new BoxBorder(left: true, top: true, right: true, bottom: true, color: PdfColors.black, width: 1.0)),
        //margin: const EdgeInsets.only(bottom:10),
        child:Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
          Container(
            constraints: BoxConstraints(maxWidth: 150),
            child: Text(levels[i].unit.depthUB.toString() + " to " + levels[i].unit.depthLB.toString() + "\n" + 
                        levels[i].unit.drillingMethods + "\n", style: TextStyle(fontSize: 10)),
            padding: const EdgeInsets.all(5),
          ),
          Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
            children: widgetTests
          )
          ]
        )
      )
    );
  }

  // unbounded test handling
  // SUPER gross, should tuck these all away into a function to clean up the file. TODO
  if (testsToDisplay.length > 0){
    widgetTests = [];
    for (var i = 0; i < testsToDisplay.length; i++){
      String testTags = testsToDisplay[i].tags;
      testTags = testTags.replaceAll('"', '');
      testTags = testTags.replaceAll('[','');
      testTags = testTags.replaceAll(']','');
      testTags = testTags.replaceAll(',', ', ');
      widgetTests.add(
        Container( 
          child: Text( // TESTS
            "("+testsToDisplay[i].beginTest.toString() + " to " + testsToDisplay[i].endTest.toString() + "m)\t|\t" + 
            "Soil tags: " + testTags + "\t|\t" + // TODO - clean up tag display
            "% Recovery: " + testsToDisplay[i].percentRecovery.toString() + "\t|\t" +
            "SDR: " + testsToDisplay[i].soilDrivingResistance + "\t|\t" +
            "RDD: " + testsToDisplay[i].rockDiscontinuityData + "\t|\t" +
            "RQD: " + testsToDisplay[i].rockQualityDesignation + "\t|\t" +
            "Moisture content: " + testsToDisplay[i].moistureContent + "\t|\t" +
            "Dry density: " + testsToDisplay[i].dryDensity + "\t|\t" +
            "Liquid limit: " + testsToDisplay[i].liquidLimit + "\t|\t" +
            "Plastic limit: " + testsToDisplay[i].plasticLimit + "\t|\t" +
            "Fines: " + testsToDisplay[i].fines + "\t|\t" +
            "Blows 1: " + testsToDisplay[i].blows1 + "\t|\t" +
            "Blows 2: " + testsToDisplay[i].blows2 + "\t|\t" + 
            "Blows 3: " + testsToDisplay[i].blows3 + "\t|\t" +
            "Blow count: " + testsToDisplay[i].blowCount, textScaleFactor: 0.65),
          decoration: BoxDecoration(border: new BoxBorder(left: true, top: true, right: true, bottom: true, color: PdfColors.black, width: 0.5)),
          padding: const EdgeInsets.all(5),
          width: 434
        ));
    }
    widgetLevels.add(
      Container(
        //margin: const EdgeInsets.only(bottom:10),
        child:Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
          Container(
            width: 150,
            child: Text("Unbounded Tests",style: TextStyle(fontSize: 10)),
            padding: const EdgeInsets.all(10),
          ),
          Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center,
            children: widgetTests
          )
          ]
        )
      )
    );
  }

  String leveltags = "";
  //build unit tag text block
  for(int i = 0; i < levels.length; i++){
    leveltags = leveltags + "("+levels[i].unit.depthUB.toString() + " to " + levels[i].unit.depthLB.toString() + ")  |  " + 
                    levels[i].tags + '\n';
  } 
  //"render" the pdf to get the flex height of level with most tests
  pdf.addPage(MultiPage(
    pageFormat:
        PdfPageFormat.letter.copyWith(marginBottom: 0.5 * PdfPageFormat.cm,
                                      marginTop: 0.5 * PdfPageFormat.cm,
                                      marginLeft: 0.5 * PdfPageFormat.cm,
                                      marginRight: 0.5 * PdfPageFormat.cm), 
    crossAxisAlignment: CrossAxisAlignment.start,
    build: (Context context) => <Widget>[Wrap( 
              children: widgetLevels)
  ]));

  var max_level_index;
  if (max_level_indeces.length > 1){
    var highest_box = 0.0;
    for(int i = 0; i < max_level_indeces.length; i++){
      if (widgetLevels[max_level_indeces[i]].box.height > highest_box){
        highest_box = widgetLevels[max_level_indeces[i]].box.height;
        max_level_index = max_level_indeces[i];
      }
    }
  }
  else {
    max_level_index = max_level_indeces[0];
  }

  max_box_height = widgetLevels[max_level_index].box.height;
  var scale = max_box_height/(levels[max_level_index].unit.depthLB.abs()-levels[max_level_index].unit.depthUB.abs()); // Scale is in pixels per meter
  var testsScaled = [];

  for(int i = 0; i < levels.length; i++){
    try {
      levels[i].scaledRenderHeight = scale * (levels[i].unit.depthUB-levels[i].unit.depthLB);
      testsScaled.add(i);
    } catch(e){
      continue;
    }
  }
  for(int i = 0; i < widgetLevels.length; i++){
    if(testsScaled.contains(i)){
      widgetLevels[i] = Container(height: levels[i].scaledRenderHeight,
                                  decoration: BoxDecoration(border: new BoxBorder(left: true, top: true, right: true, bottom: true, color: PdfColors.black, width: 1.0)),
                                  child: widgetLevels[i]);
    }else{
      widgetLevels[i] = Container(decoration: BoxDecoration(border: new BoxBorder(left: true, top: true, right: true, bottom: true, color: PdfColors.black, width: 1.0)),
                                  child: widgetLevels[i]);
    }
  }
  pdf = Document();

  // Build it all
  pdf.addPage(MultiPage(
    pageFormat:
        PdfPageFormat.letter.copyWith(marginBottom: 0.5 * PdfPageFormat.cm,
                                      marginTop: 0.5 * PdfPageFormat.cm,
                                      marginLeft: 0.5 * PdfPageFormat.cm,
                                      marginRight: 0.5 * PdfPageFormat.cm), 
    crossAxisAlignment: CrossAxisAlignment.start,
    footer: (Context context) {
      return Container(
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
        child: Text('DRILL LOG | '+ loginfo.client.toUpperCase() + ' | Page ${context.pageNumber} of ${context.pagesCount}',
                style: Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey, fontSize: 10)));
    },
    build: (Context context) => <Widget>[
            Header(
                level: 0,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('DRILL LOG | ' + loginfo.project +'\n'+ loginfo.client.toUpperCase(), textScaleFactor: 1)
                    ])),
            //Paragraph(
            //    text:
            //        loginfo.project),
            Table.fromTextArray(context: context, data: <List<String>>[
              //<String>['Number', 'Start Date', 'End Date', 'Latitude', 'Longitude', 'Location'], 
              <String>['Number: '+loginfo.number, 'Start Date: '+loginfo.startDate, 'End Date: '+loginfo.endDate, 'Latitude: '+loginfo.lat, 'Longitude: '+loginfo.long, 'Location: '+loginfo.location]
            ]),
            Table.fromTextArray(context: context, data: <List<String>>[
              //<String>['Highway', 'County', 'Elevation Datum', 'Surface Elevation', 'Tube Height'],
              <String>['Highway: '+loginfo.highway, 'County: '+loginfo.county, 'Elevation Datum: '+loginfo.elevationDatum, 'Surface Elevation: '+loginfo.surfaceElevation, 'Tube Height: '+loginfo.tubeHeight]
            ]),
            Table.fromTextArray(context: context, data: <List<String>>[
              //<String>['Contractor', 'Equipment', 'Method', 'Logged By', 'Checked By'],
              <String>['Contractor: '+loginfo.contractor, 'Equipment: '+loginfo.equipment, 'Method: '+loginfo.method, 'Logged by: '+loginfo.loggedBy, 'Checked by: '+loginfo.checkedBy],
            ]),
            Container(
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(5),
                    constraints: BoxConstraints(maxWidth: 194, maxHeight: 80),
                    decoration: BoxDecoration(border: new BoxBorder(left: true, top: true, right: true, bottom: true, color: PdfColors.black, width: 1.0)),
                    child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text("Test Type", style: TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.bold, fontSize: 10)),
                        ),
                        Container(
                          child: Text('"A" - Auger Core\n"X" - Auger"\n"C" - Core, Barrel Type\n"N" - Standard Penetration\n"U" - Undisturbed Sample\n"T" - Test Pit', style: TextStyle(fontSize: 8)) 
                        ),
                      ]
                    )
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    constraints: BoxConstraints(maxWidth: 194, maxHeight: 80),
                    decoration: BoxDecoration(border: new BoxBorder(left: true, top: true, right: true, bottom: true, color: PdfColors.black, width: 1.0)),
                    child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text("Rock Abbreviations", style: TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.bold, fontSize: 10)),
                        ),
                        Container(
                          child: Text('"A" - Auger Core\n"X" - Auger"\n"C" - Core, Barrel Type\n"N" - Standard Penetration\n"U" - Undisturbed Sample\n"T" - Test Pit', style: TextStyle(fontSize: 8)) 
                        ),
                      ]
                    )),
                  Container(
                    padding: const EdgeInsets.all(5),
                    constraints: BoxConstraints(maxWidth: 194, maxHeight: 80),
                    decoration: BoxDecoration(border: new BoxBorder(left: true, top: true, right: true, bottom: true, color: PdfColors.black, width: 1.0)),
                    child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text("Typical Drilling Abbreviations", style: TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.bold, fontSize: 10))
                        ),
                        Container(
                          child: Text('"A" - Auger Core\n"X" - Auger"\n"C" - Core, Barrel Type\n"N" - Standard Penetration\n"U" - Undisturbed Sample\n"T" - Test Pit', style: TextStyle(fontSize: 8)) 
                        ),
                      ]
                    )),
                ],
              )
            ),
            //]),
            //Column(mainAxisAlignment: MainAxisAlignment.start,
            Container(
              padding: const EdgeInsets.all(5),
                    constraints: BoxConstraints(maxWidth: 582),
                    decoration: BoxDecoration(border: new BoxBorder(left: true, top: true, right: true, bottom: true, color: PdfColors.black, width: 1.0)),
                    child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text(leveltags))
                      ]
                    )
            ),
            Wrap( 
              children: widgetLevels),
            ]));
  String onFinished = await pdf_write(currentState); //
  if(onFinished == "done"){
    //print("max level: -"+max_level.unit.depthUB.toString()+" - "+max_level.unit.depthLB.toString());
    //print("max level size: "+max_level_size.toString());
    return "done";
  } else {
    return "failed";
  }
}

Future<handler.LogInfo> getLogInfo(String currentDocument) async{
    print("(pdf): in getLogInfo");
    handler.ObjectHandler objectHandler = new handler.ObjectHandler();
    handler.LogInfo info;
    await objectHandler.getLogInfoData(currentDocument).then((onValue){
        print("(pdf): got loginfo for "+currentDocument);
        info = onValue;
    });
    return info;
}

Future<List<handler.Test>> getTests(StateData currentState) async{
    print("(pdf) In getTests");
    handler.ObjectHandler objectHandler = new handler.ObjectHandler();
    List<handler.Test> fetchedTests = [];
    for(int i = 0; i < currentState.testList.length; i++){
      print("(pdf): Searching: ${currentState.currentDocument}");
      await objectHandler.getTestData(currentState.testList[i], currentState.currentDocument).then((onValue){
          onValue.beginTest = onValue.beginTest - (2*onValue.beginTest); // TODO - Unify negative functionality? Add validators or fix this at the test level?
          onValue.endTest = onValue.endTest - (2*onValue.endTest);      // YUCKY GROSS
          fetchedTests.add(onValue);
          print("(pdf): ${currentState.testList[i]} added");
      });
    }
    return fetchedTests;
  }

Future<List<handler.Unit>> getUnits(StateData currentState) async{
    print("(pdf) In getUnits");
    handler.ObjectHandler objectHandler = new handler.ObjectHandler();
    List<handler.Unit> fetchedUnits = [];
    for(int i = 0; i < currentState.unitList.length; i++){
      print("(pdf): Searching: ${currentState.currentDocument}");
      await objectHandler.getUnitData(currentState.unitList[i], currentState.currentDocument).then((onValue){
          onValue.depthUB = onValue.depthUB - (2*onValue.depthUB);    // TODO Unify negative fucntionality? Add validators or fix this at unit level?
          onValue.depthLB = onValue.depthLB - (2*onValue.depthLB);
          fetchedUnits.add(onValue);
          print("(pdf): ${currentState.unitList[i]} added");
      });
    }

    return fetchedUnits;
  }

Future<String> pdf_write(StateData currentState) async{
  DateTime now = DateTime.now();
  await new Future.delayed(new Duration(seconds: 1));
  PermissionStatus permission =
    await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
  if (permission.toString() != "PermissionStatus.granted") {
    Map<PermissionGroup, PermissionStatus> permissions = 
      await PermissionHandler().requestPermissions([PermissionGroup.storage]);
  } 
  await new Future.delayed(new Duration(seconds: 1));
  permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
  if (permission.toString() != "PermissionStatus.granted"){
    print("Permission denied. PDF write cancelled."); // TODO - Better handle permission denied case. 
    pdf = Document();
  }
  else {
    final output = await getExternalStorageDirectory();
    String filepath = "${output.path}/${currentState.currentDocument}" +".pdf"; //Took out + now.toString() can version files later with backend work to find most recent file
    final file = File(filepath);
    print("writing to file at path: "+ filepath);
    await file.writeAsBytes(pdf.save()); // TODO - Name files better
    print("done");
    return "done";
  }
  return "failed";
}
