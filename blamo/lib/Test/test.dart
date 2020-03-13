import 'package:blamo/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:blamo/ObjectHandler.dart';
import 'package:blamo/SideMenu.dart';
import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';

//TORemove
/*
import 'package:intl/intl.dart';
import 'package:flutter_test/flutter_test.dart';*/

class TestPage extends StatefulWidget {
  final StateData pass; //Passes the StateData object to the stateful constructor

  TestPage(this.pass);
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

  @override
  void initState() {
    super.initState();
    dirty = true;
    updateTestData(currentState.currentTest, currentState.currentDocument);
  }

  @override
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  Widget build(BuildContext context) {
    if(currentState.currentRoute != null) {
      currentState.currentRoute = '/TestPage'; //Assigns currentState.currentRoute to the name of the current named route
    }
    currentState.currentRoute = '/TestPage';

    if(!dirty){
      debugPrint("After setState: (${testObject.blows1})");
      //debugPrint("Returning scaffold $toTest1, $toTest2");
      return getTestScaffold(testObject);
    } else {
      debugPrint("Returning empty Scaffold");
      return new Scaffold(
          backgroundColor: Colors.white,
          drawer: new Drawer(
              child: SideMenu(currentState)
          ),
          appBar: new AppBar(
              title: new Text("Test Page: " + currentState.currentDocument + "/" + currentState.currentTest),
              actions: <Widget>[

              ],
              backgroundColor: Colors.deepOrange
          ));//getScaffold("","");
    }

  }

  String formatValue(String value){
    if(value == "null"){
      return "";
    } else {
      return value;
    }
  }

