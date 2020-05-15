
import 'dart:io';
import 'dart:async';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:blamo/PDF/pdf_classes.dart';
import 'package:blamo/Boreholes/BoreholeList.dart';
import 'package:blamo/ObjectHandler.dart' as handler;

// globals
Document pdf = Document();
List<handler.Test> testsToDisplay = [];
double pageHeight = 763.6;

List<Widget> testsToWidgetList(List<handler.Test> tests){               // Takes a list of tests as abstracted objects and returns a list of tests as widgets
  List<Widget> tempWidgets = [];
  for(var k = 0; k < tests.length; k++){
    String testTags = tests[k].tags;
    testTags = testTags.replaceAll('"', '');
    testTags = testTags.replaceAll('[','');
    testTags = testTags.replaceAll(']','');
    testTags = testTags.replaceAll(',', ', ');
    tempWidgets.add(Container( 
        child: Text(
            tests[k].testType + 
            "("+tests[k].beginTest.toString() + " to " + tests[k].endTest.toString() + "m)\t|\t" + 
            "Soil tags: " + testTags + "\t|\t" + 
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


Widget testsToWidget(List<handler.Test> tests, String unitDescriptor){      // Takes a list of tests and a unit description and returns a list of tests formatted as level widgets.
    List<Widget>  widgetTests = [];                                         //        unitDescriptor is usually bounds as string or some other text descriptor
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
  Widget mock;
  Document canvas = new Document();
  mock = testsToWidget(splits[i].tests,"");
  List<Widget> mockWrapper = [mock];
  try{                                                        // "render" the test widget to set box.height
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
  }catch(e){

  }
  if (mock.box.height > maxHeight){                           // if rendered box height with tests is greater than max height, we need to do something
    if (i+1 <= splits.length-1){                              // if another free split exists, dump our last test into it.
       splits[i+1].tests.add(splits[i].tests.last);
       splits[i].tests.removeLast();
       splits = trimSplitAtIndex(splits, i, maxHeight);
    }
    else{                                                     // otherwise we need a new split. create new split and dump a test into it.
      splits.add(new Level());
      splits[i+1].descriptor = splits[i].descriptor;
      splits[i+1].tests.add(splits[i].tests.last);
      splits[i].tests.removeLast();
      splits = trimSplitAtIndex(splits, i, maxHeight);
    }
   }
   else{                                                      // touch up the layers visually before we return
      if(splits[i].descriptor != "Unbounded tests\n"){        // mark descriptor with asterix to indicate level is not to scale. Skip marking unbounded tests,
          splits[i].descriptor = "*" + splits[i].descriptor;  //                as the unbounded level is inherently unscaled.
       }
      List<handler.Test> tempList = [];
      if(i+1 < splits.length){                                // if we have a valid next split to sort, sort it
        if (splits[i+1].tests.length > 1){
          for(int x = splits[i+1].tests.length; x > 0; x--){
            tempList.add(splits[i+1].tests[x-1]);
          }
          splits[i+1].tests = tempList;
        }
      } 
      splits[i].scaledRenderHeight = mock.box.height;
    }
  return splits;
}


List<Level> boxSplit(Level l, double maxHeight){        // manually divide a level whose rendered height exceeds maxHeight over multiple new valid levels. returns a list of these new levels
  List<Level> splits = [];
  splits.add(l);                                        // init our new smaller level array with our base overflowing level.
  for (int i = 0; i < splits.length; i++){              // while we have splits left,
    if (splits[i].tests.length > 0){                    //  if there are tests in the level,
      splits = trimSplitAtIndex(splits, i, maxHeight);  //    trim all overflowing tests into a new level ("split")
    }
    else{                                               //  if there aren't any tests in the level,
      splits.remove(splits[i]);                         //    remove it for the sake of condensing whitespace.
    }
  }

  return splits;
}

void addFailed(String e){                               // Override the pdf with an error pdf. Body text passed as argument.
    pdf = Document();
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
        child: Text('ERROR',
                style: Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey, fontSize: 10)));
    },
    build:(Context context) => <Widget>[
        Text("ERROR - Exception in PDF creation.\n"+e)])); 
}



