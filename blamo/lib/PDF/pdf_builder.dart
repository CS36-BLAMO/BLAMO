
import 'dart:io';
import 'dart:async';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:blamo/PDF/pdf_classes.dart';
import 'package:blamo/Boreholes/BoreholeList.dart';
import 'package:blamo/ObjectHandler.dart' as handler;

Document pdf = Document();
List<handler.Test> testsToDisplay = [];
double pageHeight = 763.6;

List<Widget> testsToWidgetList(List<handler.Test> tests){
  // Takes a list of tests and returns a list of tests as widgets
  List<Widget> tempWidgets = [];
  for(var k = 0; k < tests.length; k++){
    String testTags = tests[k].tags;
    testTags = testTags.replaceAll('"', '');
    testTags = testTags.replaceAll('[','');
    testTags = testTags.replaceAll(']','');
    testTags = testTags.replaceAll(',', ', ');
    tempWidgets.add(Container( 
        child: Text( // TESTS
            tests[k].testType + 
            "("+tests[k].beginTest.toString() + " to " + tests[k].endTest.toString() + "m)\t|\t" + 
            "Soil tags: " + testTags + "\t|\t" + // TODO - clean up tag display
            "% Recovery: " + tests[k].percentRecovery.toString() + "\t|\t" +
            "SDR: " + tests[k].soilDrivingResistance + "\t|\t" +
            "RDD: " + tests[k].rockDiscontinuityData + "\t|\t" +
            "RQD: " + tests[k].rockQualityDesignation + "\t|\t" +
            "Moisture content: " + tests[k].moistureContent + "\t|\t" +
            "Dry density: " + tests[k].dryDensity + "\t|\t" +
            "Liquid limit: " + tests[k].liquidLimit + "\t|\t" +
            "Plastic limit: " + tests[k].plasticLimit + "\t|\t" +
            "Fines: " + tests[k].fines + "\t|\t" +
            "Blows 1: " + tests[k].blows1 + "\t|\t" +
            "Blows 2: " + tests[k].blows2 + "\t|\t" + 
            "Blows 3: " + tests[k].blows3 + "\t|\t" +
            "Blow count: " + tests[k].blowCount, textScaleFactor: 0.65),
          decoration: BoxDecoration(border: new BoxBorder(left: true, top: true, right: true, bottom: true, color: PdfColors.black, width: 0.5)),
          padding: const EdgeInsets.all(5),
          width: 494
        ));
  }
  return tempWidgets;
}


