import 'package:blamo/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:blamo/SideMenu.dart';
import 'package:blamo/CustomActionBar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:blamo/ObjectHandler.dart';

class LogInfoPage extends StatefulWidget {
  final StateData pass; //Passes the StateData object to the stateful constructor

  LogInfoPage(this.pass);

  @override
  _LogInfoPageState createState() => new _LogInfoPageState(pass);
}

class _LogInfoPageState extends State<LogInfoPage> {
  final routeName = '/TestPage';
  StateData currentState;
  _LogInfoPageState(this.currentState);
  var formNodes = new List<FocusNode>(21); //Handle passing focus from one field to the next

  bool dirty = true;
  LogInfo logInfoObject;

  @override
  void initState() {
    super.initState();
    for( var i = 0; i < 21; i++) {
      formNodes[i] = FocusNode();
    }

    dirty = true;
    updateLogInfoData(currentState.currentDocument);
  }

  @override
  void dispose () {
    for(var i = 0; i < 21; i++) {
      formNodes[i].dispose();
    }
    super.dispose();
  }

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    if(currentState.currentRoute != null) {
      currentState.currentRoute = '/LogInfoPage'; //Assigns currentState.currentRoute to the name of the current named route
    }

    if(!dirty){
      debugPrint("After setState: (${logInfoObject.county})");
      //debugPrint("Returning scaffold $toTest1, $toTest2");
      return getLogInfoScaffold(logInfoObject);
    } else {
      debugPrint("Returning empty Scaffold");
      return WillPopScope(
        onWillPop: backPressed,
        child: new Scaffold(
            backgroundColor: Colors.white,
            drawer: new Drawer(
                child: SideMenu(currentState)
            ),
          appBar: CustomActionBar("Log Info Page").getAppBar(),
        ),
      );
    }

  }
  //takes you back to Overview of borehole with dialog pop up to confirm loss of data
  Future<bool> backPressed() async {
    bool userInput = await showDialog(
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
    if(userInput) {   //If a user decides to leave the page it sets the page to navigate to
      currentState.currentRoute = "/Document";
      Navigator.pushReplacementNamed(
        context,
        "/Document",
        arguments: currentState,
      );
    }
  }

  void updateLogInfoData(String documentName) async{
    ObjectHandler objectHandler = new ObjectHandler();
    await objectHandler.getLogInfoData(documentName).then((onValue){
      setState(() {
        logInfoObject = onValue;
        debugPrint("In set state: (${logInfoObject.boreholeID})");
        dirty = false;
      });
    });
  }

  String formatValue(String value){
    if(value == "null"){
      return "";
    } else {
      return value;
    }
  }

  Widget getLogInfoScaffold(LogInfo logInfoToBuildFrom){
    return WillPopScope(
      onWillPop: backPressed,
      child: new Scaffold(
        backgroundColor: Colors.white,
        drawer: new Drawer(
          child: SideMenu(currentState),
        ),
        appBar: CustomActionBar("Log Info Page").getAppBar(),
        body: Padding(
            padding: EdgeInsets.fromLTRB(40,0,40,40),
            child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    FormBuilder(key: _fbKey,
                        initialValue: {
                          'date': DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                          'accept_terms': false,
                        },
                        autovalidate: true,
                        child: Column(
                            children: <Widget>[
                              FormBuilderTextField(
                                textInputAction: TextInputAction.next,
                                focusNode: formNodes[0],
                                attribute: 'project',
                                validators: [],
                                decoration: InputDecoration(labelText: "Project"),
                                initialValue: formatValue(logInfoToBuildFrom.project),
                                onChanged: (void nbd){updateLogObject();}, //Update field when it is changed
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[1]); //The next field gets focus when this field is submitted
                                },
                              ),
                              FormBuilderTextField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                focusNode: formNodes[1],
                                attribute: 'number',
                                validators: [FormBuilderValidators.numeric(), FormBuilderValidators.min(0)],
                                decoration: InputDecoration(labelText: "Number"),
                                initialValue: formatValue(logInfoToBuildFrom.number),
                                onChanged: (void nbd){updateLogObject();},
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[2]);
                                },
                              ),
                              FormBuilderTextField(
                                textInputAction: TextInputAction.next,
                                focusNode: formNodes[2],
                                attribute: 'client',
                                validators: [],
                                decoration: InputDecoration(labelText: "Client"),
                                initialValue: formatValue(logInfoToBuildFrom.client),
                                onChanged: (void nbd){updateLogObject();},
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[3]);
                                },
                              ),
                              FormBuilderTextField(
                                textInputAction: TextInputAction.next,
                                focusNode: formNodes[3],
                                attribute: 'highway',
                                validators: [],
                                decoration: InputDecoration(labelText: "Highway"),
                                initialValue: formatValue(logInfoToBuildFrom.highway),
                                onChanged: (void nbd){updateLogObject();},
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[4]);
                                },
                              ),
                              FormBuilderTextField(
                                textInputAction: TextInputAction.next,
                                focusNode: formNodes[4],
                                attribute: 'county',
                                validators: [],
                                decoration: InputDecoration(labelText: "County"),
                                initialValue: formatValue(logInfoToBuildFrom.county),
                                onChanged: (void nbd){updateLogObject();},
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[5]);
                                },
                              ),
                              FormBuilderTextField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                focusNode: formNodes[5],
                                attribute: 'north',
                                validators: [FormBuilderValidators.numeric()],
                                decoration: InputDecoration(labelText: "Northing"),
                                initialValue: formatValue(logInfoToBuildFrom.north),
                                onChanged: (void nbd){updateLogObject();},
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[6]);
                                },
                              ),
                              FormBuilderTextField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                focusNode: formNodes[6],
                                attribute: 'east',
                                validators: [FormBuilderValidators.numeric()],
                                decoration: InputDecoration(labelText: "Easting"),
                                initialValue: formatValue(logInfoToBuildFrom.east),
                                onChanged: (void nbd){updateLogObject();},
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[7]);
                                },
                              ),
                              FormBuilderTextField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                focusNode: formNodes[7],
                                attribute: 'lat',
                                validators: [FormBuilderValidators.numeric()],
                                decoration: InputDecoration(labelText: "Latitude"),
                                initialValue: formatValue(logInfoToBuildFrom.lat),
                                onChanged: (void nbd){updateLogObject();},
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[8]);
                                },
                              ),
                              FormBuilderTextField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                focusNode: formNodes[8],
                                attribute: 'long',
                                validators: [FormBuilderValidators.numeric()],
                                decoration: InputDecoration(labelText: "Longitude"),
                                initialValue: formatValue(logInfoToBuildFrom.long),
                                onChanged: (void nbd){updateLogObject();},
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[9]);
                                },
                              ),
                              FormBuilderTextField(
                                textInputAction: TextInputAction.next,
                                focusNode: formNodes[9],
                                attribute: 'location',
                                validators: [],
                                decoration: InputDecoration(labelText: "Location"),
                                initialValue: formatValue(logInfoToBuildFrom.location),
                                onChanged: (void nbd){updateLogObject();},
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[10]);
                                },
                              ),
                              FormBuilderTextField(
                                textInputAction: TextInputAction.next,
                                focusNode: formNodes[10],
                                attribute: 'elevationDatum',
                                validators: [],
                                decoration: InputDecoration(labelText: "Elevation Datum"),
                                initialValue: formatValue(logInfoToBuildFrom.elevationDatum),
                                onChanged: (void nbd){updateLogObject();},
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[11]);
                                },
                              ),
                              FormBuilderTextField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                focusNode: formNodes[11],
                                attribute: 'tubeHeight',
                                validators: [FormBuilderValidators.numeric(), FormBuilderValidators.min(0)],
                                decoration: InputDecoration(labelText: "Tube Height"),
                                initialValue: formatValue(logInfoToBuildFrom.tubeHeight),
                                onChanged: (void nbd){updateLogObject();},
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[12]);
                                },
                              ),
                              FormBuilderTextField(
                                textInputAction: TextInputAction.done,
                                focusNode: formNodes[12],
                                attribute: 'boreholeID',
                                validators: [],
                                decoration: InputDecoration(labelText: "Borehole ID"),
                                initialValue: formatValue(logInfoToBuildFrom.boreholeID),
                                onChanged: (void nbd){updateLogObject();},
                              ),
                              FormBuilderDateTimePicker(
                                focusNode: formNodes[13],
                                attribute: "startDate",
                                inputType: InputType.date,
                                validators: [],
                                format: DateFormat("dd-MM-yyyy"),
                                decoration: InputDecoration(labelText: "Start Date"),
                                //Todo
                                initialValue: DateTime.tryParse(logInfoToBuildFrom.startDate),
                                onChanged: (void nbd){updateLogObject();},
                              ),
                              FormBuilderDateTimePicker(
                                focusNode: formNodes[14],
                                attribute: 'endDate',
                                inputType: InputType.date,
                                validators: [(endDate){
                                  if(_fbKey.currentState != null && endDate != null && _fbKey.currentState.fields["startDate"].currentState.value != null && endDate.isBefore(_fbKey.currentState.fields["startDate"].currentState.value))
                                    return "End Date must be after Start Date";
                                  return null;
                                }], //Custom validator that checks that the end date is after the start date
                                format: DateFormat('dd-MM-yyyy'),
                                decoration: InputDecoration(labelText: "End Date"),
                                //Todo
                                initialValue: DateTime.tryParse(logInfoToBuildFrom.endDate),
                                onChanged: (void nbd){updateLogObject();},
                              ),
                              FormBuilderTextField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                focusNode: formNodes[15],
                                attribute: 'surfaceElevation',
                                validators: [FormBuilderValidators.numeric()],
                                decoration: InputDecoration(labelText: "Surface Elevation (ft)"),
                                initialValue: formatValue(logInfoToBuildFrom.surfaceElevation),
                                onChanged: (void nbd){updateLogObject();},
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[16]);
                                },
                              ),
                              FormBuilderTextField(
                                textInputAction: TextInputAction.next,
                                focusNode: formNodes[16],
                                attribute: 'contractor',
                                validators: [],
                                decoration: InputDecoration(labelText: "Contractor"),
                                initialValue: formatValue(logInfoToBuildFrom.contractor),
                                onChanged: (void nbd){updateLogObject();},
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[17]);
                                },
                              ),
                              FormBuilderTextField(
                                textInputAction: TextInputAction.next,
                                focusNode: formNodes[17],
                                attribute: 'equipment',
                                validators: [],
                                decoration: InputDecoration(labelText: "Equipment"),
                                initialValue: formatValue(logInfoToBuildFrom.equipment),
                                onChanged: (void nbd){updateLogObject();},
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[18]);
                                },
                              ),
                              FormBuilderTextField(
                                textInputAction: TextInputAction.next,
                                focusNode: formNodes[18],
                                attribute: 'method',
                                validators: [],
                                decoration: InputDecoration(labelText: "Method"),
                                initialValue: formatValue(logInfoToBuildFrom.method),
                                onChanged: (void nbd){updateLogObject();},
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[19]);
                                },
                              ),
                              FormBuilderTextField(
                                textInputAction: TextInputAction.next,
                                focusNode: formNodes[19],
                                attribute: 'loggedBy',
                                validators: [],
                                decoration: InputDecoration(labelText: "Logged By"),
                                initialValue: formatValue(logInfoToBuildFrom.loggedBy),
                                onChanged: (void nbd){updateLogObject();},
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[20]);
                                },
                              ),
                              FormBuilderTextField(
                                textInputAction: TextInputAction.done,
                                focusNode: formNodes[20],
                                attribute: 'checkedBy',
                                validators: [],
                                decoration: InputDecoration(labelText: "Checked By"),
                                onChanged: (void nbd){updateLogObject();},
                                initialValue: formatValue(logInfoToBuildFrom.checkedBy),
                              ),
                            ]
                        )
                    )
                  ],
                ))),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_fbKey.currentState.saveAndValidate()) {
              //print(_fbKey.currentState.value); // formbuilders have onEditingComplete property, could be worth looking into. Run it by client.
              updateLogObject();
              saveLogObject();
              _showToast("Success", Colors.green);
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

  void updateLogObject(){
    logInfoObject.project = _fbKey.currentState.fields["project"].currentState.value;
    logInfoObject.number = _fbKey.currentState.fields["number"].currentState.value;
    logInfoObject.client = _fbKey.currentState.fields["client"].currentState.value;
    logInfoObject.highway = _fbKey.currentState.fields["highway"].currentState.value;
    logInfoObject.county = _fbKey.currentState.fields["county"].currentState.value;
    logInfoObject.north = _fbKey.currentState.fields["north"].currentState.value;
    logInfoObject.east = _fbKey.currentState.fields["east"].currentState.value;
    logInfoObject.lat = _fbKey.currentState.fields["lat"].currentState.value;
    logInfoObject.long = _fbKey.currentState.fields["long"].currentState.value;
    logInfoObject.location = _fbKey.currentState.fields["location"].currentState.value;
    logInfoObject.elevationDatum = _fbKey.currentState.fields["elevationDatum"].currentState.value;
    logInfoObject.tubeHeight = _fbKey.currentState.fields["tubeHeight"].currentState.value;
    logInfoObject.boreholeID = _fbKey.currentState.fields["boreholeID"].currentState.value;
    if(_fbKey.currentState.fields["startDate"].currentState.value != null) {
      //Updates date and removes time values
      logInfoObject.startDate = "" + DateTime(_fbKey.currentState.fields["startDate"].currentState.value.year, _fbKey.currentState.fields["startDate"].currentState.value.month, _fbKey.currentState.fields["startDate"].currentState.value.day).toString();
    }
    else {
      logInfoObject.startDate = ""+_fbKey.currentState.fields["startDate"].currentState.value.toString();
    }
    if(_fbKey.currentState.fields["endDate"].currentState.value != null) {
      logInfoObject.endDate = "" + DateTime(_fbKey.currentState.fields["endDate"].currentState.value.year, _fbKey.currentState.fields["endDate"].currentState.value.month, _fbKey.currentState.fields["endDate"].currentState.value.day).toString();
    }
    else {
      logInfoObject.endDate = ""+_fbKey.currentState.fields["endDate"].currentState.value.toString();
    }
    logInfoObject.surfaceElevation = _fbKey.currentState.fields["surfaceElevation"].currentState.value;
    logInfoObject.contractor = _fbKey.currentState.fields["contractor"].currentState.value;
    logInfoObject.equipment = _fbKey.currentState.fields["equipment"].currentState.value;
    logInfoObject.method = _fbKey.currentState.fields["method"].currentState.value;
    logInfoObject.loggedBy = _fbKey.currentState.fields["loggedBy"].currentState.value;
    logInfoObject.checkedBy = _fbKey.currentState.fields["checkedBy"].currentState.value;
  }

  void saveLogObject() async{
    ObjectHandler toHandle = new ObjectHandler();
    try {
      toHandle.saveLogInfoData(currentState.currentDocument, logInfoObject);
    } finally {
      debugPrint("Async calls done");
    }
  }
}

