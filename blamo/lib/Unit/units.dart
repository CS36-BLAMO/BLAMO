import 'package:blamo/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:blamo/ObjectHandler.dart';
import 'package:flutter_test/flutter_test.dart';

//ToRemove
/*
import 'package:intl/intl.dart';
 */

class UnitsPage extends StatefulWidget {
  final StateData pass; 

  UnitsPage(this.pass);
  @override
  _UnitsPageState createState() => new _UnitsPageState(pass);
}

class _UnitsPageState extends State<UnitsPage> {
  final routeName = '/UnitsPage';
  StateData currentState;
  _UnitsPageState(this.currentState);
  List<Unit> units = [];
  bool dirty;

  @override
  void initState(){
    super.initState();
    dirty = true;
    getUnitSet(currentState.unitList, currentState.currentDocument);
  }
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  Widget build(BuildContext context) {
    if(currentState.currentRoute != null) {
      currentState.currentRoute = '/UnitsPage';
    }

    if(!dirty){
      debugPrint("Returning scaffold $units");
      return getScaffold(units);
    } 
    else {
      debugPrint("Returning empty Scaffold");
      return new Scaffold();//getScaffold("","");
    }
  }
  //@override
Widget getScaffold(List<Unit> units){

    return new Scaffold(
        backgroundColor: Colors.white,
        drawer: new Drawer(
        child: SideMenu(currentState),
      ),
        appBar: new AppBar(
            title: new Text("Units Page"),
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
              children: _populateUnitList()
            );
          }
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {createUnit();},
        child: Icon(Icons.create)
      ),
    );
  }

  createUnit(){
    debugPrint("Create Unit button hit. Create unit here."); // TODO
  }

  List _populateUnitList() {
    List<Widget> unitsToReturn = [];
    for (int i = 0; i < currentState.unitList.length; i++) {
        unitsToReturn.add(
            new ListTile(
              title: new Container(
                height: 50,
                color: Colors.brown[100],
                child: Center(child: Text(units[i].depthUB.toString() + " - " + units[i].depthLB.toString() + ", " + units[i].drillingMethods)),
              ),
              onTap: () {
                //testBuiildingList();

                currentState.currentUnit=currentState.unitList[i];
                debugPrint("(Units)Clicked on: " + currentState.unitList[i] + "\n");

                if(currentState.currentRoute != '/UnitPage'){ // TODO - dynamically populate unit edit page
                  currentState.currentRoute = '/UnitPage';
                  Navigator.pushReplacementNamed(
                    context,
                    "/UnitPage",
                    arguments: currentState,
                  );
                } else {
                  Navigator.pop(context);
                }
              },
            )
        );
      }
    return unitsToReturn;
  }

void testBuiildingList() async {
    List<Unit> units = [];
    ObjectHandler objectHandler = new ObjectHandler();

    for(int i = 0; i < currentState.unitList.length; i++){
      debugPrint("Would have tried searching: ${currentState.currentDocument}_${currentState.unitList[i]}.txt");
      Unit unit = await objectHandler.getUnitData(currentState.unitList[i], currentState.currentDocument);
      units.add(unit);
    }

    for(int i = 0; i < currentState.unitList.length; i++){
      debugPrint("${units[i].runtimeType}");
      debugPrint("${units[i].drillingMethods}");
    }

}

void getUnitSet(List<String> unitNames, String documentName) async{
  ObjectHandler objectHandler = new ObjectHandler();
  for(int i = 0; i < currentState.unitList.length; i++){
    debugPrint("(getUnitSet): Searching: ${currentState.currentDocument}_${currentState.unitList[i]}.txt");
    await objectHandler.getUnitData(currentState.unitList[i], currentState.currentDocument).then((onValue){
      setState((){
        units.add(onValue);
        debugPrint("(getUnitSet): ${currentState.unitList[i]} added");
      });
    });
  }
  await new Future.delayed(new Duration(microseconds: 1)).then((onValue){
    setState((){
      dirty = false;
    });
  });
  //ObjectHandler handler = new ObjectHandler();
  //await handler.getUnitsData(unitNames, documentName).then((onValue){
  //    setState(() {
  //      units = onValue;
  //      debugPrint("Units initialized.");
  //      dirty = false;
  //    });
  //});
}

}