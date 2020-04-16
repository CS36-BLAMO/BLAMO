import 'package:blamo/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:blamo/ObjectHandler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:blamo/SideMenu.dart';
import 'package:blamo/CustomActionBar.dart';

class TestsPage extends StatefulWidget {
  final StateData pass; 

  TestsPage(this.pass);
  @override
  _TestsPageState createState() => new _TestsPageState(pass);
}

class _TestsPageState extends State<TestsPage> {
  TextEditingController _textFieldController = TextEditingController();
  final routeName = '/TestPage';
  StateData currentState;
  _TestsPageState(this.currentState);
  List<Test> tests = [];
  bool dirty;

  @override
  void initState(){
    super.initState();
    dirty = true;
    getTestSet(currentState.testList, currentState.currentDocument);
  }

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  Widget build(BuildContext context) {
    if(currentState.currentRoute != null) {
      currentState.currentRoute = '/TestsPage'; 
    }

    if(!dirty){
      //debugPrint("Returning scaffold $tests");
      return getScaffold(tests);
    }
    else {
      if(currentState.dirty == 1){
        getTestSet(currentState.testList, currentState.currentDocument);
      }
      debugPrint("Returning empty scaffold");
      return WillPopScope(
        onWillPop: backPressed,
        child: new Scaffold(
            backgroundColor: Colors.white,
            drawer: new Drawer(
                child: SideMenu(currentState)
            ),
          appBar: CustomActionBar("Tests Page").getAppBar(),),
      );
    }
  }

  //takes you back to overview of current borehole
  Future<bool> backPressed() async {
    Navigator.pushReplacementNamed(
      context,
      "/Document",
      arguments: currentState,
    );
    return Future.value(false);
  }

  Widget getScaffold(List<Test> tests){
    return WillPopScope(
      onWillPop: backPressed,
      child: new Scaffold(
          backgroundColor: Colors.white,
          drawer: new Drawer(
          child: SideMenu(currentState),
        ),
        appBar: CustomActionBar("Tests Page").getAppBar(),
        body: Padding(
          padding: EdgeInsets.fromLTRB(20,20,20,20),
          child: ListView.builder(
            itemCount: 1,
            itemBuilder: (context,i){
              return new Column(
                children: _populateTestList()
              );
            }
          )
        ),
      floatingActionButton: floatingActionButtonBuilder(),
      ),
    );
  }

  createTest(){
    debugPrint("Create Test button pressed. Create test here"); // TODO
  }