  Widget getTestScaffold(Test testObjectToBuildFrom){
    return new Scaffold(
      backgroundColor: Colors.white,
      drawer: new Drawer(
        child: SideMenu(currentState),
      ),
      appBar: new AppBar(
          title: new Text("Test Page: " + currentState.currentDocument + "/" + currentState.currentTest),
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
                              attribute: 'beginTestDepth',
                              validators: [FormBuilderValidators.numeric()],
                              decoration: InputDecoration(labelText: "Begin Test Depth (m)"),
                              initialValue: formatValue(testObjectToBuildFrom.beginTest.toString()),
                              onChanged: (void nbd){updateTestObject();},
                              ),
                            FormBuilderTextField(
                              attribute: 'endTestDepth',
                              validators: [FormBuilderValidators.numeric()],
                              decoration: InputDecoration(labelText: "End Test Depth (m)"),
                              initialValue: formatValue(testObjectToBuildFrom.endTest.toString()),
                              onChanged: (void nbd){updateTestObject();},
                            ),
                            FormBuilderTextField(
                              attribute: 'soilType',
                              validators: [],
                              decoration: InputDecoration(labelText: "Soil Type"), //ASK - preferred title?
                              initialValue: formatValue(testObjectToBuildFrom.soilType),
                              onChanged: (void nbd){testObject.soilType = _fbKey.currentState.fields["soilType"].currentState.value;},
                            ),

                            FormBuilderCheckboxList( //TODO - redirect to longer comprehensive list of tags? Refactor to a list of autocompleting text fields? (SEE: unit.dart, 51)
                              attribute: 'description',
                              validators: [],
                              decoration: InputDecoration(labelText: "Description"),
                              initialValue: getTags(testObjectToBuildFrom),
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
                              onChanged: (void nbd){getTags(testObjectToBuildFrom);},
                            ),
                            FormBuilderTextField(
                              attribute: 'moistureContent',
                              validators: [FormBuilderValidators.numeric()],
                              decoration: InputDecoration(labelText: "Moisture Content (%)"),
                              initialValue: formatValue(testObjectToBuildFrom.moistureContent),
                              onChanged: (void nbd){updateTestObject();},
                            ),
                            FormBuilderTextField(
                              attribute: 'dryDensity',
                              validators: [],
                              decoration: InputDecoration(labelText: "Dry Density (pcf)"),
                              initialValue: formatValue(testObjectToBuildFrom.dryDensity),
                              onChanged: (void nbd){testObject.dryDensity = _fbKey.currentState.fields["dryDensity"].currentState.value;},
                            ),
                            FormBuilderTextField(
                              attribute: 'liquidLimit',
                              validators: [FormBuilderValidators.numeric()],
                              decoration: InputDecoration(labelText: "Liquid Limit (%)"),
                              initialValue: formatValue(testObjectToBuildFrom.liquidLimit),
                              onChanged: (void nbd){testObject.liquidLimit = _fbKey.currentState.fields["liquidLimit"].currentState.value;},
                            ),
                            FormBuilderTextField(
                              attribute: 'plasticLimit',
                              validators: [FormBuilderValidators.numeric()],
                              decoration: InputDecoration(labelText: "Plastic Limit (%)"),
                              initialValue: formatValue(testObjectToBuildFrom.plasticLimit),
                              onChanged: (void nbd){testObject.plasticLimit = _fbKey.currentState.fields["plasticLimit"].currentState.value;},
                            ),
                            FormBuilderTextField(
                              attribute: 'fines',
                              validators: [FormBuilderValidators.numeric()],
                              decoration: InputDecoration(labelText: "Fines (%)"),
                              initialValue: formatValue(testObjectToBuildFrom.fines),
                              onChanged: (void nbd){testObject.fines = _fbKey.currentState.fields["fines"].currentState.value;},
                            ),
                            FormBuilderTextField(
                              attribute: 'blows1',
                              validators: [FormBuilderValidators.numeric()],
                              decoration: InputDecoration(labelText: "Blows 1st"),
                              initialValue: formatValue(testObjectToBuildFrom.blows1),
                              onChanged: (void nbd){testObject.blows1 = _fbKey.currentState.fields["blows1"].currentState.value;},
                            ),
                            FormBuilderTextField(
                              attribute: 'blows2',
                              validators: [FormBuilderValidators.numeric()],
                              decoration: InputDecoration(labelText: "Blows 2nd"),
                              initialValue: formatValue(testObjectToBuildFrom.blows2),
                              onChanged: (void nbd){testObject.blows2 = _fbKey.currentState.fields["blows2"].currentState.value;},
                            ),
                            FormBuilderTextField(
                              attribute: 'blows3',
                              validators: [FormBuilderValidators.numeric()],
                              decoration: InputDecoration(labelText: "Blows 3rd"),
                              initialValue: formatValue(testObjectToBuildFrom.blows3),
                              onChanged: (void nbd){testObject.blows3 = _fbKey.currentState.fields["blows3"].currentState.value;},
                            ),
                            FormBuilderTextField(
                              attribute: 'blowCount',
                              validators: [FormBuilderValidators.numeric()],
                              decoration: InputDecoration(labelText: "Blow Count"),
                              initialValue: formatValue(testObjectToBuildFrom.blowCount),
                              onChanged: (void nbd){testObject.blowCount = _fbKey.currentState.fields["blowCount"].currentState.value;},
                            ),

                ]
                )
              )
            ],
          ))),
          floatingActionButton: FloatingActionButton(
              onPressed: () async {
                if (_fbKey.currentState.saveAndValidate()) {
                  updateTestObject();
                  await saveTestObject();
                  currentState.currentRoute = '/TestsPage';
                  _showToast("Success", Colors.green);
                  Navigator.pushReplacementNamed(
                    context,
                    "/TestsPage",
                    arguments: currentState,
                  );
                } else {
                  _showToast("Error in Fields", Colors.red);
                }
              },
              child: Icon(Icons.save),
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

  List<String> getTags(Test testObj) {
    List<String> toReturn = [];
    List<dynamic> ba = jsonDecode(testObj.tags);
    if(ba != null) {
      for (int i = 0; i < ba.length; i++) {
        toReturn.add(ba[i].toString());
      }
    }
    return toReturn;
  }

  void updateTestObject(){
    try{
      testObject.beginTest = double.parse(_fbKey.currentState.fields["beginTestDepth"].currentState.value);
    } catch(e) {
    }
    try{
      testObject.endTest = double.parse(_fbKey.currentState.fields["endTestDepth"].currentState.value);
    } catch(e) {
    }

    testObject.dryDensity = _fbKey.currentState.fields["dryDensity"].currentState.value.toString();
    testObject.liquidLimit = _fbKey.currentState.fields["liquidLimit"].currentState.value.toString();
    testObject.moistureContent = _fbKey.currentState.fields["moistureContent"].currentState.value.toString();
    testObject.plasticLimit = _fbKey.currentState.fields["plasticLimit"].currentState.value.toString();
    testObject.soilType = _fbKey.currentState.fields["soilType"].currentState.value.toString();
    testObject.blowCount = _fbKey.currentState.fields["blowCount"].currentState.value.toString();
    testObject.blows1 = _fbKey.currentState.fields["blows1"].currentState.value.toString();
    testObject.blows2 = _fbKey.currentState.fields["blows2"].currentState.value.toString();
    testObject.blows3 = _fbKey.currentState.fields["blows3"].currentState.value.toString();
    testObject.fines = _fbKey.currentState.fields["fines"].currentState.value.toString();
    testObject.tags = jsonEncode(_fbKey.currentState.fields['description'].currentState.value);

  }

  void saveTestObject() async{
    ObjectHandler toHandle = new ObjectHandler();
    //TODO
    //unitObject.tags = ;

    try {
      toHandle.saveTestData(
          currentState.currentTest, currentState.currentDocument, testObject);
    } finally {
      debugPrint("Async calls done");
    }

    //debugPrint("saving the testObject: \nLB = ${testObject.beginTest}\nUB = ${testObject.endTest}\nMethods = ${testObject.blows3}");
  }

  void updateTestData(String testName, String documentName) async{
    ObjectHandler objectHandler = new ObjectHandler();
    await objectHandler.getTestData(testName, documentName).then((onValue){
      setState(() {
        testObject = onValue;
        debugPrint("In set state: (${testObject.blowCount})");
        dirty = false;
      });
    });
  }
}
