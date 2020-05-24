import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:blamo/Boreholes/BoreholeList.dart';
import 'package:blamo/CustomActionBar.dart';
import 'package:blamo/ObjectHandler.dart';
import 'package:blamo/SideMenu.dart';

class TestPage extends StatefulWidget {
  final StateData pass; // Passes the StateData object to the stateful constructor

  TestPage(this.pass, {Key key}) : super(key:key);
  @override
  _TestPageState createState() => new _TestPageState(pass);
}

class _TestPageState extends State<TestPage> {
  final routeName = '/TestPage';
  StateData currentState;
  _TestPageState(this.currentState);
  bool dirty = true;
  Test testObject;
  String tags;
  var formNodes = new List<FocusNode>(16);

  @override
  void initState() {
    super.initState();
    for( var i = 0; i < 16; i++) {
      formNodes[i] = FocusNode();
    }
    dirty = true;
    updateTestData(currentState.currentTest, currentState.currentDocument);
  }

  @override
  void dispose () {
    for(var i = 0; i < 16; i++) {
      formNodes[i].dispose();
    }
    super.dispose();
  }

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    if(currentState.currentRoute != null) {
      currentState.currentRoute = '/TestPage'; // Assigns currentState.currentRoute to the name of the current named route
    }
    currentState.currentRoute = '/TestPage';

