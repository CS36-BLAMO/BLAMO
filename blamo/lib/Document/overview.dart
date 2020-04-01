import 'package:blamo/main.dart';
import 'package:flutter/material.dart';
import 'package:blamo/File_IO/FileHandler.dart';
import 'package:blamo/SideMenu.dart';
import 'package:blamo/CustomActionBar.dart';

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

      appBar: CustomActionBar("Overview: ${currentState.currentDocument}").getAppBar(),

      body:ListView.builder(
        itemCount: 3,
        itemBuilder: (context, i){
          String title;
          switch(i){
            case 0:
              title = "LogInfo";
              return  new Container(
                        height: 50,
                        child: new Card(
                            elevation: 3,
                            borderOnForeground: true,
                            color: Colors.brown[100],
                            child: new Material(
                              child: InkWell(
                                //onTap: () => _onTileClicked(i),
                                splashColor: Colors.grey,
                                child: new Center(child: Text("Log Info")),
                              ),
                              color: Colors.transparent,
                            )
                        )
              );
              break;
            case 1:
              title = "Tests";
              break;
            case 2:
              title = "Units";
              break;
          }
          return
            new Container(
              child: new Card(
              elevation: 5,
              color: Colors.brown[100],
              child:new ExpansionTile(
                  title: new Text(title),
                  children: <Widget>[
                    new Column(
                      children: _buildExpandedContent(title),
                    )
                  ],
                )
              )
          );
        },
      ),
    );
  }

  //--DEBUG
  /*void createFudgedData() async{
    String a, b, c, test, unit, log;
    a = "Banana";
    b = "Strawberry";
    c = "Smoothie";
    test = "{beginTest:null,endTest:null,soilType:null,moistureContent:null,dryDensity:null,liquidLimit:null,plasticLimit:null,fines:null,blows1:null,blows2:null,blows3:null,blowCount:null,tags:null}";
    unit = "{depthUB:null,depthLB:null,beginUnitDepth:null,unitMethods:null,drillingMethods:null,tags:null}";
    log = "{projectName:null,startDate:null",endDate:null,driller:null,projectGeologist:null,recorder:null,northing:null,easting:null,highway:null,county:null,purpose:null,equipment:null,objectID:null,testType:null,project:null,number:null,client:null,lat:null,long:null,location:null,elevationDatum:null,boreholeID:null,surfaceElevation:null,contractor:null,method:null,loggedBy:null,checkedBy:null,holeNo:null,eANo:null,keyNo:null,startCardNo:null,groundElevation:null,tubeHeight:null}";

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
  }*/

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
    int testBound = 0;
    int unitBound = 0;

    if(testBound > 10){
      testBound = currentState.testList.length - 10;
    }

    if(unitBound > 10){
      unitBound = currentState.unitList.length - 10;
    }

    List<Widget> columnContent = [];
    if (passedTitle == "LogInfo") {
      columnContent.add(
          new ListTile(
            title: new Text(passedTitle),
          )
      );
    } else if (passedTitle == "Tests") {
      for (int i = currentState.testList.length - 1; i >= testBound; i--) {
        columnContent.add(
            new Container(
                height: 50,
                child: new Card(
                    elevation: 3,
                    borderOnForeground: true,
                    color: Colors.brown[100],
                    child: new Material(
                      child: InkWell(
                        //onTap: () => _onTileClicked(i),
                        splashColor: Colors.grey,
                        child: new Center(child: Text(currentState.testList[i])),
                      ),
                      color: Colors.transparent,
                    )
                )
            )
        );
      }
    } else {
      for (int i = currentState.unitList.length - 1; i >= unitBound; i--) {
        columnContent.add(
            new Container(
                height: 50,
                child: new Card(
                    elevation: 3,
                    color: Colors.brown[100],
                    child: new Material(
                      child: InkWell(
                        //onTap: () => _onTileClicked(i),
                        splashColor: Colors.grey,
                        child: new Center(child: Text(currentState.unitList[i])),
                      ),
                      color: Colors.transparent,
                    )
                )
            )
        );
      }
    }
    return columnContent;
  }
}
