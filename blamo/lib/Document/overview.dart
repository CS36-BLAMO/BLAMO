import 'package:blamo/main.dart';
import 'package:flutter/material.dart';
import 'package:blamo/File_IO/FileHandler.dart';
import 'package:blamo/SideMenu.dart';

class DocumentPage extends StatefulWidget {
  final StateData pass;
  final PersistentStorage storage = PersistentStorage();

  DocumentPage(this.pass);

  @override
  _DocumentPageState createState() => _DocumentPageState(pass);
}

class _DocumentPageState extends State<DocumentPage> {
  final routeName = '/Document';
  StateData currentState;
  _DocumentPageState(this.currentState);

  @override
  Widget build(BuildContext context) {
    if (currentState != null) {
      currentState.currentRoute = '/Document';
    }

    currentState.storage.checkDocument(currentState.currentDocument).then((bool doesDocumentExist) {
      if (doesDocumentExist && currentState.dirty == 1) {
        upDateStateData(-1);
      } else if(!doesDocumentExist){
        debugPrint("(main)Creating new document");
        int documentNumber = currentState.documentIterator;
        currentState.storage.overWriteDocument(currentState.currentDocument,'$documentNumber\n0\n0');
      }
    });

    return new Scaffold(
      drawer: Drawer(
        child: SideMenu(currentState),
      ),

      appBar: new AppBar(
          title: new Text(currentState.currentDocument),
          actions: <Widget>[
          ],
          backgroundColor: Colors.deepOrange
      ),

      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, i){
          String title;
          switch(i){
            case 0:
              title = "LogInfo";
              break;
            case 1:
              title = "Tests";
              break;
            case 2:
              title = "Units";
              break;
          }
          return new ExpansionTile(
            title: new Text(title),
            children: <Widget>[
              new Column(
                children: _buildExpandedContent(title),
              )
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {createFudgedData();},
      ),

    );
  }

  void createFudgedData() async{
    String a, b, c, test, unit, log;
    a = "Banana";
    b = "Strawberry";
    c = "Smoothie";
    test = "{beginTest:9.9d,endTest:null,soilType:null,moistureContent:\"ITGOINRAIN\",dryDensity:\"itlikethesahara\",liquidLimit:\"Imuptomylimit\",plasticLimit:\"notallthatfake\",fines:\"Imsorryofficer\",blows1:\"Yup\",blows2:\"I think it does\",blows3:\"Not that much\",blowCount:\"25\",tags:\"nonPlastic Woop\"}";
    unit = "{depthUB:0.0d,depthLB:17.2d,beginUnitDepth:14.11d,unitMethods:null,drillingMethods:\"Drillingmethod\",tags:\"nonPlastic,etc\"}"; 
    log = "{projectName:\"WAAAAA\",startDate:\"tomorrow\",endDate:\"Today\",driller:\"george\",projectGeologist:\"you\",recorder:null,northing:\"MaybeNorth\",easting:\"east\",highway:\"some data, revenge of the cloud storage\",county:\"Taco tiger\",purpose:\"Hot-a-dogu\",equipment:\"Taco cat\",objectID:\"Oop\",testType:\"..,asdf\",project:\"yeah its a. project\",number:\"This ,,, Is some stuff\",client:\"i r d k\",lat:\"idk2\",long:\"idk\",location:\"Oregon\",elevationDatum:\"Bae-rito\",boreholeID:\"Boo-rito\",surfaceElevation:\"Tacos\",contractor:\"Animals\",method:\"Dogs\",loggedBy:\"Cats\",checkedBy:\"Lammas\",holeNo:7.22d,eANo:6.8d,keyNo:4.4d,startCardNo:2.2d,groundElevation:45.0d,tubeHeight:1.0d}";

    await currentState.storage.overWriteTest(currentState.currentDocument, a,test);
    await currentState.storage.overWriteTest(currentState.currentDocument, b,test);
    await currentState.storage.overWriteUnit(currentState.currentDocument, c,unit);
    int newTestCount = 2;
    int unitCount = 1;
    await currentState.storage.overWriteDocument(currentState.currentDocument, "${currentState.currentDocument}\n$newTestCount\n$unitCount\n");
    await currentState.storage.writeDocument(currentState.currentDocument, "$a,");
    await currentState.storage.writeDocument(currentState.currentDocument, "$b,");
    await currentState.storage.writeDocument(currentState.currentDocument, "$c,");
    await currentState.storage.overWriteLogInfo(currentState.currentDocument, log);
    setState(() {
      currentState.dirty = 1;
    });
  }

  //Creates a new document manifest
  void createNewTest(String testName) async{
    await currentState.storage.overWriteTest(currentState.currentDocument, testName,"TestName: $testName\n");
    int newTestCount = currentState.testCount++;
    int unitCount = currentState.unitCount;
    currentState.storage.overWriteDocument(currentState.currentDocument, "${currentState.currentDocument}\n$newTestCount\n$unitCount");
  }

  //Creates a new Unit file
  void createNewUnit(String unitName) async{
    await currentState.storage.overWriteUnit(currentState.currentDocument, unitName,"UnitName: $unitName\n");
    currentState.unitCount++;
  }

  //Creates a new LogInfo file
  void createNewLogInfo(int docIteration) async{
    await currentState.storage.overWriteDocument(currentState.currentDocument, "DocumentNumber: $docIteration\n");
  }

  //Updates the currentState object to reflect the manifest document
  void upDateStateData(int num) async{
    await currentState.storage.setStateData(currentState).then((StateData received) {
      currentState.list = received.list;

      currentState.testCount = received.testCount;
      currentState.unitCount = received.unitCount;
      currentState.testList = received.testList;
      currentState.unitList = received.unitList;

      currentState.dirty = 0;
      setState((){});
    });
  }

  //Builds the collapseable list views for The overview page. The overview page provides a link to the tests, loginfo, and Unit pages
  _buildExpandedContent(String passedTitle) {
    List<Widget> columnContent = [];
    if (passedTitle == "LogInfo") {
      columnContent.add(
          new ListTile(
            title: new Text(passedTitle),
          )
      );
    } else if (passedTitle == "Tests") {
      for (int i = 0; i < currentState.testList.length; i++) {
        columnContent.add(
            new ListTile(
              title: new Text(currentState.testList[i]),
            )
        );
      }
    } else {
      for (int i = 0; i < currentState.unitList.length; i++) {
        columnContent.add(
            new ListTile(
              title: new Text(currentState.unitList[i]),
            )
        );
      }
    }
    return columnContent;
  }
}