// -- MAIN --
Future<String> docCreate(StateData currentState) async{

  // -- Initialization -- 
  var tests;                                // Create levels from provided lists of tests and units
  var units;
  var loginfoInit; 
  try{                                      // attempt to fetch information from disk
    tests = await getTests(currentState);
    units = await getUnits(currentState);
    loginfoInit = await getLogInfo(currentState.currentDocument, currentState.currentProject);
  } catch (e){                              // if error reading from disk, abort and write failed pdf
    addFailed("There was an error reading the log data from disk. Make sure all of your data is valid.\n"+ e.toString());
    String onFinish = await pdfWrite(currentState);
    if(onFinish == "done"){
      return "error";
    } else {
      return "failed";
    }
  }
  var loginfo = new LogInfoPDF();           // convert app's LogInfo object to PDF-tailored object
  loginfo.init(loginfoInit);
  List<Level> levels = [];
  List<int> testIndexesStored = [];
  testsToDisplay = [];
  for (var i = 0; i < tests.length; i++){   // toss all tests into a testsToDisplay global
    testsToDisplay.add(tests[i]);
  }


  // -- Level Generation --
  var maxLevelIndeces = [];                         // maxLevelIndeces: levels that need the most space for scaling
  var maxLevelSize = 0.0; 
  var maxBoxHeight = 0.0;
  var tpm;                                          // test per meter
  for (var i = 0; i < units.length; i++){           // populating levels with information from units and corresponding tests
    levels.add(new Level());                        //    a test corresponds to a unit if its starting bound is within a units range
    levels[i].unit = units[i];
    levels[i].setDepth();
    print("Populating level "+i.toString());
    for (var k = 0; k < tests.length; k++){
      if (tests[k].beginTest >= levels[i].beginDepth && tests[k].beginTest < levels[i].endDepth && !testIndexesStored.contains(k)){
        levels[i].tests.add(tests[k]);
        testIndexesStored.add(k);
        print("Stored test"+(k+1).toString());
      }
    }
    tpm = levels[i].tests.length/(levels[i].unit.depthLB.abs() - levels[i].unit.depthUB.abs());   
    if (tpm > maxLevelSize){                          // if tpm is new highest needed, set it and indicate which level set it
      maxLevelSize = tpm;
      maxLevelIndeces.clear();
      maxLevelIndeces.add(i);
    }
    else if (tpm == maxLevelSize){                    // if level matches highest tpm, add it to list of levels that need the most space
      maxLevelIndeces.add(i);
    }
  }

  List<Widget> widgetLevels = [];                     // Init widget list to dump converted levels
  
  for(var i = 0; i < levels.length; i++){             // Convert all bounded test objects to widgets, format level tags
    levels[i].descriptor = levels[i].unit.depthUB.toString() + " to " + levels[i].unit.depthLB.toString() + "\n";
    widgetLevels.add(testsToWidget(levels[i].tests, levels[i].descriptor));
    for(var j = 0; j < levels[i].tests.length; j++){  // Remove from testToDisplay once widget added to widgetLevels
      testsToDisplay.remove(levels[i].tests[j]);
    }
    String unitTags = levels[i].unit.tags;            // format tags from unit to level object
    unitTags = unitTags.replaceAll('"', '');
    unitTags = unitTags.replaceAll('[','');
    unitTags = unitTags.replaceAll(']','');
    unitTags = unitTags.replaceAll(',', ', ');
    levels[i].tags = unitTags;
  }

  levels.sort((a,b)=> a.beginDepth.compareTo(b.beginDepth));   // sort so they go in descending order

  if (testsToDisplay.length > 0){                    // Dump all uncaught tests into a level at the end
    Level overflowLevel = new Level();
    overflowLevel.tests = testsToDisplay;
    overflowLevel.descriptor = "Unbounded tests\n";
    levels.add(overflowLevel);
    widgetLevels.add(testsToWidget(testsToDisplay, "Unbounded tests\n"));
  }


  // --Depth Scaling--
  try{                                              // "render" the pdf to get the flex height of level with most tests
    pdf.addPage(MultiPage(                          // this sets widgetLevels properties for display, which we can read from
      pageFormat:
          PdfPageFormat.letter.copyWith(marginBottom: 0.5 * PdfPageFormat.cm,
                                        marginTop: 0.5 * PdfPageFormat.cm,
                                        marginLeft: 0.5 * PdfPageFormat.cm,
                                        marginRight: 0.5 * PdfPageFormat.cm), 
      crossAxisAlignment: CrossAxisAlignment.start,
      build: (Context context) => <Widget>[Wrap( 
                children: widgetLevels)
    ]));
  }catch(e){

  }

  var maxLevelIndex;
  if (maxLevelIndeces.length > 1){                  // of all the levels tied for most tests per meter, grab the index of the one that takes up the most space in the doc
    var highestBox = 0.0;
    for(int i = 0; i < maxLevelIndeces.length; i++){
      if (widgetLevels[maxLevelIndeces[i]].box.height > highestBox){
        highestBox = widgetLevels[maxLevelIndeces[i]].box.height;
        maxLevelIndex = maxLevelIndeces[i];
      }
    }
  }
  else if (maxLevelIndeces.length == 1) {
    maxLevelIndex = maxLevelIndeces[0];
  }
                                                  // NOTE: Widget properties such as height are read-only. As such we have to perform logic changes to abstracted levels, then convert to widgets 
                                                  //      which we can "write" to our pdf, which updates our read-only values.
  var scale;
  if(maxLevelIndeces.length >= 1){                // use the level with the max height to generate a scale that all other levels adhere to
    maxBoxHeight = widgetLevels[maxLevelIndex].box.height;
    scale = maxBoxHeight/(levels[maxLevelIndex].unit.depthLB.abs()-levels[maxLevelIndex].unit.depthUB.abs()); // Scale is in pixels per meter
  }

  for(int i = 0; i < levels.length; i++){         // manually carry over auto-rendered height for the unscaled unbounded level
    if(levels[i].descriptor == "Unbounded tests\n"){
      levels[i].scaledRenderHeight = widgetLevels.last.box.height;
    }
  }

  for(int i = 0; i < levels.length; i++){         // iterate over all scaled tests and clamp them to a min height if they are too small
    try {
      if (maxLevelIndeces.length >= 1){
        levels[i].scaledRenderHeight = scale * (levels[i].unit.depthLB-levels[i].unit.depthUB);
        if (levels[i].scaledRenderHeight < 23){
          levels[i].notToScale = "*";
          levels[i].descriptor = levels[i].notToScale + levels[i].descriptor;
          levels[i].scaledRenderHeight = 23;
        }
      }
    } catch(e){
      continue;
    }
  }


  // --Overflowing Level Handling--
  List<Level> pageScaledLevels = [];                                // init list of level objects adjusted with 
  for(int j = 0; j < levels.length; j++){                           // Once rendered and scaled, iterate over and split oversized levels so they can fit on individual pages
    if (levels[j].scaledRenderHeight > pageHeight){                 // if we can't display on one page, need to handle it
      levels[j].notToScale = "*";
      if (levels[j].tests.length > 0){                              // if we have tests, split box over pages and redistribute tests
        List<Level> splitLevels = boxSplit(levels[j], pageHeight);  // returns a list of smaller valid widgets
        for (int k = 0; k < splitLevels.length; k++){
          pageScaledLevels.add(splitLevels[k]);
        }
      }
      else{                                        
        levels[j].scaledRenderHeight = 23;                          // if we don't have tests, just trim to display range
        pageScaledLevels.add(levels[j]);        
      }
    }
    else{
      pageScaledLevels.add(levels[j]);                              // else we're good to display on one page with current scaling, add to list
    }   
  }

  List<Widget> widgetScaledLevels = [];                             // convert level objects to widgets
  for(int i = 0; i < pageScaledLevels.length; i++){
      widgetScaledLevels.add(testsToWidget(pageScaledLevels[i].tests, pageScaledLevels[i].descriptor));
  }

  for(int i = 0; i < widgetScaledLevels.length; i++){               
    if(pageScaledLevels[i].scaledRenderHeight is double){           // if scaledRenderHeight is not null, use as height for display
      widgetScaledLevels[i] = Container(height: pageScaledLevels[i].scaledRenderHeight,
                                  decoration: BoxDecoration(border: new BoxBorder(left: true, top: true, right: true, bottom: true, color: PdfColors.black, width: 1.0)),
                                  child: widgetScaledLevels[i]);
    }
    else{                                                           // otherwise just write as-is          
      widgetScaledLevels[i] = Container(decoration: BoxDecoration(border: new BoxBorder(left: true, top: true, right: true, bottom: true, color: PdfColors.black, width: 1.0)),
                                  child: widgetScaledLevels[i]);
    }
  }


  // --Description Generation and Manual Text Wrapping--
  // have to manually trim overflowing information here due to lack of extension funcitonality. pdf library flexes atomically on words, not characters
  String leveltags = "";
  int consecutiveChars = 0;

  for(int i = 0; i < levels.length; i++){               // bunch of string parsing. insert a newline every 100 chars if no break in the word.
  
    if(levels[i].descriptor != "Unbounded tests\n"){    // read unit meta data if present and dump in level tags for display at top of document.
      leveltags = leveltags + levels[i].notToScale+"("+levels[i].unit.depthUB.toString() + " to " + levels[i].unit.depthLB.toString() + ")"+"  |  Tags: ";
      
      consecutiveChars = 0;
      for(int j = 0; j < levels[i].tags.length; j++){
        if (levels[i].tags[j] == " " || levels[i].tags[j] == "\n"){
          consecutiveChars = 0;
        }
        if (consecutiveChars == 100){
           leveltags = leveltags + "\n";
           consecutiveChars = 0;
        }
        else {
          leveltags = leveltags + levels[i].tags[j];
          consecutiveChars++;
        }
      }

      consecutiveChars = 0;
      leveltags = leveltags + ' | Methods: ';
      for(int j = 0; j < levels[i].unit.drillingMethods.length; j++){
        if (levels[i].unit.drillingMethods[j] == " " || levels[i].unit.drillingMethods[j] == "\n"){
          consecutiveChars = 0;
        }
        if (consecutiveChars == 100){
          leveltags = leveltags + "\n";
          consecutiveChars = 0;
        }
        else {
          leveltags = leveltags + levels[i].unit.drillingMethods[j];
          consecutiveChars++;
        }
      }

      consecutiveChars = 0;
      leveltags = leveltags + ' | Notes: ';
      for(int j = 0; j < levels[i].unit.notes.length; j++){
        if (levels[i].unit.notes[j] == " " || levels[i].unit.notes[j] == "\n"){
          consecutiveChars = 0;
        }
        if (consecutiveChars == 100){
          leveltags = leveltags + "\n";
          consecutiveChars = 0;
        }
        else {
          leveltags = leveltags + levels[i].unit.notes[j];
          consecutiveChars++;
        }
      }
      leveltags = leveltags + '\n';
    }
  } 
  leveltags = leveltags + "* = layer not displayed to scale in output";


  // --Building the Document--
  pdf = Document();
  bool failed = false;
  try{ // DEBUG - set maxPages to 1 and create a doc larger than 1 page to induce error.
  pdf.addPage(MultiPage(
    maxPages: 50,
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
              <String>['Start Date: '+loginfo.startDate, 'End Date: '+loginfo.endDate, 'ID: '+loginfo.boreholeID, 'Number: '+loginfo.number,  'Latitude: '+loginfo.lat, 'Longitude: '+loginfo.long, 'Location: '+loginfo.location]
            ]),
            Table.fromTextArray(context: context, data: <List<String>>[
              <String>['Highway: '+loginfo.highway, 'County: '+loginfo.county, 'Elevation Datum: '+loginfo.elevationDatum, 'Surface Elevation: '+loginfo.surfaceElevation, 'Tube Height: '+loginfo.tubeHeight]
            ]),
            Table.fromTextArray(context: context, data: <List<String>>[
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
            Container(
              padding: const EdgeInsets.all(5),
              constraints: BoxConstraints(maxWidth: 582),
              decoration: BoxDecoration(border: new BoxBorder(left: true, top: true, right: true, bottom: true, color: PdfColors.black, width: 1.0)),
              child: Text(leveltags, style: TextStyle(fontSize: 10))
            ),
            Wrap( 
              children: widgetScaledLevels),
            ]));
  }catch(e){
    addFailed("There was an error writing borehole data to the PDF. Try spreading your data across multiple boreholes.\n" +e.toString());
    failed = true;
  }
  String onFinished = await pdfWrite(currentState); 

  if(onFinished == "done" && !failed){          // no issues
    return "done";
  } else if(onFinished == "done" && failed){    // pdf wrote successfully with internal error
    return "error";
  } else {                                      // pdf did not write
    return "failed";
  }

  // we're done!
}

