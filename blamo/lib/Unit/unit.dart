import 'package:blamo/PDF/pdf_classes.dart';
import 'package:blamo/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:blamo/ObjectHandler.dart';

class UnitPage extends StatefulWidget {
  StateData pass; //Passes the StateData object to the stateful constructor

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

  @override
  void initState() {
    super.initState();
    dirty = true;
    updateUnitData("Unit12", "Banana");
  }

@override
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
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
      return new Scaffold();//getScaffold("","");
    }

  }

  Widget getScaffold(Unit unitToBuildFrom){
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: new Drawer(
          child: SideMenu(currentState)
      ),
      appBar: new AppBar(
          title: new Text("Unit Page"),
          actions: <Widget>[

          ],
          backgroundColor: Colors.deepOrange
      ),
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
                              attribute: 'depth-ub',
                              validators: [FormBuilderValidators.numeric()],
                              decoration: InputDecoration(labelText: "Depth Upper Bound (m)"),
                              initialValue: unitToBuildFrom.depthUB.toString(),
                            ),
                            FormBuilderTextField(
                              attribute: 'depth-lb',
                              validators: [FormBuilderValidators.numeric()],
                              decoration: InputDecoration(labelText: "Depth Lower Bound (m)"),
                              initialValue: unitToBuildFrom.depthLB.toString(),
                            ),
                            FormBuilderTextField(
                              attribute: 'methods',
                              validators: [],
                              decoration: InputDecoration(labelText: "Drilling Methods"),
                              initialValue: unitToBuildFrom.drillingMethods,
                            ),
                            FormBuilderCheckboxList( //TODO - redirect to longer comprehensive list of tags? Refactor to a list of autocompleting text fields? (SEE: test.dart, 56)
                              attribute: 'tags',
                              validators: [],
                              initialValue: [],
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
                ],
              ))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_fbKey.currentState.saveAndValidate()) {
            //print(_fbKey.currentState.value); // formbuilders have onEditingComplete property, could be worth looking into. Run it by client.

            //new
            //testSave();
          }
        },
        child: Icon(Icons.save),
      ),
    );
  }

//new
  void testSave() async {
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
    
  }

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