Widget testsToWidget(List<handler.Test> tests, String unitDescriptor){
    // Takes a list of tests and a unit description and returns a list of tests formatted as level widgets.
    // Unit description is usually bounds or some other text descriptor
    List<Widget>  widgetTests = [];
    widgetTests = testsToWidgetList(tests);
    return(Container(
        child:Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
          Container(
            constraints: BoxConstraints(maxWidth: 90),
            child: Text(unitDescriptor, style: TextStyle(fontSize: 10)),
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

List<Level> trimSplitAtIndex(List<Level> splits, int i, double maxHeight){
  Context tempContext;
  Widget mock;
  Document canvas = new Document();
  mock = testsToWidget(splits[i].tests,"");
  List<Widget> mockWrapper = [mock];
  //mock.paint(tempContext); 
  canvas.addPage(MultiPage(
    pageFormat:
        PdfPageFormat.letter.copyWith(marginBottom: 0.5 * PdfPageFormat.cm,
                                      marginTop: 0.5 * PdfPageFormat.cm,
                                      marginLeft: 0.5 * PdfPageFormat.cm,
                                      marginRight: 0.5 * PdfPageFormat.cm), 
    crossAxisAlignment: CrossAxisAlignment.start,
    build: (Context context) => <Widget>[Wrap( 
              children: mockWrapper)
    ]));

  if (mock.box.height > maxHeight){
    if (i+1 <= splits.length-1){ 
      // if another free split exists, dump our last test into it.
       splits[i+1].tests.add(splits[i].tests.last);
       splits[i].tests.removeLast();
       splits = trimSplitAtIndex(splits, i, maxHeight);
    }
    else{
      // otherwise we need a new split.
      splits.add(new Level());
      splits[i+1].descriptor = splits[i].descriptor;
      splits[i+1].tests.add(splits[i].tests.last);
      splits[i].tests.removeLast();
      splits = trimSplitAtIndex(splits, i, maxHeight);
    }
   }
   else{
     splits[i].descriptor = "*" + splits[i].descriptor;
     splits[i].scaledRenderHeight = mock.box.height;
     return splits;
   }
}

List<Level> boxSplit(Level l, double maxHeight){ 
  List<Level> splits = [];
  splits.add(l);
  for (int i = 0; i < splits.length; i++){
    if (splits[i].tests.length > 0){
      splits = trimSplitAtIndex(splits, i, maxHeight);
    }
    else{
      splits.remove(splits[i]);
    }
  }

  return splits;
}

Future<String> docCreate(StateData currentState) async{

  // Create levels from provided lists of tests and units 
  var tests = await getTests(currentState);
  var units = await getUnits(currentState);
  var loginfoInit = await getLogInfo(currentState.currentDocument, currentState.currentProject);
  var loginfo = new LogInfoPDF();
  loginfo.init(loginfoInit);
  //var loginfo = await getLogInfo(currentState.currentDocument, currentState.currentProject);
  List<Level> levels = [];
  List<int> testIndexesStored = [];
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
      if (tests[k].beginTest >= levels[i].beginDepth && tests[k].beginTest < levels[i].endDepth && !testIndexesStored.contains(k)){ // TODO - confirm client is ok with this functionality in output. if a test is majority in another level but starts in another, which should it be in?
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
  
  // Convert all bounded tests to widgets, format level tags
  for(var i = 0; i < levels.length; i++){

    levels[i].descriptor = levels[i].unit.depthUB.toString() + " to " + levels[i].unit.depthLB.toString() + "\n";
    widgetLevels.add(testsToWidget(levels[i].tests, levels[i].descriptor));
    for(var j = 0; j < levels[i].tests.length; j++){
      testsToDisplay.remove(levels[i].tests[j]);
    }

    // format tags from unit to level object
    String unitTags = levels[i].unit.tags;
    unitTags = unitTags.replaceAll('"', '');
    unitTags = unitTags.replaceAll('[','');
    unitTags = unitTags.replaceAll(']','');
    unitTags = unitTags.replaceAll(',', ', ');
    levels[i].tags = unitTags;
  }

  // Dump all uncaught tests into a level at the end
  if (testsToDisplay.length > 0){
    Level overflowLevel = new Level();
    overflowLevel.tests = testsToDisplay;
    overflowLevel.descriptor = "Unbounded tests\n";
    levels.add(overflowLevel);
    widgetLevels.add(testsToWidget(testsToDisplay, "Unbounded tests\n"));
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
  else if (max_level_indeces.length == 1) {
    max_level_index = max_level_indeces[0];
  }

  var scale;
  var testsScaled;
  
  if(max_level_indeces.length >= 1){
    max_box_height = widgetLevels[max_level_index].box.height;
    scale = max_box_height/(levels[max_level_index].unit.depthLB.abs()-levels[max_level_index].unit.depthUB.abs()); // Scale is in pixels per meter
    testsScaled = [];
  }

  for(int i = 0; i < levels.length; i++){
    if(levels[i].descriptor == "Unbounded tests\n"){
      levels[i].scaledRenderHeight = widgetLevels.last.box.height;
    }
  }

  for(int i = 0; i < levels.length; i++){
  try {
    if (max_level_indeces.length >= 1){
      levels[i].scaledRenderHeight = scale * (levels[i].unit.depthLB-levels[i].unit.depthUB);
      if (levels[i].scaledRenderHeight < 23){
        levels[i].scaledRenderHeight = 23;
      }
      testsScaled.add(i);
    }
    else{
      levels[i].scaledRenderHeight = 1;
    }
  } catch(e){
    continue;
  }
  }

  // Once rendered and scaled, iterate over and split oversized levels so they can fit on individual pages
  List<Level> pageScaledLevels = [];
  for(int j = 0; j < levels.length; j++){
    if (levels[j].scaledRenderHeight > pageHeight){ 
      levels[j].notToScale = "*";
    // if we can't display on one page, need to handle it
      if (levels[j].tests.length > 0){              
        // if we have tests, split box over pages and redistribute tests
        List<Level> splitLevels = boxSplit(levels[j], pageHeight);
        for (int k = 0; k < splitLevels.length; k++){
          pageScaledLevels.add(splitLevels[k]);
        }
      }
      else{                                        
         // if we don't have tests, just trim to display range
        levels[j].scaledRenderHeight = 23;
        pageScaledLevels.add(levels[j]);        
      }
    }
    else{
    // we're good to display on one page with current scaling, add to lsit
      pageScaledLevels.add(levels[j]);
    }
  }

  List<Widget> widgetScaledLevels = [];
  for(int i = 0; i < pageScaledLevels.length; i++){
      widgetScaledLevels.add(testsToWidget(pageScaledLevels[i].tests, pageScaledLevels[i].descriptor));
  }

  for(int i = 0; i < widgetScaledLevels.length; i++){
    //if(testsScaled.contains(i)){
    if(pageScaledLevels[i].scaledRenderHeight is double){
      // if scaled, add it with the scaled height.
      widgetScaledLevels[i] = Container(height: pageScaledLevels[i].scaledRenderHeight,
                                  decoration: BoxDecoration(border: new BoxBorder(left: true, top: true, right: true, bottom: true, color: PdfColors.black, width: 1.0)),
                                  //child: widgetLevels[i]);
                                  child: widgetScaledLevels[i]);
    }
    else{
      // if not, add it without.
      widgetScaledLevels[i] = Container(decoration: BoxDecoration(border: new BoxBorder(left: true, top: true, right: true, bottom: true, color: PdfColors.black, width: 1.0)),
                                  //child: widgetLevels[i]);
                                  child: widgetScaledLevels[i]);
    }
  }

  String leveltags = "";
  //build unit tag text block
  for(int i = 0; i < levels.length; i++){
    if(levels[i].descriptor != "Unbounded tests\n"){
      leveltags = leveltags + levels[i].notToScale+"("+levels[i].unit.depthUB.toString() + " to " + levels[i].unit.depthLB.toString() + ")"+"  |  " + 
                      levels[i].tags + ' | ' + levels[i].unit.drillingMethods + ' | ' + levels[i].unit.notes + '\n';
    }
  } 
  leveltags = leveltags + "* = layer not displayed to scale in output";
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
                    
            Table.fromTextArray(context: context, data: <List<String>>[
              // TODO - LatLong in pdf or North East?
              <String>['Start Date: '+loginfo.startDate, 'End Date: '+loginfo.endDate, 'ID: '+loginfo.boreholeID, 'Number: '+loginfo.number,  'Latitude: '+loginfo.lat, 'Longitude: '+loginfo.long, 'Location: '+loginfo.location]
            ]),
            Table.fromTextArray(context: context, data: <List<String>>[
              //<String>['Highway', 'County', 'Elevation Datum', 'Surface Elevation', 'Tube Height'],
              <String>['Highway: '+loginfo.highway, 'County: '+loginfo.county, 'Elevation Datum: '+loginfo.elevationDatum, 'Surface Elevation: '+loginfo.surfaceElevation, 'Tube Height: '+loginfo.tubeHeight]
            ]),
            Table.fromTextArray(context: context, data: <List<String>>[
              //<String>['Contractor', 'Equipment', 'Method', 'Logged By', 'Checked By'],
              <String>['Projection: '+loginfo.projection, 'Equipment: '+loginfo.equipment, 'Method: '+loginfo.method],
            ]),
            Table.fromTextArray(context: context, data: <List<String>>[
              <String>['Contractor: '+loginfo.contractor, 'Logged by: '+loginfo.loggedBy, 'Checked by: '+loginfo.checkedBy]
            ]),
            Container(
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(5),
                    constraints: BoxConstraints(maxWidth: 114, maxHeight: 80),
                    decoration: BoxDecoration(border: new BoxBorder(left: true, top: true, right: true, bottom: true, color: PdfColors.black, width: 1.0)),
                    child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text("Test Type", style: TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.bold, fontSize: 9)),
                        ),
                        Container(
                          child: Text('"A" - Auger Core\n"X" - Auger"\n"C" - Core, Barrel Type\n"N" - Standard Penetration\n"U" - Undisturbed Sample\n"T" - Test Pit', style: TextStyle(fontSize: 8)) 
                        ),
                      ]
                    )
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    constraints: BoxConstraints(maxWidth: 254, maxHeight: 80),
                    decoration: BoxDecoration(border: new BoxBorder(left: true, top: true, right: true, bottom: true, color: PdfColors.black, width: 1.0)),
                    child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text("Rock Abbreviations", style: TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.bold, fontSize: 9)),
                        ),
                        Container(
                          //child: Text("Discontinuity\tShape\tSurface Roughness")
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                                Container(constraints: BoxConstraints(maxWidth: 80), child:Text('Discontinuity\nJ - Joint\nF - Fault\nB - Bedding\nFo - Foliation\nS - Shear', style: TextStyle(fontSize: 8))),
                                Container(constraints: BoxConstraints(maxWidth: 80), child:Text('Shape\nPl - Planar\nC - Curved\nU - Undulating\nSt - Stepped\nIr - Irregular', style: TextStyle(fontSize: 8))),
                                Container(constraints: BoxConstraints(maxWidth: 80), child:Text('Surface Roughness\nP - Polished\nSl - Slickensided\nSm - Smooth\nR - Rough\nVR - Very Rough', style: TextStyle(fontSize: 8))) 
                            ] 
                          )
                        )
                      ]
                    )),
                  Container(
                    padding: const EdgeInsets.all(5),
                    constraints: BoxConstraints(maxWidth: 214, maxHeight: 80),
                    decoration: BoxDecoration(border: new BoxBorder(left: true, top: true, right: true, bottom: true, color: PdfColors.black, width: 1.0)),
                    child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text("Typical Drilling Abbreviations", style: TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.bold, fontSize: 9))
                        ),
                        Container(
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                                Container(constraints: BoxConstraints(maxWidth: 90), child:Text('Drilling Methods\nWL - Wire Line\nHS - Hollow Stem Auger\nDP - Drill Fluid\nSA - Solid Fligh Auger\nCA - Casing Advancer\nHA - Hand Auger', style: TextStyle(fontSize: 7))),
                                Container(constraints: BoxConstraints(maxWidth: 90), child:Text('Drilling Remarks\nLW - Lost Water\nWR - Water Return\nWC - Water Color\nD - Down Pressure\nDR - Drill Rate\nDA - Drill Action', style: TextStyle(fontSize: 7))),
                            ] 
                          )
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
              children: widgetScaledLevels),
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

Future<handler.LogInfo> getLogInfo(String currentDocument, String currentProject) async{
    print("(pdf): in getLogInfo");
    handler.ObjectHandler objectHandler = new handler.ObjectHandler(currentProject);
    handler.LogInfo info;
    await objectHandler.getLogInfoData(currentDocument).then((onValue){
        print("(pdf): got loginfo for "+currentDocument);
        info = onValue;
    });
    return info;
}

Future<List<handler.Test>> getTests(StateData currentState) async{
    print("(pdf) In getTests");
    handler.ObjectHandler objectHandler = new handler.ObjectHandler(currentState.currentProject);
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
    handler.ObjectHandler objectHandler = new handler.ObjectHandler(currentState.currentProject);
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
    String filepath = "${output.path}/${currentState.currentProject}_${currentState.currentDocument}" +".pdf"; //Took out + now.toString() can version files later with backend work to find most recent file
    final file = File(filepath);
    print("writing to file at path: "+ filepath);
    await file.writeAsBytes(pdf.save()); // TODO - Name files better
    print("done");
    return "done";
  }
  return "failed";
}
