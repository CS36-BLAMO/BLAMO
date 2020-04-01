import 'package:blamo/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
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

  UnitsPage(this.pass);
  @override
  _UnitsPageState createState() => new _UnitsPageState(pass);
}

class _UnitsPageState extends State<UnitsPage> {
  TextEditingController _textFieldController = TextEditingController();
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
      //debugPrint("Returning scaffold $units");
      return getScaffold(units);
    } 
    else {
      debugPrint("Returning empty Scaffold");
      return new Scaffold(
          appBar: CustomActionBar("Units Page").getAppBar(),
          drawer: new Drawer(
              child: SideMenu(currentState)
          ),

      );}
  }
  //@override
Widget getScaffold(List<Unit> units){

    return new Scaffold(
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
    );
  }

  createUnit(){
    debugPrint("Create Unit button hit. Create unit here."); // TODO
  }

  FloatingActionButton floatingActionButtonBuilder(){
    return new FloatingActionButton(
      child: Icon(Icons.add),
      tooltip: 'New Unit Document',
      foregroundColor: Colors.black,
      backgroundColor: Colors.grey,
      elevation: 50.0,
      onPressed:(){
        showDialog(
          context: context,
          builder:(context) => AlertDialog(
              title: Text('Enter Unit Name'),
              content: TextField(
                maxLength: 50,
                controller: _textFieldController,
                decoration: InputDecoration(labelText: 'Unit Name'),
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
                    String newUnit = _textFieldController.text + ',';
                    String newUnitNoComma = _textFieldController.text;
                    String unit = "{depthUB:null,depthLB:null,beginUnitDepth:null,unitMethods:null,drillingMethods:null,tags:null}";
                    String toWrite = '';
                    if(_textFieldController.text.isNotEmpty){
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
                        Navigator.pop(context);
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
                  },
                )
              ]
          ),
        );
      },
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