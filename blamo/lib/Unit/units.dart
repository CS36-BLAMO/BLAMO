import 'package:blamo/Boreholes/BoreholeList.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:blamo/ObjectHandler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:blamo/SideMenu.dart';
import 'package:blamo/CustomActionBar.dart';

//ToRemove
/*
import 'package:intl/intl.dart';
 */

class UnitsPage extends StatefulWidget {
  final StateData pass;

  UnitsPage(this.pass, {Key key}) : super(key:key);
  @override
  _UnitsPageState createState() => new _UnitsPageState(pass);
}

class _UnitsPageState extends State<UnitsPage> {
  //TextEditingController _textFieldController = TextEditingController();
  final routeName = '/UnitsPage';
  StateData currentState;
  _UnitsPageState(this.currentState);
  List<Unit> units = [];
  bool dirty;

  @override
  void initState(){
    super.initState();
    dirty = false;
    getUnitSet(currentState.unitList, currentState.currentDocument);
  }
  //final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  Widget build(BuildContext context) {
    if(currentState.currentRoute != null) {
      currentState.currentRoute = '/UnitsPage';
    }

    if(!dirty){
      debugPrint("Returning scaffold $units");
      purgeNulls();
      return getScaffold(units);
    }
    else {
      debugPrint("Returning empty Scaffold");
      return WillPopScope(
        onWillPop: backPressed,
        child: new Scaffold(
            appBar: CustomActionBar("Units Page").getAppBar(),
            drawer: new Drawer(
                child: SideMenu(currentState)
            ),
        ),
      );}
  }
  //@override
  Widget getScaffold(List<Unit> units){

    return WillPopScope(
      onWillPop: backPressed,
      child: new Scaffold(
          backgroundColor: Colors.white,
          drawer: new Drawer(
          child: SideMenu(currentState),
        ),
        appBar: CustomActionBar("Units Page").getAppBar(),
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
        floatingActionButton: floatingActionButtonBuilder(),
      ),
    );
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
  Future<void> createUnit() async {
    //Create a unit with the number of the last unit in unitList and increment by 1
    //Cannot rename or shuffle names after created.
    var nextUnitNum;
    //debugPrint("Length of Unit list: " + currentState.unitList.length.toString());
    if (currentState.unitList.length == 0) {
      nextUnitNum = 1;
    } else {
      //debugPrint("Last Unit in List: " + currentState.unitList[currentState.unitList.length - 1]); //Last item in list is - 1 index(Dart language req)
      var lastUnitName = currentState.unitList[currentState.unitList.length - 1];
      var lastUnitNum = lastUnitName.substring(lastUnitName.indexOf('_') + 1, lastUnitName.length); //Takes string after _ in name to grab integer
      nextUnitNum = int.parse(lastUnitNum) + 1;
      //debugPrint("next unit num: " + nextUnitNum.toString());
    }

    String newUnit ="Unit_" + nextUnitNum.toString() + ',';
    String newUnitNoComma = "Unit_" + nextUnitNum.toString();
    String unit = "{depthUB:null,depthLB:null,drillingMethods:null,notes:null,tags:null}";
    String toWrite = '';
    toWrite = "${currentState.currentDocument}\n${currentState.testList.length}\n${currentState.unitList.length + 1}\n";
    for(int i = 0; i < currentState.testList.length; i++){
      toWrite = toWrite + currentState.testList[i] + ',';
    }
    for(int i = 0; i < currentState.unitList.length; i++){
      toWrite = toWrite + currentState.unitList[i] + ',';
    }
    toWrite = toWrite + newUnit;
    debugPrint(toWrite);
    await currentState.storage.overWriteDocument(currentState.currentDocument, toWrite);
    await currentState.storage.overWriteUnit(currentState.currentDocument,newUnitNoComma, unit);
    currentState.unitList.add(newUnitNoComma);
    currentState.currentUnit = newUnitNoComma;
    currentState.currentRoute = '/UnitPage';

    //Await for the test page to get popped
    await Navigator.pushNamed(
      context,
      "/UnitPage",
      arguments: currentState,
    );
    units = [];
    await getUnitSet(currentState.unitList, currentState.currentDocument);
    await new Future.delayed(new Duration(microseconds: 3)).then((onValue){
      setState((){
        currentState.dirty=0;
        dirty = false;
      });
    });
  }

  FloatingActionButton floatingActionButtonBuilder(){
    return new FloatingActionButton.extended(
      label: Text("New Unit"),
      tooltip: 'New Unit',
      icon: new Icon(Icons.add),
      foregroundColor: Colors.black,
      backgroundColor: Colors.grey,
      elevation: 50.0,
      onPressed: createUnit,
    );
  }

  List _populateUnitList() {
    List<Widget> unitsToReturn = [];
    for (int i = 0; i < units.length; i++) {
      unitsToReturn.add(
          new Container(
              height: 50,
              child: new Card(
                  elevation: 10,
                  color: Colors.brown[100],

                  child: new Material(
                    child: InkWell(
                      key: Key('unit_' + (i+1).toString()),
                      onTap: () => _onTileClicked(i),
                      onLongPress: () => _onTileLongClicked(i),
                      splashColor: Colors.grey,
                      child: new Center(child: Text(units[i].depthUB.toString() + " - " + units[i].depthLB.toString())),
                    ),
                    color: Colors.transparent,
                  )
              )
          )
      );
    }
    return unitsToReturn;
  }

  void _onTileClicked(int i) async {
    currentState.currentUnit=currentState.unitList[i];
    debugPrint("(Units)Clicked on: " + currentState.unitList[i] + "\n");

    if(currentState.currentRoute != '/UnitPage'){ // TODO - dynamically populate unit edit page
      currentState.currentRoute = '/UnitPage';
      await Navigator.pushNamed(
        context,
        "/UnitPage",
        arguments: currentState,
      );
      units = [];
      await getUnitSet(currentState.unitList, currentState.currentDocument);
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
          title: Text("Are you sure you want to delete this unit?"),
          actions: <Widget>[
            new FlatButton(
                child: Text("DELETE"),
                key: Key('deleteUnit'),
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
      await currentState.storage.deleteUnit(
          currentState.currentDocument, currentState.unitList[i]);
      currentState.unitList.removeAt(i);

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
      units = [];
      await getUnitSet(currentState.unitList, currentState.currentDocument);
      await new Future.delayed(new Duration(microseconds: 3)).then((onValue) {
        setState(() {
          currentState.dirty = 0;
          dirty = false;
        });
      });
    }
  }

  Future<void> getUnitSet(List<String> unitNames, String documentName) async {
    for (int i = 0; i < currentState.unitList.length; i++) {
      ObjectHandler handler = new ObjectHandler(currentState.currentProject);
      await handler.getUnitsData(unitNames, documentName).then((onValue){
          setState(() {
            units = onValue;
            debugPrint("Units initialized.");
            dirty = false;
          });
      });
    }
  }

  Future<void> deleteUnitAtIndex(int i) async{
    await currentState.storage.deleteUnit(
        currentState.currentDocument, currentState.unitList[i]);
    currentState.unitList.removeAt(i);
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
      for(int j = units.length-1; j >= 0; j--){
        if (!(units[j].depthUB is double) || !(units[j].depthLB is double)){
          deleteUnitAtIndex(j);
          units = [];
          getUnitSet(currentState.unitList, currentState.currentDocument);
        }
      }
      
  }
}