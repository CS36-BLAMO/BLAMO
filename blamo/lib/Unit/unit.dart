import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:blamo/Boreholes/BoreholeList.dart';
import 'package:blamo/CustomActionBar.dart';
import 'package:blamo/ObjectHandler.dart';
import 'package:blamo/SideMenu.dart';

class UnitPage extends StatefulWidget {
  final StateData pass; // Passes the StateData object to the stateful constructor

  UnitPage(this.pass, {Key key}) : super(key:key);

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
  var formNodes = new List<FocusNode>(4);

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < 4; i++) {
      formNodes[i] = FocusNode();
    }
    dirty = true;
    updateUnitData(currentState.currentUnit, currentState.currentDocument);
  }

  @override
  void dispose() {
    for (var i = 0; i < 4; i++) {
      formNodes[i].dispose();
    }
    super.dispose();
  }


  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    String toTest1;
    String toTest2;
    if (currentState.currentRoute != null) {
      currentState.currentRoute =
      '/UnitPage'; // Assigns currentState.currentRoute to the name of the current named route
    }

    if (!dirty) {
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
          appBar: CustomActionBar("Unit Page: ${currentState.currentUnit}")
              .getAppBar(),
          backgroundColor: Colors.white,
          drawer: new Drawer(
              child: SideMenu(currentState)
          ),

        ),
      );
    }
  }

  // takes you back to units page with a pop up confirmation to not allow data loss
  Future<bool> backPressed() async {
    if (_fbKey.currentState.validate()) {
      return showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                  title: Text(
                      "Are you sure you want to leave this page?\n\nAll unsaved data will be discarded.",
                    style: TextStyle(
                      fontSize: 20,
                    ),),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(
                        "Yes",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.red
                        ),
                      ),
                      onPressed: () => Navigator.pop(context, true),
                    ),
                    FlatButton(
                      child: Text(
                        "No",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context, false),
                    ),
                  ]
              )
      );
    } else {
      return showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                  title: Text(
                      "There are fields with invalid inputs\n\nUnit will be deleted",
                    style: TextStyle(
                      fontSize: 20,
                    ),),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(
                        "Delete",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.red
                        ),
                      ),
                      onPressed: () => deleteBadUnit(),
                    ),
                    FlatButton(
                      child: Text(
                        "Edit",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context, false),
                    ),
                  ]
              )
      );
    }
  }

  String formatValue(String value) {
    if (value == "null") {
      return "";
    } else {
      return value;
    }
  }

  Widget getScaffold(Unit unitToBuildFrom) {
    return WillPopScope(
      onWillPop: backPressed,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomActionBar("Unit Page: ${currentState.currentUnit}")
            .getAppBar(),
        body: Padding(
            padding: EdgeInsets.fromLTRB(40, 0, 40, 40),
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
                                  key: Key('depth-ubField'),
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.number,
                                  focusNode: formNodes[0],
                                  attribute: 'depth-ub',
                                  validators: [
                                    FormBuilderValidators.numeric(),
                                    FormBuilderValidators.max(0),
                                    FormBuilderValidators.required()
                                  ],
                                  maxLength: 15,
                                  maxLengthEnforced: true,
                                  decoration: InputDecoration(
                                      labelText: "Depth Upper Bound (m)",
                                      counterText: ""),
                                  initialValue: formatValue(
                                      unitToBuildFrom.depthUB.toString()),
                                  onChanged: (void nbd) {
                                    updateUnitObject();
                                  },
                                  onFieldSubmitted: (v) {
                                    FocusScope.of(context).requestFocus(
                                        formNodes[1]);
                                  },
                                ),
                                FormBuilderTextField(
                                  key: Key('depth-lbField'),
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.number,
                                  focusNode: formNodes[1],
                                  attribute: 'depth-lb',
                                  validators: [
                                    FormBuilderValidators.numeric(),
                                    FormBuilderValidators.max(0),
                                    FormBuilderValidators.required(),
                                        (lower) {
                                      if (_fbKey.currentState != null &&
                                          lower != null &&
                                          _fbKey.currentState.fields['depth-ub']
                                              .currentState.value != null &&
                                          double.tryParse(_fbKey.currentState
                                              .fields['depth-ub']
                                              .currentState.value) != null &&
                                          double.tryParse(lower) != null &&
                                          double.tryParse(lower) >=
                                              double.tryParse(
                                                  _fbKey.currentState
                                                      .fields['depth-ub']
                                                      .currentState.value))
                                        return "Lower Bound must be lower than Upper Bound";
                                      return null;
                                    }
                                  ],
                                  //Custom validator that checks if lower bound is lower than upper bound
                                  maxLength: 15,
                                  maxLengthEnforced: true,
                                  decoration: InputDecoration(
                                      labelText: "Depth Lower Bound (m)",
                                      counterText: ""),
                                  initialValue: formatValue(
                                      unitToBuildFrom.depthLB.toString()),
                                  onChanged: (void nbd) {
                                    updateUnitObject();
                                  },
                                  onFieldSubmitted: (v) {
                                    FocusScope.of(context).requestFocus(
                                        formNodes[2]);
                                  },
                                ),
                                FormBuilderTextField(
                                  key: Key('methodsField'),
                                  textInputAction: TextInputAction.next,
                                  focusNode: formNodes[2],
                                  attribute: 'methods',
                                  validators: [],
                                  maxLength: 100,
                                  maxLengthEnforced: true,
                                  decoration: InputDecoration(
                                      labelText: "Drilling Methods",
                                      counterText: ""),
                                  initialValue: formatValue(
                                      unitToBuildFrom.drillingMethods),
                                  onChanged: (void nbd) {
                                    updateUnitObject();
                                  },
                                  onFieldSubmitted: (v) {
                                    FocusScope.of(context).requestFocus(
                                        formNodes[3]);
                                  },
                                ),
                                FormBuilderTextField(
                                  key: Key('notesField'),
                                  textInputAction: TextInputAction.newline,
                                  focusNode: formNodes[3],
                                  attribute: 'notes',
                                  validators: [],
                                  maxLength: 256,
                                  maxLengthEnforced: true,
                                  decoration: InputDecoration(
                                      labelText: "Notes"),
                                  initialValue: formatValue(
                                      unitToBuildFrom.notes),
                                  onChanged: (void nbd) {
                                    updateUnitObject();
                                  },
                                ),
                                FormBuilderCheckboxList(
                                  attribute: 'tags',
                                  validators: [],
                                  initialValue: getTags(unitToBuildFrom),
                                  options: [
                                    FormBuilderFieldOption(
                                      value: "Asphalt", key: Key(
                                        'unitAsphaltTag'),),
                                    FormBuilderFieldOption(value: "Basalt"),
                                    FormBuilderFieldOption(value: "Bedrock"),
                                    FormBuilderFieldOption(
                                        value: "Boulders and Cobbles"),
                                    FormBuilderFieldOption(value: "Breccia"),
                                    FormBuilderFieldOption(
                                        value: "USCS High Plasticity Clay"),
                                    FormBuilderFieldOption(value: "Chalk"),
                                    FormBuilderFieldOption(
                                        value: "USCS Low Plasticity Clay"),
                                    FormBuilderFieldOption(
                                        value: "USCS Low to High Plasticity Clay"),
                                    FormBuilderFieldOption(
                                        value: "USCS Low Plasticity Gavelly Clay"),
                                    FormBuilderFieldOption(
                                        value: "USCS Low Plasticity Silty Clay"),
                                    FormBuilderFieldOption(
                                        value: "USCS Low Plasticity Sandy Clay"),
                                    FormBuilderFieldOption(value: "Coal"),
                                    FormBuilderFieldOption(value: "Concrete"),
                                    FormBuilderFieldOption(value: "Coral"),
                                    FormBuilderFieldOption(value: "Fill"),
                                    FormBuilderFieldOption(
                                        value: "USCS Clayey Gravel"),
                                    FormBuilderFieldOption(
                                        value: "USCS Silty Gravel"),
                                    FormBuilderFieldOption(
                                        value: "USCS Poorly-graded Gravel"),
                                    FormBuilderFieldOption(
                                        value: "USCS Poorly-graded Gravel with clay"),
                                    FormBuilderFieldOption(
                                        value: "USCS Poorly-graded Gravel with silt"),
                                    FormBuilderFieldOption(
                                        value: "USCS Poorly-graded Sandy Gravel"),
                                    FormBuilderFieldOption(
                                        value: "USCS Well-graded Gravel"),
                                    FormBuilderFieldOption(
                                        value: "USCS Well-graded Gravel with Clay"),
                                    FormBuilderFieldOption(
                                        value: "USCS Well-graded Gravel with Silt"),
                                    FormBuilderFieldOption(
                                        value: "USCS Well-graded Sandy Gravel"),
                                    FormBuilderFieldOption(
                                        value: "Gypsum, rocksalt, etc."),
                                    FormBuilderFieldOption(value: "Limestone"),
                                    FormBuilderFieldOption(
                                        value: "USCS Elastic Silt"),
                                    FormBuilderFieldOption(value: "USCS Silt"),
                                    FormBuilderFieldOption(
                                        value: "USCS Gravely Silt"),
                                    FormBuilderFieldOption(
                                        value: "USCS Sandy Silt"),
                                    FormBuilderFieldOption(
                                        value: "USCS High Plasticity Organic silt or clay"),
                                    FormBuilderFieldOption(
                                        value: "USCS High Plasticity Organic silt or clay with shells"),
                                    FormBuilderFieldOption(
                                        value: "USCS Low Plasticity Organic silt or clay"),
                                    FormBuilderFieldOption(
                                        value: "USCS Low Plasticity Organic silt or clay with shells"),
                                    FormBuilderFieldOption(value: "USCS Peat"),
                                    FormBuilderFieldOption(value: "Sandstone"),
                                    FormBuilderFieldOption(
                                        value: "USCS Clayey Sand"),
                                    FormBuilderFieldOption(
                                        value: "USCS Clayey Sand with silt"),
                                    FormBuilderFieldOption(value: "Shale"),
                                    FormBuilderFieldOption(value: "Siltstone"),
                                    FormBuilderFieldOption(
                                        value: "USCS Silty Sand"),
                                    FormBuilderFieldOption(
                                        value: "USCS Poorly-graded Sand"),
                                    FormBuilderFieldOption(
                                        value: "USCS Poorly-graded Gravelly Sand"),
                                    FormBuilderFieldOption(
                                        value: "USCS Poorly-graded Sand with Clay"),
                                    FormBuilderFieldOption(
                                        value: "USCS Poorly-graded Sand with Silt"),
                                    FormBuilderFieldOption(
                                        value: "USCS Well-graded Sandy Gravel"),
                                    FormBuilderFieldOption(
                                        value: "USCS Well-graded Gravelly Sand"),
                                    FormBuilderFieldOption(
                                        value: "USCS Well-graded Sand with Clay"),
                                    FormBuilderFieldOption(
                                        value: "USCS Well-graded Sand with Silt"),
                                    FormBuilderFieldOption(
                                        value: "Glacial Till"),
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
          key: Key('saveUnit'),
          onPressed: () async {
            if (_fbKey.currentState.saveAndValidate()) {
              updateUnitObject();
              bool noOverlap = await checkUnitDepthOverlap();
              if (noOverlap) {
                await saveObject();
                _showToast("Success", Colors.green);
              } else {
                _showToast("Unit overlaps another Unit", Colors.red);
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

  Future<bool> checkUnitDepthOverlap() async {
    ObjectHandler objectHandler = new ObjectHandler(
        currentState.currentProject);
    for (int i = 0; i < currentState.unitList.length; i++) {
      Unit currentCheck = await objectHandler.getUnitData(
          currentState.unitList[i], currentState.currentDocument);
      if (currentState.currentUnit != currentState.unitList[i]) {
        try {
          if (unitObject.depthUB < currentCheck.depthUB &&
              unitObject.depthUB > currentCheck.depthLB) {
            return false;
          } else if (unitObject.depthLB < currentCheck.depthUB &&
              unitObject.depthLB > currentCheck.depthLB) {
            return false;
          } else if (unitObject.depthUB == currentCheck.depthUB ||
              unitObject.depthLB == currentCheck.depthLB) {
            return false;
          } else if (currentCheck.depthUB < unitObject.depthUB &&
              currentCheck.depthUB > unitObject.depthLB) {
            return false;
          } else if (currentCheck.depthLB < unitObject.depthUB &&
              currentCheck.depthLB > unitObject.depthLB) {
            return false;
          }
        } catch (NoSuchMethodError) { // null handling
          continue;
        }
      }
    }
    return true;
  }

  void _showToast(String toShow, MaterialColor color) {
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
    List<dynamic> ba;
    if (unitObj.tags != null) {
      ba = jsonDecode(unitObj.tags);
    }
    if (ba != null) {
      for (int i = 0; i < ba.length; i++) {
        toReturn.add(ba[i].toString());
      }
    }
    return toReturn;
  }

  void updateUnitObject() {
    if (double.tryParse(
        _fbKey.currentState.fields["depth-ub"].currentState.value) != null) {
      unitObject.depthUB = double.parse(
          _fbKey.currentState.fields["depth-ub"].currentState.value);
    } else {
      unitObject.depthUB = null;
    }
    if (double.tryParse(
        _fbKey.currentState.fields["depth-lb"].currentState.value) != null) {
      unitObject.depthLB = double.parse(
          _fbKey.currentState.fields["depth-lb"].currentState.value);
    } else {
      unitObject.depthLB = null;
    }
    unitObject.drillingMethods =
        _fbKey.currentState.fields['methods'].currentState.value.toString();
    unitObject.notes =
        _fbKey.currentState.fields['notes'].currentState.value.toString();
    unitObject.tags =
        jsonEncode(_fbKey.currentState.fields['tags'].currentState.value);
  }

  Future<void> saveObject() async {
    ObjectHandler toHandle = new ObjectHandler(currentState.currentProject);

    try {
      await toHandle.saveUnitData(
          currentState.currentUnit, currentState.currentDocument, unitObject);
    } finally {
      debugPrint("Async calls done");
    }

    debugPrint(
        "saving the unitObject: \nLB = ${unitObject.depthLB}\nUB = ${unitObject
            .depthUB}\nMethods = ${unitObject.drillingMethods}");
  }

  void updateUnitData(String unitName, String documentName) async {
    ObjectHandler objectHandler = new ObjectHandler(
        currentState.currentProject);
    await objectHandler.getUnitData(unitName, documentName).then((onValue) {
      setState(() {
        unitObject = onValue;
        debugPrint("In set state: (${unitObject.drillingMethods})");
        dirty = false;
      });
    });
  }

  void deleteBadUnit() async {
    await currentState.storage.deleteUnit(
        currentState.currentDocument, currentState.currentUnit);
    currentState.unitList.remove(currentState.currentUnit);

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
    Navigator.pop(context, true);
  }
}