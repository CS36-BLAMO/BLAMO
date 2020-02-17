
import 'dart:io';
import 'dart:async';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

final pdf = Document();

class Unit { // TODO - toss these in another file. Touch up inits?
    double beginUnitDepth;
    double endUnitDepth;
    String unitDescription;
    String unitMethods;

    void init(String beginUnitDepth, endUnitDepth, unitDescription, unitMethods){
      this.beginUnitDepth = double.parse(beginUnitDepth);
      this.endUnitDepth = double.parse(endUnitDepth);
      this.unitDescription = unitDescription;
      this.unitMethods = unitMethods;
    }
}

class Test {
    double beginTestDepth;
    double endTestDepth;
    String soilType;
    String description;
    String moistureContent;
    String dryDensity;
    String liquidLimit;
    String plasticLimit;
    String fines;
    String blows1;
    String blows2;
    String blows3;
    String blowCount;

    void init(String beginTestDepth, endTestDepth, soilType, description, moistureContent, dryDensity, liquidLimit, plasticLimit, fines, blows1, blows2, blows3, blowCount){
      this.beginTestDepth = double.parse(beginTestDepth);
      this.endTestDepth = double.parse(endTestDepth);
      this.soilType = soilType;
      this.description = description;
      this.moistureContent = moistureContent;
      this.dryDensity = dryDensity;
      this.liquidLimit = liquidLimit;
      this.plasticLimit = plasticLimit;
      this.fines = fines;
      this.blows1 = blows1;
      this.blows2 = blows2;
      this.blows3 = blows3;
      this.blowCount = blowCount;
    }
}

class Level { //class for holding units and associated tests.
    Unit unit;
    List<Test> tests = [];
    double beginDepth; // GOES BY ELEVATION. begindepth is higher elevation, or technically a "lower" bound. i.e. 0.
    double endDepth; //                      enddepth is lower elevation, or technically a "higher" bound. i.e. -2.5.
    void setDepth(){
      this.beginDepth = this.beginDepth ?? this.unit.beginUnitDepth;
      this.endDepth = this.endDepth ?? this.unit.endUnitDepth;
    }
}

class LogInfo {
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
    String startDate;
    String endDate;
    String surfaceElevation;
    String contractor;
    String method;
    String loggedBy;
    String checkedBy;
    String fakedata;

  void init(String objectID, testType, project, number, client, lat, long, location, elevationDatum, boreholeID, startDate, endDate, surfaceElevation, contractor, method, loggedBy, checkedBy){
    this.objectID = objectID;
    this.testType = testType;
    this.project = project;
    this.number = number;
    this.client = client;
    this.lat = lat;
    this.long = long;
    this.location = location;
    this.elevationDatum = elevationDatum;
    this.boreholeID = boreholeID;
    this.startDate = startDate;
    this.endDate = endDate;
    this.surfaceElevation = surfaceElevation;
    this.contractor = contractor;
    this.method = method;
    this.loggedBy = loggedBy;
    this.checkedBy = checkedBy;
  }
}

// Victoria fields:
// Log info: ID, test type, project, number, client, lat, long, location, elevation datum, borehold id, start date, end date,
//          surface elevation, contractor, method, logged by, checked by
// Test/hole: Begin depth, end depth, soil type, description, moisture content, dry density, liquid limit, plastic limit,
//            fines, Blows 1, Blows 2, Blows 3, Blows count


// SAMPLE LOG DATA
String objectID = "1";
String testType = "SPT";
String project = "I-5 @ OR214 Interchange (Woodburn) Development Sec.";
String number = "PE000559";
String client = "Oregon Department of Transportation";
String lat = "550129.7734";
String long = "7590750.9362";
String location = "MP 33.75";
String elevationDatum = "[Elevation Datum]";
String boreholeID = "12518-01";
String startDate = "5/1/2010";
String endDate = "5/1/2010";
String surfaceElevation = "186.51";
String contractor = "Adonis - Western States";
String method = "MUD ROTARY - AUTO HAMMER";
String loggedBy = "Castelli";
String checkedBy = "HSK / GAF / JFF";