Future<handler.LogInfo> getLogInfo(String currentDocument, String currentProject) async{      // read the loginfo from the disk
    print("(pdf): in getLogInfo");
    handler.ObjectHandler objectHandler = new handler.ObjectHandler(currentProject);
    handler.LogInfo info;
    await objectHandler.getLogInfoData(currentDocument).then((onValue){
        print("(pdf): got loginfo for "+currentDocument);
        info = onValue;
    });
    return info;
}

Future<List<handler.Test>> getTests(StateData currentState) async{                            // read the tests from disk
    print("(pdf) In getTests");
    handler.ObjectHandler objectHandler = new handler.ObjectHandler(currentState.currentProject);
    List<handler.Test> fetchedTests = [];
    for(int i = 0; i < currentState.testList.length; i++){
      print("(pdf): Searching: ${currentState.currentDocument}");
      await objectHandler.getTestData(currentState.testList[i], currentState.currentDocument).then((onValue){
        try{
          onValue.beginTest = onValue.beginTest - (2*onValue.beginTest); 
          onValue.endTest = onValue.endTest - (2*onValue.endTest);     
          fetchedTests.add(onValue);
          print("(pdf): ${currentState.testList[i]} added");
        } catch(NoSuchMethodError){
          print('Omitting a null test at index '+i.toString());
        }

      });
    }
    return fetchedTests;
  }

