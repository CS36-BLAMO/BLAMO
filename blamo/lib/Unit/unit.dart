import 'package:blamo/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:blamo/ObjectHandler.dart';
import 'package:blamo/SideMenu.dart';
import 'dart:convert';
import 'package:blamo/CustomActionBar.dart';

import 'package:fluttertoast/fluttertoast.dart';

//TORemove
/*
import 'package:intl/intl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:blamo/PDF/pdf_classes.dart';*/

class UnitPage extends StatefulWidget {
  final StateData pass; //Passes the StateData object to the stateful constructor

  UnitPage(this.pass);

  @override
  _UnitPageState createState() => new _UnitPageState(pass);
}

class _UnitPageState extends State<UnitPage> {
  final routeName = '/TestPage';
  StateData currentState;
  _UnitPageState(this.currentState);
  Unit unitObject;
  bool dirty;
  String tags;
  final myController = TextEditingController();
  var formNodes = new List<FocusNode>(3);

  @override
  void initState() {
    super.initState();
    for( var i = 0; i < 3; i++) {
      formNodes[i] = FocusNode();
    }
    dirty = true;
    updateUnitData(currentState.currentUnit, currentState.currentDocument);
  }

  @override
  void dispose () {
    for(var i = 0; i < 3; i++) {
      formNodes[i].dispose();
    }
    super.dispose();
  }


  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {

    String toTest1;
    String toTest2;
    //updateUnitData("Unit1", "Banana");
    if(currentState.currentRoute != null) {
      currentState.currentRoute = '/UnitPage'; //Assigns currentState.currentRoute to the name of the current named route
    }

    if(!dirty){
      debugPrint("After setState: (${unitObject.drillingMethods})");
      toTest1 = unitObject.drillingMethods;
      toTest2 = unitObject.tags;
      debugPrint("Returning scaffold $toTest1, $toTest2");
      return getScaffold(unitObject);
    } else {
      debugPrint("Returning empty Scaffold");
      return WillPopScope(
        onWillPop: backPressed,
        child: new Scaffold(
          appBar: CustomActionBar("Unit Page: ${currentState.currentUnit}").getAppBar(),
            backgroundColor: Colors.white,
            drawer: new Drawer(
                child: SideMenu(currentState)
            ),

            ),
      );
    }

  }
  //takes you back to units page with a pop up confirmation to not allow data loss
  Future<bool> backPressed() async {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text("Are you sure you want to leave this page? \n\n All unsaved data will be discarded."),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "No",
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
                onPressed: () => Navigator.pop(context,false),
              ),
              FlatButton(
                child: Text(
                    "Yes",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.red
                  ),
                ),
                onPressed: () => Navigator.pop(context,true),
              )
            ]
        )
    );
  }

  String formatValue(String value){
    if(value == "null"){
      return "";
    } else {
      return value;
    }
  }


  Widget getScaffold(Unit unitToBuildFrom){
    return WillPopScope(
      onWillPop: backPressed,
      child: Scaffold(
        backgroundColor: Colors.white,
        /*drawer: new Drawer(
            child: SideMenu(currentState)
        ),*/
        appBar: CustomActionBar("Unit Page: ${currentState.currentUnit}").getAppBar(),
        body: Padding(
            padding: EdgeInsets.fromLTRB(40,0,40,40),
            child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    FormBuilder(key: _fbKey,
                        initialValue: {
                          'date': DateTime.now(),
                          'accept_terms': false,
                        },
                        autovalidate: true,
                        child: Column(
                            children: <Widget>[
                              FormBuilderTextField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                focusNode: formNodes[0],
                                attribute: 'depth-ub',
                                validators: [FormBuilderValidators.numeric(), FormBuilderValidators.max(0)],
                                decoration: InputDecoration(labelText: "Depth Upper Bound (m)"),
                                initialValue: formatValue(unitToBuildFrom.depthUB.toString()),
                                onChanged: (void nbd){updateUnitObject();},
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[1]);
                                },
                                /*onEditingComplete: (){
                                debugPrint("Updating object");
                                unitObject.depthUB = double.parse(_fbKey.currentState.fields['depth-ub'].currentState.value);
                              },*/
                              ),
                              FormBuilderTextField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                focusNode: formNodes[1],
                                attribute: 'depth-lb',
                                validators: [FormBuilderValidators.numeric(), FormBuilderValidators.max(0), (lower){
                                  if(_fbKey.currentState != null && lower != null && _fbKey.currentState.fields['depth-ub'].currentState.value != null && double.tryParse(_fbKey.currentState.fields['depth-ub'].currentState.value) != null && double.tryParse(lower) != null && double.tryParse(lower) >= double.tryParse(_fbKey.currentState.fields['depth-ub'].currentState.value))
                                    return "Depth Lower Bound must be lower than Depth Upper Bound";
                                  return null;
                                }],//Custom validator that checks if lower bound is lower than upper bound
                                decoration: InputDecoration(labelText: "Depth Lower Bound (m)"),
                                initialValue: formatValue(unitToBuildFrom.depthLB.toString()),
                                onChanged: (void nbd){updateUnitObject();},
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[2]);
                                },
                                /*onEditingComplete: (){
                                debugPrint("Updating object");
                                unitObject.depthLB = double.parse(_fbKey.currentState.fields['depth-lb'].currentState.value);
                              },*/
                              ),
                              FormBuilderTextField(
                                textInputAction: TextInputAction.done,
                                focusNode: formNodes[2],
                                attribute: 'methods',
                                validators: [],
                                decoration: InputDecoration(labelText: "Drilling Methods"),
                                initialValue: formatValue(unitToBuildFrom.drillingMethods),
                                onChanged: (void nbd){updateUnitObject();},
                                /*onEditingComplete: (){
                                debugPrint("Updating object");
                                unitObject.drillingMethods = _fbKey.currentState.fields['methods'].currentState.value;
                              },*/
                              ),
                              FormBuilderCheckboxList( //TODO - redirect to longer comprehensive list of tags? Refactor to a list of autocompleting text fields? (SEE: test.dart, 56)
                                attribute: 'tags',
                                validators: [],
                                initialValue: getTags(unitToBuildFrom),
                                options: [ // TODO need gint's set of tags, ability for user to make own tags.
                                  FormBuilderFieldOption(value: "Asphalt"),
                                  FormBuilderFieldOption(value: "Basalt"),
                                  FormBuilderFieldOption(value: "Bedrock"),
                                  FormBuilderFieldOption(value: "Boulders and Cobbles"),
                                  FormBuilderFieldOption(value: "Breccia"),
                                  FormBuilderFieldOption(value: "USCS High Plasticity Clay"),
                                  FormBuilderFieldOption(value: "Chalk"),
                                  FormBuilderFieldOption(value: "USCS Low Plasticity Clay"),
                                  FormBuilderFieldOption(value: "USCS Low to High Plasticity Clay"),
                                  FormBuilderFieldOption(value: "USCS Low Plasticity Gavelly Clay"),
                                  FormBuilderFieldOption(value: "USCS Low Plasticity Silty Clay"),
                                  FormBuilderFieldOption(value: "USCS Low Plasticity Sandy Clay"),
                                  FormBuilderFieldOption(value: "Coal"),
                                  FormBuilderFieldOption(value: "Concrete"),
                                  FormBuilderFieldOption(value: "Coral"),
                                  FormBuilderFieldOption(value: "Fill"),
                                  FormBuilderFieldOption(value: "USCS Clayey Gravel"),
                                  FormBuilderFieldOption(value: "USCS Silty Gravel"),
                                  FormBuilderFieldOption(value: "USCS Poorly-graded Gravel"),
                                  FormBuilderFieldOption(value: "USCS Poorly-graded Gravel with clay"),
                                  FormBuilderFieldOption(value: "USCS Poorly-graded Gravel with silt"),
                                  FormBuilderFieldOption(value: "USCS Poorly-graded Sandy Gravel"),
                                  FormBuilderFieldOption(value: "USCS Well-graded Gravel"),
                                  FormBuilderFieldOption(value: "USCS Well-graded Gravel with Clay"),
                                  FormBuilderFieldOption(value: "USCS Well-graded Gravel with Silt"),
                                  FormBuilderFieldOption(value: "USCS Well-graded Sandy Gravel"),
                                  FormBuilderFieldOption(value: "Gypsum, rocksalt, etc."),
                                  FormBuilderFieldOption(value: "Limestone"),
                                  FormBuilderFieldOption(value: "USCS Elastic Silt"),
                                  FormBuilderFieldOption(value: "USCS Silt"),
                                  FormBuilderFieldOption(value: "USCS Gravely Silt"),
                                  FormBuilderFieldOption(value: "USCS Sandy Silt"),
                                  FormBuilderFieldOption(value: "USCS High Plasticity Organic silt or clay"),
                                  FormBuilderFieldOption(value: "USCS High Plasticity Organic silt or clay with shells"),
                                  FormBuilderFieldOption(value: "USCS Low Plasticity Organic silt or clay"),
                                  FormBuilderFieldOption(value: "USCS Low Plasticity Organic silt or clay with shells"),
                                  FormBuilderFieldOption(value: "USCS Peat"),
                                  FormBuilderFieldOption(value: "Sandstone"),
                                  FormBuilderFieldOption(value: "USCS Clayey Sand"),
                                  FormBuilderFieldOption(value: "USCS Clayey Sand with silt"),
                                  FormBuilderFieldOption(value: "Shale"),
                                  FormBuilderFieldOption(value: "Siltstone"),
                                  FormBuilderFieldOption(value: "USCS Silty Sand"),
                                  FormBuilderFieldOption(value: "USCS Poorly-graded Sand"),
                                  FormBuilderFieldOption(value: "USCS Poorly-graded Gravelly Sand"),
                                  FormBuilderFieldOption(value: "USCS Poorly-graded Sand with Clay"),
                                  FormBuilderFieldOption(value: "USCS Poorly-graded Sand with Silt"),
                                  FormBuilderFieldOption(value: "USCS Well-graded Sandy Gravel"),
                                  FormBuilderFieldOption(value: "USCS Well-graded Gravelly Sand"),
                                  FormBuilderFieldOption(value: "USCS Well-graded Sand with Clay"),
                                  FormBuilderFieldOption(value: "USCS Well-graded Sand with Silt"),
                                  FormBuilderFieldOption(value: "Glacial Till"),
                                  FormBuilderFieldOption(value: "Topsoil")
                                ],
                              )
                            ]
                          )
                        )
                      ]
                    )
                  )
                ),
            floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  if (_fbKey.currentState.saveAndValidate()) {
                    //print(_fbKey.currentState.value); // formbuilders have onEditingComplete property, could be worth looking into. Run it by client.
                    updateUnitObject();
                    await saveUnitObject();
                      currentState.currentRoute = '/UnitsPage';
                      _showToast("Success", Colors.green);
                      /*Navigator.pushReplacementNamed(
                        context,
                        "/UnitsPage",
                        arguments: currentState,
                      );*/
                      Navigator.pop(context, "Success");
                  } else {
                    _showToast("Error in Fields", Colors.red);
                  }

                },
                child: Icon(Icons.save),
            ),
      ),
    );
  }

  void _showToast(String toShow, MaterialColor color){
    Fluttertoast.showToast(
        msg: toShow,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  List<String> getTags(Unit unitObj) {
    List<String> toReturn = [];
    List<dynamic> ba = jsonDecode(unitObj.tags);
    if(ba != null) {
      for(int i = 0; i < ba.length; i++){
        toReturn.add(ba[i].toString());
      }
    }
    return toReturn;
  }

  void updateUnitObject(){
    if(double.tryParse(_fbKey.currentState.fields["depth-ub"].currentState.value) != null) {
      unitObject.depthUB = double.parse(_fbKey.currentState.fields["depth-ub"].currentState.value);
    } else {
      unitObject.depthUB = null;
    }
    if(double.tryParse(_fbKey.currentState.fields["depth-lb"].currentState.value) != null) {
      unitObject.depthLB = double.parse(_fbKey.currentState.fields["depth-lb"].currentState.value);
    } else {
      unitObject.depthLB = null;
    }
    unitObject.drillingMethods = _fbKey.currentState.fields['methods'].currentState.value.toString();
    unitObject.tags = jsonEncode(_fbKey.currentState.fields['tags'].currentState.value);
  }

  Future<void> saveUnitObject() async{
    ObjectHandler toHandle = new ObjectHandler();
    //TODO
    //unitObject.tags = ;

    try {
      await toHandle.saveUnitData(
          currentState.currentUnit, currentState.currentDocument, unitObject);
    } finally {
      debugPrint("Async calls done");
    }

    debugPrint("saving the unitObject: \nLB = ${unitObject.depthLB}\nUB = ${unitObject.depthUB}\nMethods = ${unitObject.drillingMethods}");
  }

//new
  /*void testSave() async {
    ObjectHandler toTest = new ObjectHandler();
    Unit testUnit = new Unit();
    Test testTest = new Test();
    LogInfo testLog = new LogInfo();


    //Building up the unitObj
    testUnit.beginUnitDepth = 14.11;
    testUnit.depthLB = 17.2;
    //testUnit.depthUB = 25.2;
    //testUnit.unitMethods = "unitMethods";
    testUnit.drillingMethods = "Drillingmethod";
    testUnit.tags = "nonPlastic,etc";


    //building up the testObj
    testTest.beginTest = 9.9;
    //testTest.endTest = 11.12;
    //testTest.soilType = "Dirt";
    testTest.moistureContent = "ITGOINRAIN";
    testTest.dryDensity = "itlikethesahara";
    testTest.liquidLimit = "Imuptomylimit";
    testTest.plasticLimit = "notallthatfake";
    testTest.fines ="Imsorryofficer";
    testTest.blows1="Yup";
    testTest.blows2="I think it does";
    testTest.blows3="Not that much";
    testTest.blowCount="25";
    testTest.tags = "nonPlastic Woop";

    //building up the loginfoObj
    testLog.northing="MaybeNorth";
    testLog.keyNo = 4.4;
    testLog.highway="i5";
    testLog.projectName="WAAAAA";
    testLog.startDate="tomorrow";
    testLog.endDate="Today";
    testLog.driller="george";
    testLog.projectGeologist="you";
    //testLog.recorder="me";
    //testLog.northing="north";
    testLog.easting= "east";
    testLog.highway="some data, revenge of the cloud storage";
    testLog.county="Taco tiger";
    testLog.purpose="Hot-a-dogu";
    testLog.equipment="Taco cat";
    testLog.objectID="Oop";
    testLog.testType="..,asdf";
    testLog.project="yeah its a. project";
    testLog.number="This ,,, Is some stuff";
    testLog.client="i r d k";
    testLog.lat="idk2";
    testLog.long="idk";
    testLog.location="Oregon";
    testLog.elevationDatum="Bae-rito";
    testLog.boreholeID="Boo-rito";
    testLog.surfaceElevation="Tacos";
    testLog.contractor="Animals";
    testLog.method="Dogs";
    testLog.loggedBy="Cats";
    testLog.checkedBy="Lammas";
    testLog.holeNo=7.22;
    testLog.eANo=6.8;
    //testLog.keyNo=4.4;
    testLog.startCardNo=2.2;
    testLog.groundElevation=45;
    testLog.tubeHeight=1;

    try{
      await toTest.saveUnitData("Unit1", "Banana", testUnit);
      await toTest.saveTestData("Test1", "Banana", testTest);
      await toTest.saveLogInfoData("Banana", testLog);
    } finally {
      debugPrint("Async calls done");
    }

    
    String retrievedUnit = await toTest.retrieveLocalUnit("Unit1", "Banana");
    String retrievedTest = await toTest.retrieveLocalTest("Test1","Banana");
    String retrievedLogInfo = await toTest.retrieveLocalLogInfo("Banana");

    debugPrint("retrievedUnit: " + retrievedUnit + "\n");
    debugPrint("retrievedTest: " + retrievedTest + "\n");
    debugPrint("retrievedLogInfo: " + retrievedLogInfo + "\n");

    Unit newUnitToBuild = await toTest.getUnitData("Unit1", "Banana");
    debugPrint("-----unitJSON Decoded-----\n"
        //+ "Begin Depth: ${newUnitToBuild.depthUB}\n"
        + "End Depth: ${newUnitToBuild.depthLB}\n"
        //+ "Method: ${newUnitToBuild.unitMethods}\n"
        + "Drilling: ${newUnitToBuild.drillingMethods}\n"
        + "Fill Tag: ${newUnitToBuild.tags}\n");
    
    Test newTestToBuild = await toTest.getTestData("Test1", "Banana");
    debugPrint("-----testJSON Decoded-----\n"
      + "beginTest: ${newTestToBuild.beginTest}\n"
      //+ "endTest: ${newTestToBuild.endTest}\n"
      //+ "soilType: ${newTestToBuild.soilType}\n"
      + "moistureContent: ${newTestToBuild.moistureContent}\n"
      + "dryDensity: ${newTestToBuild.dryDensity}\n"
      + "liquidLimit: ${newTestToBuild.liquidLimit}\n"
      + "plasticLimit: ${newTestToBuild.plasticLimit}\n"
      + "fines: ${newTestToBuild.fines}\n"
      + "blows1: ${newTestToBuild.blows1}\n"
      + "blows2: ${newTestToBuild.blows2}\n"
      + "blows3: ${newTestToBuild.blows3}\n"
      + "blowCount: ${newTestToBuild.blowCount}\n"
      + "tags: ${newTestToBuild.tags}\n"
    );
    
    LogInfo newLogInfoToBuild = await toTest.getLogInfoData("Banana");
    debugPrint("------logInfoJSON Decoded-----\n"
      + "projectName: ${newLogInfoToBuild.projectName}\n"
      + "startDate: ${newLogInfoToBuild.startDate}\n"
      + "endDate: ${newLogInfoToBuild.endDate}\n"
      + "driller: ${newLogInfoToBuild.driller}\n"
      + "projectGeologist: ${newLogInfoToBuild.projectGeologist}\n"
    //  + "recorder: ${newLogInfoToBuild.recorder}\n"
     // + "northing: ${newLogInfoToBuild.northing}\n"
      + "easting: ${newLogInfoToBuild.easting}\n"
      + "highway: ${newLogInfoToBuild.highway}\n"
      + "county: ${newLogInfoToBuild.county}\n"
      + "purpose: ${newLogInfoToBuild.purpose}\n"
      + "equipment: ${newLogInfoToBuild.equipment}\n"
      + "objectID: ${newLogInfoToBuild.objectID}\n"
      + "testType: ${newLogInfoToBuild.testType}\n"
      + "project: ${newLogInfoToBuild.project}\n"
      + "number: ${newLogInfoToBuild.number}\n"
      + "client: ${newLogInfoToBuild.client}\n"
      + "lat: ${newLogInfoToBuild.lat}\n"
      + "long: ${newLogInfoToBuild.long}\n"
      + "location: ${newLogInfoToBuild.location}\n"
      + "elevationDatum: ${newLogInfoToBuild.elevationDatum}\n"
      + "boreholeID: ${newLogInfoToBuild.boreholeID}\n"
      + "surfaceElevation: ${newLogInfoToBuild.surfaceElevation}\n"
      + "contractor: ${newLogInfoToBuild.contractor}\n"
      + "method: ${newLogInfoToBuild.method}\n"
      + "loggedBy: ${newLogInfoToBuild.loggedBy}\n"
      + "checkedBy: ${newLogInfoToBuild.checkedBy}\n"
      + "holeNo: ${newLogInfoToBuild.holeNo}\n"
      + "eANo: ${newLogInfoToBuild.eANo}\n"
     // + "keyNo: ${newLogInfoToBuild.keyNo}\n"
      + "startCardNo: ${newLogInfoToBuild.startCardNo}\n"
      + "groundElevation: ${newLogInfoToBuild.groundElevation}\n"
      + "tubeHeight: ${newLogInfoToBuild.tubeHeight}\n"
    );
    
  }*/

  void updateUnitData(String unitName, String documentName) async{
    ObjectHandler objectHandler = new ObjectHandler();
    await objectHandler.getUnitData(unitName, documentName).then((onValue){
      setState(() {
        unitObject = onValue;
        debugPrint("In set state: (${unitObject.drillingMethods})");
        dirty = false;
      });
    });
  }

}