    if(!dirty){
      debugPrint("After setState: (${testObject.blows1})");
      return getTestScaffold(testObject);
    } else {
      debugPrint("Returning empty Scaffold");
      return WillPopScope(
        onWillPop: backPressed,
        child: new Scaffold(
            backgroundColor: Colors.white,
            drawer: new Drawer(
                child: SideMenu(currentState)
            ),
          appBar: CustomActionBar("Test Page: ${currentState.currentTest}").getAppBar(),),
      );//getScaffold("","");
    }

  }

  String formatValue(String value){
    if(value == "null"){
      return "";
    } else {
      return value;
    }
  }

  // takes you back to units page with pop up to protect data
  // from being lost without saving
  Future<bool> backPressed() async {
    if(_fbKey.currentState.validate()) {
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
    } else {
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
              title: Text("There are fields with invalid inputs\n\nTest will be deleted"),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    "Edit",
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context,false),
                ),
                FlatButton(
                  child: Text(
                    "Delete",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.red
                    ),
                  ),
                  onPressed: () => deleteBadTest(),
                )
              ]
          )
      );
    }
  }

  Widget getTestScaffold(Test testObjectToBuildFrom){
    return WillPopScope(
      onWillPop: backPressed,
      child: new Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomActionBar("Test Page: ${currentState.currentTest}").getAppBar(),
        body: Padding(
            padding: EdgeInsets.fromLTRB(40,0,40,40),
            child: SingleChildScrollView(
                key: Key('testScroll'),
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
                                key: Key('testTypeField'),
                                textInputAction: TextInputAction.next,
                                focusNode: formNodes[0],
                                attribute: 'testType',
                                validators: [],
                                maxLength: 100,
                                maxLengthEnforced: true,
                                decoration: InputDecoration(labelText: "Test Type, No.", counterText:""),
                                initialValue: formatValue(testObjectToBuildFrom.testType),
                                onChanged: (void nbd){updateTestObject();},
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[1]);
                                },
                              ),
                              FormBuilderTextField(
                                key: Key('beginTestField'),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                focusNode: formNodes[1],
                                attribute: 'beginTestDepth',
                                validators: [FormBuilderValidators.numeric(), FormBuilderValidators.max(0), FormBuilderValidators.required()],
                                maxLength: 15,
                                maxLengthEnforced: true,
                                decoration: InputDecoration(labelText: "Begin Test Depth (m)", counterText:""),
                                initialValue: formatValue(testObjectToBuildFrom.beginTest.toString()),
                                onChanged: (void nbd){updateTestObject();},
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[2]);
                                },
                              ),
                              FormBuilderTextField(
                                key: Key('endTestField'),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                focusNode: formNodes[2],
                                attribute: 'endTestDepth',
                                validators: [FormBuilderValidators.numeric(), FormBuilderValidators.max(0), FormBuilderValidators.required(), (endDepth){
                                  if(_fbKey.currentState != null && endDepth != null && _fbKey.currentState.fields["beginTestDepth"].currentState.value != null && double.tryParse(_fbKey.currentState.fields["beginTestDepth"].currentState.value) != null && double.tryParse(endDepth) != null && double.tryParse(endDepth) >= double.tryParse(_fbKey.currentState.fields["beginTestDepth"].currentState.value))
                                    return "End Depth must be lower than Begin Depth";
                                  return null;
                                }],//Custom validator that checks that end depth is lower than begin depth
                                maxLength: 15,
                                maxLengthEnforced: true,
                                decoration: InputDecoration(labelText: "End Test Depth (m)", counterText:""),
                                initialValue: formatValue(testObjectToBuildFrom.endTest.toString()),
                                onChanged: (void nbd){updateTestObject();},
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[3]);
                                },
                              ),
                              FormBuilderTextField(
                                key: Key('perRecField'),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                focusNode: formNodes[3],
                                attribute: 'percentRecovery',
                                validators: [FormBuilderValidators.numeric(), FormBuilderValidators.min(0), FormBuilderValidators.max(100)],
                                maxLength: 15,
                                maxLengthEnforced: true,
                                decoration: InputDecoration(labelText: "Percent Recovery", counterText:""),
                                initialValue: formatValue(testObjectToBuildFrom.percentRecovery.toString()),
                                onChanged: (void nbd){updateTestObject();},
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[4]);
                                },
                              ),
                              FormBuilderTextField(
                                key: Key('sdrField'),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                focusNode: formNodes[4],
                                attribute: 'soilDrivingResistance',
                                validators: [FormBuilderValidators.numeric()],
                                maxLength: 15,
                                maxLengthEnforced: true,
                                decoration: InputDecoration(labelText: "Soil Driving Resistance", counterText:""), //ASK - preferred title?
                                initialValue: formatValue(testObjectToBuildFrom.soilDrivingResistance),
                                onChanged: (void nbd){updateTestObject();},
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[5]);
                                },
                              ),
                              FormBuilderTextField(
                                key: Key('rddField'),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                focusNode: formNodes[5],
                                attribute: 'rockDiscontinuityData',
                                validators: [FormBuilderValidators.numeric()],
                                maxLength: 15,
                                maxLengthEnforced: true,
                                decoration: InputDecoration(labelText: "Rock Discontinuity Data", counterText:""), //ASK - preferred title?
                                initialValue: formatValue(testObjectToBuildFrom.rockDiscontinuityData),
                                onChanged: (void nbd){updateTestObject();},
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[6]);
                                },
                              ),
                              FormBuilderTextField(
                                key: Key('rqdField'),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                focusNode: formNodes[6],
                                attribute: 'rockQualityDesignation',
                                validators: [FormBuilderValidators.numeric()],
                                maxLength: 15,
                                maxLengthEnforced: true,
                                decoration: InputDecoration(labelText: "Rock Quality Designation", counterText:""), //ASK - preferred title?
                                initialValue: formatValue(testObjectToBuildFrom.rockQualityDesignation),
                                onChanged: (void nbd){updateTestObject();},
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[7]);
                                },
                              ),
                              FormBuilderTextField(
                                key: Key('mConField'),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                focusNode: formNodes[7],
                                attribute: 'moistureContent',
                                validators: [FormBuilderValidators.numeric()],
                                maxLength: 15,
                                maxLengthEnforced: true,
                                decoration: InputDecoration(labelText: "Moisture Content (%)", counterText:""),
                                initialValue: formatValue(testObjectToBuildFrom.moistureContent),
                                onChanged: (void nbd){updateTestObject();},
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[8]);
                                },
                              ),
                              FormBuilderTextField(
                                key: Key('dryDensityField'),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                focusNode: formNodes[8],
                                attribute: 'dryDensity',
                                validators: [FormBuilderValidators.numeric()],
                                maxLength: 15,
                                maxLengthEnforced: true,
                                decoration: InputDecoration(labelText: "Dry Density (pcf)", counterText:""),
                                initialValue: formatValue(testObjectToBuildFrom.dryDensity),
                                onChanged: (void nbd){updateTestObject();},
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[9]);
                                },
                              ),
                              FormBuilderTextField(
                                key: Key('liquidLimitField'),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                focusNode: formNodes[9],
                                attribute: 'liquidLimit',
                                validators: [FormBuilderValidators.numeric()],
                                maxLength: 15,
                                maxLengthEnforced: true,
                                decoration: InputDecoration(labelText: "Liquid Limit (%)", counterText:""),
                                initialValue: formatValue(testObjectToBuildFrom.liquidLimit),
                                onChanged: (void nbd){updateTestObject();},
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[10]);
                                },
                              ),
                              FormBuilderTextField(
                                key: Key('plasticLimitField'),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                focusNode: formNodes[10],
                                attribute: 'plasticLimit',
                                validators: [FormBuilderValidators.numeric()],
                                maxLength: 15,
                                maxLengthEnforced: true,
                                decoration: InputDecoration(labelText: "Plastic Limit (%)", counterText:""),
                                initialValue: formatValue(testObjectToBuildFrom.plasticLimit),
                                onChanged: (void nbd){updateTestObject();},
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[11]);
                                },
                              ),
                              FormBuilderTextField(
                                key: Key('finesField'),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                focusNode: formNodes[11],
                                attribute: 'fines',
                                validators: [FormBuilderValidators.numeric()],
                                maxLength: 15,
                                maxLengthEnforced: true,
                                decoration: InputDecoration(labelText: "Fines (%)", counterText:""),
                                initialValue: formatValue(testObjectToBuildFrom.fines),
                                onChanged: (void nbd){updateTestObject();},
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[12]);
                                },
                              ),
                              FormBuilderTextField(
                                key: Key('blows1Field'),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                focusNode: formNodes[12],
                                attribute: 'blows1',
                                validators: [FormBuilderValidators.numeric()],
                                maxLength: 15,
                                maxLengthEnforced: true,
                                decoration: InputDecoration(labelText: "Blows 1st", counterText:""),
                                initialValue: formatValue(testObjectToBuildFrom.blows1),
                                onChanged: (void nbd){updateTestObject();},
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[13]);
                                },
                              ),
                              FormBuilderTextField(
                                key: Key('blows2Field'),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                focusNode: formNodes[13],
                                attribute: 'blows2',
                                validators: [FormBuilderValidators.numeric()],
                                maxLength: 15,
                                maxLengthEnforced: true,
                                decoration: InputDecoration(labelText: "Blows 2nd", counterText:""),
                                initialValue: formatValue(testObjectToBuildFrom.blows2),
                                onChanged: (void nbd){updateTestObject();},
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[14]);
                                },
                              ),
                              FormBuilderTextField(
                                key: Key('blows3Field'),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                focusNode: formNodes[14],
                                attribute: 'blows3',
                                validators: [FormBuilderValidators.numeric()],
                                maxLength: 15,
                                maxLengthEnforced: true,
                                decoration: InputDecoration(labelText: "Blows 3rd", counterText:""),
                                initialValue: formatValue(testObjectToBuildFrom.blows3),
                                onChanged: (void nbd){updateTestObject();},
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[15]);
                                },
                              ),
                              FormBuilderTextField(
                                key: Key('blowCountField'),
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.number,
                                focusNode: formNodes[15],
                                attribute: 'blowCount',
                                validators: [FormBuilderValidators.numeric()],
                                maxLength: 15,
                                maxLengthEnforced: true,
                                decoration: InputDecoration(labelText: "Blow Count", counterText:""),
                                initialValue: formatValue(testObjectToBuildFrom.blowCount),
                                onChanged: (void nbd){updateTestObject();},
                              ),
                              FormBuilderCheckboxList(
                                attribute: 'description',
                                validators: [],
                                decoration: InputDecoration(labelText: "Description"),
                                initialValue: getTags(testObjectToBuildFrom),
                                options: [
                                  FormBuilderFieldOption(value: "Asphalt", key: Key('testAsphaltTag'),),
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
                                onChanged: (void nbd){getTags(testObjectToBuildFrom);},
                              ),
                            ]
                        )
                    )
                  ],
                ))),
        floatingActionButton: FloatingActionButton(
          key: Key('saveTest'),
          onPressed: () async {
            if (_fbKey.currentState.saveAndValidate()) {
              updateTestObject();
              bool noOverlap = await checkTestDepthOverlap();
              if(noOverlap) {
                await saveTestObject();
                currentState.currentRoute = '/TestsPage';
                _showToast("Success", Colors.green);
                Navigator.pop(context, "Success");
              } else {
                _showToast("Test overlaps another Test", Colors.red);
              }
            } else {
              _showToast("Error in Fields", Colors.red);
            }
          },
          child: Icon(Icons.save),
        ),
      ),
    );
  }

  // This function is called on save, checks that this test does not overlap with other tests
  Future<bool> checkTestDepthOverlap() async {
    ObjectHandler objectHandler = new ObjectHandler(currentState.currentProject);
    for(int i = 0; i < currentState.testList.length; i++){
      Test currentCheck = await objectHandler.getTestData(currentState.testList[i], currentState.currentDocument);
      if (currentState.currentTest != currentState.testList[i]) {
        try{
          if(testObject.beginTest < currentCheck.beginTest && testObject.beginTest > currentCheck.endTest) {
            return false;
          } else if(testObject.endTest < currentCheck.beginTest && testObject.endTest > currentCheck.endTest) {
            return false;
          } else if (testObject.beginTest == currentCheck.beginTest || testObject.endTest == currentCheck.endTest) {
            return false;
          } else if (currentCheck.beginTest < testObject.beginTest && currentCheck.beginTest > testObject.endTest) {
            return false;
          } else if (currentCheck.endTest < testObject.beginTest && currentCheck.endTest > testObject.endTest) {
            return false;
          }
        }catch(NoSuchMethodError){
          continue;
        }
      }
    }
    return true;
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

  // This function formats the soil description tags
  List<String> getTags(Test testObj) {
    List<String> toReturn = [];
    List<dynamic> ba;
    if(testObj.tags != null){
      ba = jsonDecode(testObj.tags);
    }
    if(ba != null) {
      for (int i = 0; i < ba.length; i++) {
        toReturn.add(ba[i].toString());
      }
    }
    return toReturn;
  }

  void updateTestObject(){
    testObject.testType = _fbKey.currentState.fields["testType"].currentState.value.toString();
    if(double.tryParse(_fbKey.currentState.fields["beginTestDepth"].currentState.value) != null) {
      testObject.beginTest = double.parse(_fbKey.currentState.fields["beginTestDepth"].currentState.value);
    } else {
      testObject.beginTest = null;
    }
    if(double.tryParse(_fbKey.currentState.fields["endTestDepth"].currentState.value) != null) {
      testObject.endTest = double.parse(_fbKey.currentState.fields["endTestDepth"].currentState.value);
    } else {
      testObject.endTest = null;
    }
    if(double.tryParse(_fbKey.currentState.fields["percentRecovery"].currentState.value) != null) {
      testObject.percentRecovery = double.parse(_fbKey.currentState.fields["percentRecovery"].currentState.value);
    } else {
      testObject.percentRecovery = null;
    }
    testObject.soilDrivingResistance = _fbKey.currentState.fields["soilDrivingResistance"].currentState.value.toString();
    testObject.rockDiscontinuityData = _fbKey.currentState.fields["rockDiscontinuityData"].currentState.value.toString();
    testObject.rockQualityDesignation = _fbKey.currentState.fields["rockQualityDesignation"].currentState.value.toString();
    testObject.moistureContent = _fbKey.currentState.fields["moistureContent"].currentState.value.toString();
    testObject.dryDensity = _fbKey.currentState.fields["dryDensity"].currentState.value.toString();
    testObject.liquidLimit = _fbKey.currentState.fields["liquidLimit"].currentState.value.toString();
    testObject.plasticLimit = _fbKey.currentState.fields["plasticLimit"].currentState.value.toString();
    testObject.fines = _fbKey.currentState.fields["fines"].currentState.value.toString();
    testObject.blows1 = _fbKey.currentState.fields["blows1"].currentState.value.toString();
    testObject.blows2 = _fbKey.currentState.fields["blows2"].currentState.value.toString();
    testObject.blows3 = _fbKey.currentState.fields["blows3"].currentState.value.toString();
    testObject.blowCount = _fbKey.currentState.fields["blowCount"].currentState.value.toString();
    testObject.tags = jsonEncode(_fbKey.currentState.fields['description'].currentState.value);
  }

  Future<void> saveTestObject() async{
    ObjectHandler toHandle = new ObjectHandler(currentState.currentProject);
    try {
      toHandle.saveTestData(
          currentState.currentTest, currentState.currentDocument, testObject);
    } finally {
      debugPrint("Async calls done");
    }
  }

  void updateTestData(String testName, String documentName) async{
    ObjectHandler objectHandler = new ObjectHandler(currentState.currentProject);
    await objectHandler.getTestData(testName, documentName).then((onValue){
      setState(() {
        testObject = onValue;
        debugPrint("In set state: (${testObject.blowCount})");
        dirty = false;
      });
    });
  }

  // If a user wants to leave a test that has errors in the fields they can choose to delete that test
  void deleteBadTest() async {
    await currentState.storage.deleteTest(
        currentState.currentDocument, currentState.currentTest);
    currentState.testList.remove(currentState.currentTest);

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
    Navigator.pop(context,true);
  }
}