Future<List<handler.Unit>> getUnits(StateData currentState) async{                          // read the units from disk
    print("(pdf) In getUnits");
    handler.ObjectHandler objectHandler = new handler.ObjectHandler(currentState.currentProject);
    List<handler.Unit> fetchedUnits = [];
    for(int i = 0; i < currentState.unitList.length; i++){
      print("(pdf): Searching: ${currentState.currentDocument}");
      await objectHandler.getUnitData(currentState.unitList[i], currentState.currentDocument).then((onValue){
        try{
          onValue.depthUB = onValue.depthUB - (2*onValue.depthUB);   
          onValue.depthLB = onValue.depthLB - (2*onValue.depthLB);
          fetchedUnits.add(onValue);
          print("(pdf): ${currentState.unitList[i]} added");
        } catch(NoSuchMethodError){
          print('Omitting a null unit at index '+i.toString());
        }
      });
    }
    return fetchedUnits;
  }

Future<String> pdfWrite(StateData currentState) async{                                      // ask for user permissions, generate filename, write to filepath
  //DateTime now = DateTime.now();
  await new Future.delayed(new Duration(seconds: 1));
  PermissionStatus permission =
    await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
  if (permission.toString() != "PermissionStatus.granted") {
    //Map<PermissionGroup, PermissionStatus> permissions = 
      await PermissionHandler().requestPermissions([PermissionGroup.storage]);
  } 
  await new Future.delayed(new Duration(seconds: 1));
  permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
  if (permission.toString() != "PermissionStatus.granted"){
    print("Permission denied. PDF write cancelled."); 
    pdf = Document();
  }
  else {
    final output = await getExternalStorageDirectory();
    String filepath = "${output.path}/${currentState.currentProject}_${currentState.currentDocument}" +".pdf"; //Took out + now.toString() can version files later with backend work to find most recent file
    final file = File(filepath);
    print("writing to file at path: "+ filepath);
    await file.writeAsBytes(pdf.save()); 
    print("done");
    return "done";
  }
  return "failed";
}
