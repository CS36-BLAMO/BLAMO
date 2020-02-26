
import 'dart:io';
import 'dart:async';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:blamo/PDF/pdf_classes.dart';
import 'package:blamo/PDF/pdf_dummy_data.dart';

Document pdf = Document();

// Victoria fields:
// Log info: ID, test type, project, number, client, lat, long, location, elevation datum, borehold id, start date, end date,
//          surface elevation, contractor, method, logged by, checked by
// Test/hole: Begin depth, end depth, soil type, description, moisture content, dry density, liquid limit, plastic limit,
//            fines, Blows 1, Blows 2, Blows 3, Blows count

void docCreate(){
  // Initialize dummy data
  LogInfoPDF holeLog = new LogInfoPDF();
  holeLog.init(objectID, testType, project, number, client, lat, long, location, elevationDatum, boreholeID, startDate, endDate, surfaceElevation, contractor, method, loggedBy, checkedBy);
  
  UnitPDF unit1 = new UnitPDF();
  unit1.init(beginUnitDepth, endUnitDepth, unitDescription, unitMethods);
  UnitPDF unit2 = new UnitPDF();
  unit2.init("-2.5", "-6.0", unitDescription, unitMethods);
  UnitPDF unit3 = new UnitPDF();
  unit3.init("-6.0", "-8.0", unitDescription, unitMethods);
  UnitPDF unit4 = new UnitPDF();
  unit4.init("-8.0", "-9.0", unitDescription, unitMethods);
  UnitPDF unit5 = new UnitPDF();
  unit5.init("-9.0", "-10.0", unitDescription, unitMethods);
  UnitPDF unit6 = new UnitPDF();
  unit6.init("-10.0", "-11.0", unitDescription, unitMethods);
  UnitPDF unit7 = new UnitPDF();
  unit7.init("-11.0", "-12.0", unitDescription, unitMethods);
  UnitPDF unit8 = new UnitPDF();
  unit8.init("-13.0", "-14.0", unitDescription, unitMethods);
  UnitPDF unit9 = new UnitPDF();
  unit9.init("-15.0", "-16.0", unitDescription, unitMethods);
  UnitPDF unit10 = new UnitPDF();
  unit10.init("-17.0", "-18.0", unitDescription, unitMethods);

  TestPDF test1 = new TestPDF();
  test1.init(beginTestDepth, endTestDepth, soilType, description, moistureContent, dryDensity, liquidLimit, plasticLimit, fines, blows1, blows2, blows3, blowCount);
  TestPDF test2 = new TestPDF();
  test2.init("-2.5", "-3.0", soilType, description, moistureContent, dryDensity, liquidLimit, plasticLimit, fines, blows1, blows2, blows3, blowCount);
  TestPDF test3 = new TestPDF();
  test3.init("-3.0", "-5.0", soilType, description, moistureContent, dryDensity, liquidLimit, plasticLimit, fines, blows1, blows2, blows3, blowCount);
  TestPDF test4 = new TestPDF();
  test4.init("-3.0", "-5.0", soilType, description, moistureContent, dryDensity, liquidLimit, plasticLimit, fines, blows1, blows2, blows3, blowCount);
  TestPDF test5 = new TestPDF();
  test5.init("-3.0", "-5.0", soilType, description, moistureContent, dryDensity, liquidLimit, plasticLimit, fines, blows1, blows2, blows3, blowCount);


  List<TestPDF> tests = [test1, test2, test3, test4, test5];
  List<UnitPDF> units = [unit1, unit2, unit3, unit4, unit5, unit6, unit7, unit8, unit9, unit10];

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
    String filepath = "${output.path}/output_test.pdf";
    final file = File(filepath);
    print("writing to file at path"+filepath);
    await file.writeAsBytes(pdf.save()); // TODO - Name files better
    print("done");
    return;
  }
  return;
}
