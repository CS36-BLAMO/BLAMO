import 'package:blamo/Boreholes/BoreholeList.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:blamo/ObjectHandler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:blamo/SideMenu.dart';
import 'package:blamo/CustomActionBar.dart';

class TestsPage extends StatefulWidget {
  final StateData pass; 

  TestsPage(this.pass, {Key key}) : super(key:key);
  @override
  _TestsPageState createState() => new _TestsPageState(pass);
}

class _TestsPageState extends State<TestsPage> {
  //TextEditingController _textFieldController = TextEditingController();
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

  //final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  Widget build(BuildContext context) {
    if(currentState.currentRoute != null) {
      currentState.currentRoute = '/TestsPage'; 
    }

    if(!dirty){
      //debugPrint("Returning scaffold $tests");
      purgeNulls();
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

  Future<void> createTest() async {

    //Create a test with the number of the last test that is in the testList and increment value by 1
    //Cannot rename or shuffle names after created.
    var nextTestNum;
    //debugPrint("Length of Test list: " + currentState.testList.length.toString());
    if (currentState.testList.length == 0) {
      debugPrint("Length of test is 0, creating test 1");
      nextTestNum = 1;
    } else {
      //debugPrint("Last Test in List: " + currentState.testList[currentState.testList.length - 1]); //Last item in list is - 1 index(Dart language req)
      var lastTestName = currentState.testList[currentState.testList.length - 1];
      var lastTestNum = lastTestName.substring(lastTestName.indexOf('_') + 1, lastTestName.length); //Takes string after _ in name to grab integer
      nextTestNum = int.parse(lastTestNum) + 1;
      //debugPrint("next unit num: " + nextTestNum.toString());
    }

    //int testNum = currentState.testList.length + 1;
    String newTest = "Test_" + nextTestNum.toString() + ',';
    String newTestNoComma = "Test_" + nextTestNum.toString();
    String test = "{testType:null,beginTest:null,endTest:null,percentRecovery:null,soilDrivingResistance:null,rockDiscontinuityData:null,rockQualityDesignation:null,moistureContent:null,dryDensity:null,liquidLimit:null,plasticLimit:null,fines:null,blows1:null,blows2:null,blows3:null,blowCount:null,tags:null}";
    String toWrite = '';
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

  FloatingActionButton floatingActionButtonBuilder(){
    return new FloatingActionButton.extended(
      label: Text("New Test"),
      icon: new Icon(Icons.add),
      tooltip: 'New Test Document',
      foregroundColor: Colors.black,
      backgroundColor: Colors.grey,
      elevation: 50.0,
      onPressed: createTest,
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
                      key: Key('test_' + (i+1).toString()),
                      onTap: () => _onTileClicked(i),
                      onLongPress: () => _onTileLongClicked(i),
                      splashColor: Colors.grey,
                      child: Center(child: Text(tests[i].beginTest.toString() + " - " + tests[i].endTest.toString())),
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
                key: Key('deleteTest'),
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

  Future<void> getTestSet(List<String> testNames, String documentName) async{
    debugPrint("In getTestSet");
    ObjectHandler objectHandler = new ObjectHandler(currentState.currentProject);
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

  Future<void> deleteTestAtIndex(int i) async{
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
  }

  Future<void> purgeNulls() async{
      for(int j = tests.length-1; j >= 0; j--){
        if (!(tests[j].beginTest is double) || !(tests[j].endTest is double)){
          deleteTestAtIndex(j);
          tests = [];
          getTestSet(currentState.testList, currentState.currentDocument);
        }
      }
  }
}