//TEST SAMPLE DATA
String beginTestDepth = "0";
String endTestDepth = "-2.5";
String soilType = "ML";
String description = "SILT with trace to some Sand";
String moistureContent = "38-31";
String dryDensity = "dry density";
String liquidLimit = "liquid limit";
String plasticLimit = "plastic limit";
String fines = "fines";
String blows1 = "5";
String blows2 = "7";
String blows3 = "11"; 
String blowCount = "18";

//UNIT SAMPLE DATA
String beginUnitDepth = "0";
String endUnitDepth = "-2.5";
String unitDescription = "Sandy GRAVEL (Shoulder Aggregate), GP";
String unitMethods = "Unit Drilling Method";

void docCreate(){
  // Initialize dummy data
  LogInfo holeLog = new LogInfo();
  holeLog.init(objectID, testType, project, number, client, lat, long, location, elevationDatum, boreholeID, startDate, endDate, surfaceElevation, contractor, method, loggedBy, checkedBy);
  
  Unit unit1 = new Unit();
  unit1.init(beginUnitDepth, endUnitDepth, unitDescription, unitMethods);
  Unit unit2 = new Unit();
  unit2.init("-2.5", "-6.0", unitDescription, unitMethods);
  Unit unit3 = new Unit();
  unit3.init("-6.0", "-8.0", unitDescription, unitMethods);
  Unit unit4 = new Unit();
  unit4.init("-8.0", "-9.0", unitDescription, unitMethods);
  Unit unit5 = new Unit();
  unit5.init("-9.0", "-10.0", unitDescription, unitMethods);
  Unit unit6 = new Unit();
  unit6.init("-10.0", "-11.0", unitDescription, unitMethods);
  Unit unit7 = new Unit();
  unit7.init("-11.0", "-12.0", unitDescription, unitMethods);
  Unit unit8 = new Unit();
  unit8.init("-13.0", "-14.0", unitDescription, unitMethods);
  Unit unit9 = new Unit();
  unit9.init("-15.0", "-16.0", unitDescription, unitMethods);
  Unit unit10 = new Unit();
  unit10.init("-17.0", "-18.0", unitDescription, unitMethods);

  Test test1 = new Test();
  test1.init(beginTestDepth, endTestDepth, soilType, description, moistureContent, dryDensity, liquidLimit, plasticLimit, fines, blows1, blows2, blows3, blowCount);
  Test test2 = new Test();
  test2.init("-2.5", "-3.0", soilType, description, moistureContent, dryDensity, liquidLimit, plasticLimit, fines, blows1, blows2, blows3, blowCount);
  Test test3 = new Test();
  test3.init("-3.0", "-5.0", soilType, description, moistureContent, dryDensity, liquidLimit, plasticLimit, fines, blows1, blows2, blows3, blowCount);
  Test test4 = new Test();
  test4.init("-3.0", "-5.0", soilType, description, moistureContent, dryDensity, liquidLimit, plasticLimit, fines, blows1, blows2, blows3, blowCount);
  Test test5 = new Test();
  test5.init("-3.0", "-5.0", soilType, description, moistureContent, dryDensity, liquidLimit, plasticLimit, fines, blows1, blows2, blows3, blowCount);


  List<Test> tests = [test1, test2, test3, test4, test5];
  List<Unit> units = [unit1, unit2, unit3, unit4, unit5, unit6, unit7, unit8, unit9, unit10];

  // Create levels from provided lists of tests and units 
  List<Level> levels = [];
  List<int> testIndexesStored = [];
  for (var i = 0; i < units.length; i++){ // TODO - need to add validator in Units page so that no Unit depths overlap.
    levels.add(new Level());
    levels[i].unit = units[i];
    levels[i].setDepth();
    print("Populating level "+i.toString());
    for (var k = 0; k < tests.length; k++){
      
      if (tests[k].beginTestDepth > levels[i].endDepth && !testIndexesStored.contains(k)){ // TODO - confirm client is ok with this functionality in output. if a test is majority in another level but starts in another, which should it be in?
        levels[i].tests.add(tests[k]);
        testIndexesStored.add(k);
        print("Stored test"+(k+1).toString());
      }
    }
  }
  
  // Convert levels to widgets
  List<Widget> widgetLevels = [];
  List<Widget> widgetTests = [];
  // Create test widgets
  for(var i = 0; i < levels.length; i++){
    widgetTests = [];
    for(var j = 0; j < levels[i].tests.length; j++){
      widgetTests.add(
        Container( 
          child: Text( // TESTS
            levels[i].tests[j].beginTestDepth.toString() + " to " + levels[i].tests[j].endTestDepth.toString() + " | " + // TODO - Make prettier.
            levels[i].tests[j].soilType + " | " + 
            levels[i].tests[j].description + " | " +
            levels[i].tests[j].moistureContent + " | " +
            levels[i].tests[j].dryDensity + " | " +
            levels[i].tests[j].liquidLimit + " | " +
            levels[i].tests[j].plasticLimit + " | " +
            levels[i].tests[j].fines + " | " +
            levels[i].tests[j].blows1 + " | " +
            levels[i].tests[j].blows2 + " | " + 
            levels[i].tests[j].blows3 + " | " +
            levels[i].tests[j].blowCount, textScaleFactor: 0.5),
          decoration: BoxDecoration(border: new BoxBorder(left: true, top: true, right: true, bottom: true, color: PdfColors.black, width: 1.0)),
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          width: 425
        ));
    }
    widgetLevels.add(
      Row(mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
        Column(mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
              Container( // UNIT TODO - Vertical fill
                constraints: BoxConstraints(maxWidth: 150),
                child: Text(levels[i].unit.beginUnitDepth.toString() + " to " + levels[i].unit.endUnitDepth.toString() + "\n" + 
                            levels[i].unit.unitDescription + "\n" + 
                            levels[i].unit.unitMethods + "\n"),
                decoration: BoxDecoration(border: new BoxBorder(left: true, top: true, right: true, bottom: true, color: PdfColors.black, width: 1.0)),
                padding: const EdgeInsets.all(10),
              ),
          ],
        ),
        Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start,
          children: widgetTests
        )]
      )
    );
  }

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
        child: Text('DRILL LOG | '+ client.toUpperCase() + ' | Page ${context.pageNumber} of ${context.pagesCount}',
                style: Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey)));
    },
    build: (Context context) => <Widget>[
            Header(
                level: 0,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('DRILL LOG\n'+ client.toUpperCase(), textScaleFactor: 1)
                    ])),
            Paragraph(
                text:
                    project),
            Table.fromTextArray(context: context, data: <List<String>>[
              <String>['Object ID', 'Test Type', 'Number', 'Latitude', 'Longitude', 'Location'], // TODO - persists across pages, make it not
              <String>[objectID, testType, number, lat, long, location]
            ]),
            Table.fromTextArray(context: context, data: <List<String>>[
              <String>['Borehole ID', 'Start Date', 'End Date', 'Surface Elevation', 'Contractor'],
              <String>[boreholeID, startDate, endDate, surfaceElevation, contractor]
            ]),
            Table.fromTextArray(context: context, data: <List<String>>[
              <String>['Method', 'Logged By', 'Checked By'],
              <String>[method, loggedBy, checkedBy],
            ]),
            Paragraph(text:"\n"),
            //Column(mainAxisAlignment: MainAxisAlignment.start,
            Wrap( 
              children: widgetLevels)
            ]));
  pdf_write(); //
}

void pdf_write() async{
    await new Future.delayed(new Duration(seconds: 1));
    PermissionStatus permission =
      await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
  if (permission.toString() != "PermissionStatus.granted") {
    Map<PermissionGroup, PermissionStatus> permissions = 
      await PermissionHandler().requestPermissions([PermissionGroup.storage]);// TODO - fix permissions. Right now you have to click PDF twice to write.
    //if (permissions[permission].toString() == "PermissionStatus.granted") { 
    //  final output = await getExternalStorageDirectory();
    //  String filepath = "${output.path}/output.pdf";
    //  final file = File(filepath);
    //  file.writeAsBytesSync(pdf.save());
    //  print("done");
    //  return;
    //}
  } else {
    final output = await getExternalStorageDirectory();
    String filepath = "${output.path}/output_test.pdf";
    final file = File(filepath);
    print("writing to file at path"+filepath);
    await file.writeAsBytes(pdf.save()); // TODO - if file exists, it appends data to the file. ex multiple docs tacked onto each other.
    print("done");
    return;
  }
  return;
}
