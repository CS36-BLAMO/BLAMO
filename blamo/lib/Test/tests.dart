import 'package:blamo/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:blamo/ObjectHandler.dart';
import 'package:intl/intl.dart';
import 'package:flutter_test/flutter_test.dart';

class TestsPage extends StatefulWidget {
  final StateData pass; 

  TestsPage(this.pass);
  @override
  _TestsPageState createState() => new _TestsPageState(pass);
}

class _TestsPageState extends State<TestsPage> {
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
      debugPrint("Returning scaffold $tests");
      return getScaffold(tests);
    }
    else {
      debugPrint("Returning empty scaffold");
      return new Scaffold();
    }
  }

  Widget getScaffold(List<Test> tests){
    return new Scaffold(
        backgroundColor: Colors.white,
        drawer: new Drawer(
        child: SideMenu(currentState),
      ),
        appBar: new AppBar(
            title: new Text("Tests Page"),
            actions: <Widget>[

            ],
            backgroundColor: Colors.deepOrange
      ),
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
    floatingActionButton: FloatingActionButton(
        onPressed: () {createTest();},
        child: Icon(Icons.create)
      ),
    );
  }

  createTest(){
    debugPrint("Create Test button pressed. Create test here"); // TODO
  }

  List _populateTestList() {
    List<Widget> testsToReturn = [];
    for (int i = 0; i < currentState.testList.length; i++) {
        testsToReturn.add(
            new ListTile(
              title: new Container(
                height: 50,
                color: Colors.orange[100],
                child: Center(child: Text(tests[i].beginTest.toString() + " - " + tests[i].endTest.toString() + ", " + tests[i].tags)),
              ),
              onTap: () {
                if(currentState.currentRoute != '/TestPage'){ // TODO - dynamically populate test edit page
                  currentState.currentRoute = '/TestPage';

                  currentState.currentTest=currentState.testList[i];
                  debugPrint("(Tests)Clicked on: " + currentState.testList[i] + "\n");

                  Navigator.pushReplacementNamed(
                    context,
                    "/TestPage",
                    arguments: currentState,
                  );
                } else {
                  Navigator.pop(context);
                }
              },
            )
        );
      }
    return testsToReturn;
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
    await new Future.delayed(new Duration(microseconds: 1)).then((onValue){
      setState((){
        dirty = false;
      });
    });
  }
}