  FloatingActionButton floatingActionButtonBuilder(){
    return new FloatingActionButton(
      child: Icon(Icons.add),
      tooltip: 'New Test Document',
      foregroundColor: Colors.black,
      backgroundColor: Colors.grey,
      elevation: 50.0,
      onPressed:(){
        showDialog(
          context: context,
          builder:(context) => AlertDialog(
              title: Text('Enter Test Name'),
              content: TextField(
                maxLength: 50,
                controller: _textFieldController,
                decoration: InputDecoration(labelText: 'Test Name'),
                inputFormatters: [new BlacklistingTextInputFormatter(new RegExp('[\\,]'))],
              ),
              actions: <Widget> [
                new FlatButton(
                  child: new Text('CANCEL'),
                  textColor: Colors.red,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                new FlatButton(
                  child: new Text('ACCEPT'),
                  onPressed: () async {
                    String newTest = _textFieldController.text + ',';
                    String newTestNoComma = _textFieldController.text;
                    String test = "{testType:null,beginTest:null,endTest:null,percentRecovery:null,soilDrivingResistance:null,rockDiscontinuityData:null,rockQualityDesignation:null,moistureContent:null,dryDensity:null,liquidLimit:null,plasticLimit:null,fines:null,blows1:null,blows2:null,blows3:null,blowCount:null,tags:null}";
                    String toWrite = '';
                    if(_textFieldController.text.isNotEmpty){
                      toWrite = "${currentState.currentDocument}\n${currentState.testList.length + 1}\n${currentState.unitList.length}\n";
                      for(int i = 0; i < currentState.testList.length; i++){
                        toWrite = toWrite + currentState.testList[i] + ',';
                      }
                      toWrite = toWrite + newTest;
                      for(int i = 0; i < currentState.unitList.length; i++){
                        toWrite = toWrite + currentState.unitList[i] + ',';
                      }
                      debugPrint(toWrite);

                      await currentState.storage.overWriteDocument(currentState.currentDocument, toWrite);
                      await currentState.storage.overWriteUnit(currentState.currentDocument,newTestNoComma, test);
                      currentState.testList.add(newTestNoComma);
                      currentState.currentTest = newTestNoComma;
                      currentState.currentRoute = '/TestPage';
                      Navigator.pop(context);

                      //Await for the test page to get popped
                      await Navigator.pushNamed(
                        context,
                        "/TestPage",
                        arguments: currentState,
                      );

                      //Update tests and reload page
                      tests = [];
                      await getTestSet(currentState.testList, currentState.currentDocument);
                      await new Future.delayed(new Duration(microseconds: 3)).then((onValue){
                        setState((){
                          currentState.dirty=0;
                          dirty = false;
                        });
                      });
                    }
                  },
                )
              ]
          ),
        );
      },
    );
  }

  List _populateTestList() {
    List<Widget> testsToReturn = [];
    for (int i = 0; i < tests.length; i++) {
        testsToReturn.add(
          new Container(
              height: 50,
              child: new Card(
                  elevation: 10,
                  color: Colors.brown[100],

                  child: new Material(
                    child: InkWell(
                      onTap: () => _onTileClicked(i),
                      onLongPress: () => _onTileLongClicked(i),
                      splashColor: Colors.grey,
                      child: Center(child: Text((i+1).toString() + "." + tests[i].beginTest.toString() + " - " + tests[i].endTest.toString())),
                    ),
                    color: Colors.transparent,
                  )
              )
          )
        );
      }
    return testsToReturn;
  }

  void _onTileClicked(int i) async {
    if(currentState.currentRoute != '/TestPage'){ // TODO - dynamically populate test edit page
      currentState.currentRoute = '/TestPage';
      currentState.currentTest=currentState.testList[i];
      await Navigator.pushNamed(
        context,
        "/TestPage",
        arguments: currentState,
      );
      tests = [];
      await getTestSet(currentState.testList, currentState.currentDocument);
      await new Future.delayed(new Duration(microseconds: 3)).then((onValue){
        setState((){
          currentState.dirty=0;
          dirty = false;
        });
      });
    } else {
      Navigator.pop(context);
    }
  }

  void _onTileLongClicked(int i) async {
    String result;
    result = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Are you sure you want to delete this test?"),
          actions: <Widget>[
            new FlatButton(
                child: Text("DELETE"),
                textColor: Colors.red,
                onPressed: () {
                  Navigator.pop(context, "DELETE");
                }),
            new FlatButton(
              child: Text("CANCEL"),
              onPressed: (){
                Navigator.pop(context, "CANCEL");
              },
            )
          ],
        )
    );
    if(result == "DELETE") {
      await currentState.storage.deleteTest(
          currentState.currentDocument, currentState.testList[i]);
      currentState.testList.removeAt(i);

      String toWrite = "${currentState.currentDocument}\n${currentState.testList
          .length}\n${currentState.unitList.length}\n";
      for (int i = 0; i < currentState.testList.length; i++) {
        toWrite = toWrite + currentState.testList[i] + ',';
      }
      for (int i = 0; i < currentState.unitList.length; i++) {
        toWrite = toWrite + currentState.unitList[i] + ',';
      }
      debugPrint(toWrite);

      await currentState.storage.overWriteDocument(
          currentState.currentDocument, toWrite);
      tests = [];
      await getTestSet(currentState.testList, currentState.currentDocument);
      await new Future.delayed(new Duration(microseconds: 3)).then((onValue) {
        setState(() {
          currentState.dirty = 0;
          dirty = false;
        });
      });
    }
  }

  void getTestSet(List<String> testNames, String documentName) async{
    debugPrint("In getTestSet");
    ObjectHandler objectHandler = new ObjectHandler();
    for(int i = 0; i < currentState.testList.length; i++){
      debugPrint("(getTestSet): Searching: ${currentState.currentDocument}");
      await objectHandler.getTestData(currentState.testList[i], currentState.currentDocument).then((onValue){
        setState((){
          tests.add(onValue);
          debugPrint("(getTestSet): ${currentState.testList[i]} added");
        });
      });
    }
    await new Future.delayed(new Duration(microseconds: 3)).then((onValue){
      setState((){
        currentState.dirty=0;
        dirty = false;
      });
    });
  }
}
