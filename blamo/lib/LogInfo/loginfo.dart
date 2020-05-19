import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:blamo/Boreholes/BoreholeList.dart';
import 'package:blamo/CustomActionBar.dart';
import 'package:blamo/ObjectHandler.dart';
import 'package:blamo/SideMenu.dart';

class LogInfoPage extends StatefulWidget {
  final StateData pass; // Passes the StateData object to the stateful constructor

  LogInfoPage(this.pass, {Key key}) : super(key:key);

  @override
  _LogInfoPageState createState() => new _LogInfoPageState(pass);
}

class _LogInfoPageState extends State<LogInfoPage> {
  final routeName = '/TestPage';
  StateData currentState;
  _LogInfoPageState(this.currentState);
  var formNodes = new List<FocusNode>(21); // Handle passing focus from one field to the next

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
      currentState.currentRoute = '/LogInfoPage'; // Assigns currentState.currentRoute to the name of the current named route
    }

    if(!dirty){
      debugPrint("After setState: (${logInfoObject.county})");
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
  // takes you back to Overview of borehole with dialog pop up to confirm loss of data
  Future<bool> backPressed() async {
    bool userInput = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text("Are you sure you want to leave this page?\n\nAll unsaved data will be discarded."),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Yes",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.red
                  ),
                ),
                onPressed: () => Navigator.pop(context,true),
              ),
              FlatButton(
                child: Text(
                  "No",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                onPressed: () => Navigator.pop(context,false),
              ),
            ]
        )
    );
    if(userInput) {   // If a user decides to leave the page it sets the page to navigate to
      currentState.currentRoute = "/Document";
      Navigator.pushReplacementNamed(
        context,
        "/Document",
        arguments: currentState,
      );
    }
    return userInput;
  }

  void updateLogInfoData(String documentName) async{
    ObjectHandler objectHandler = new ObjectHandler(currentState.currentProject);
    await objectHandler.getLogInfoData(documentName).then((onValue){
      setState(() {
        logInfoObject = onValue;
        debugPrint("In set state: (${logInfoObject.boreholeID})");
        dirty = false;
      });
    });
  }

  // This function formats null values
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
                key: Key('logInfoScroll'),
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
                                key: Key('projectField'),                       // used for testing purposes
                                textInputAction: TextInputAction.next,          // changes the 'enter' icon on the keyboard
                                focusNode: formNodes[0],                        // used for controlling which field has focus
                                attribute: 'project',                           // used for identifying fields
                                validators: [],                                 // user input checks
                                maxLength: 100,                                 // restricts user input to 100 characters
                                maxLengthEnforced: true,
                                decoration: InputDecoration(labelText: "Project", counterText:""),  // Labels the field and hides the character counter
                                initialValue: formatValue(logInfoToBuildFrom.project),              // the initial value to be displayed
                                onChanged: (void nbd){updateLogObject();},      //Update field when it is changed
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[1]);                // The next field gets focus when this field is submitted
                                },
                              ),
                              FormBuilderTextField(
                                key: Key('numberField'),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                focusNode: formNodes[1],
                                attribute: 'number',
                                validators: [FormBuilderValidators.numeric(), FormBuilderValidators.min(0)],
                                maxLength: 15,
                                maxLengthEnforced: true,
                                decoration: InputDecoration(labelText: "Number", counterText:""),
                                initialValue: formatValue(logInfoToBuildFrom.number),
                                onChanged: (void nbd){updateLogObject();},
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[2]);
                                },
                              ),
                              FormBuilderTextField(
                                key: Key('clientField'),
                                textInputAction: TextInputAction.next,
                                focusNode: formNodes[2],
                                attribute: 'client',
                                validators: [],
                                maxLength: 100,
                                maxLengthEnforced: true,
                                decoration: InputDecoration(labelText: "Client", counterText:""),
                                initialValue: formatValue(logInfoToBuildFrom.client),
                                onChanged: (void nbd){updateLogObject();},
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[3]);
                                },
                              ),
                              FormBuilderTextField(
                                key: Key('highwayField'),
                                textInputAction: TextInputAction.next,
                                focusNode: formNodes[3],
                                attribute: 'highway',
                                validators: [],
                                maxLength: 100,
                                maxLengthEnforced: true,
                                decoration: InputDecoration(labelText: "Highway", counterText:""),
                                initialValue: formatValue(logInfoToBuildFrom.highway),
                                onChanged: (void nbd){updateLogObject();},
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[4]);
                                },
                              ),
                              FormBuilderTextField(
                                key: Key('countyField'),
                                textInputAction: TextInputAction.done,
                                focusNode: formNodes[4],
                                attribute: 'county',
                                validators: [],
                                maxLength: 100,
                                maxLengthEnforced: true,
                                decoration: InputDecoration(labelText: "County", counterText:""),
                                initialValue: formatValue(logInfoToBuildFrom.county),
                                onChanged: (void nbd){updateLogObject();},
                              ),
                              FormBuilderDropdown(
                                key: Key('projectionField'),
                                attribute: 'projection',
                                decoration: InputDecoration(labelText: "Projection",
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,),
                                validators: [],
                                items: ["NAD 1983 2011 Oregon Statewide Lambert Ft Intl", "GCS WGS 1984"].map(
                                    (projection) => DropdownMenuItem(
                                      value: projection,
                                      child: Text("$projection", key: Key('projection_' + projection), overflow: TextOverflow.visible)
                                    )).toList(),
                                initialValue: formatValue(logInfoToBuildFrom.projection),
                                onChanged: (void nbd){updateLogObject();},
                              ),
                              FormBuilderTextField(
                                key: Key('northField'),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                focusNode: formNodes[5],
                                attribute: 'north',
                                validators: [FormBuilderValidators.numeric()],
                                maxLength: 25,
                                maxLengthEnforced: true,
                                decoration: InputDecoration(labelText: "Northing", counterText:""),
                                initialValue: formatValue(logInfoToBuildFrom.north),
                                onChanged: (void nbd){updateLogObject();},
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[6]);
                                },
                              ),
                              FormBuilderTextField(
                                key: Key('eastField'),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                focusNode: formNodes[6],
                                attribute: 'east',
                                validators: [FormBuilderValidators.numeric()],
                                maxLength: 25,
                                maxLengthEnforced: true,
                                decoration: InputDecoration(labelText: "Easting", counterText:""),
                                initialValue: formatValue(logInfoToBuildFrom.east),
                                onChanged: (void nbd){updateLogObject();},
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[7]);
                                },
                              ),
                              FormBuilderTextField(
                                key: Key('latField'),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                focusNode: formNodes[7],
                                attribute: 'lat',
                                validators: [FormBuilderValidators.numeric()],
                                maxLength: 25,
                                maxLengthEnforced: true,
                                decoration: InputDecoration(labelText: "Latitude", counterText:""),
                                initialValue: formatValue(logInfoToBuildFrom.lat),
                                onChanged: (void nbd){updateLogObject();},
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[8]);
                                },
                              ),
                              FormBuilderTextField(
                                key: Key('longField'),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                focusNode: formNodes[8],
                                attribute: 'long',
                                validators: [FormBuilderValidators.numeric()],
                                maxLength: 25,
                                maxLengthEnforced: true,
                                decoration: InputDecoration(labelText: "Longitude", counterText:""),
                                initialValue: formatValue(logInfoToBuildFrom.long),
                                onChanged: (void nbd){updateLogObject();},
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[9]);
                                },
                              ),
                              FormBuilderTextField(
                                key: Key('locationField'),
                                textInputAction: TextInputAction.next,
                                focusNode: formNodes[9],
                                attribute: 'location',
                                validators: [],
                                maxLength: 100,
                                maxLengthEnforced: true,
                                decoration: InputDecoration(labelText: "Location", counterText:""),
                                initialValue: formatValue(logInfoToBuildFrom.location),
                                onChanged: (void nbd){updateLogObject();},
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[10]);
                                },
                              ),
                              FormBuilderTextField(
                                key: Key('elevationDatumField'),
                                textInputAction: TextInputAction.next,
                                focusNode: formNodes[10],
                                attribute: 'elevationDatum',
                                validators: [],
                                maxLength: 100,
                                maxLengthEnforced: true,
                                decoration: InputDecoration(labelText: "Elevation Datum", counterText:""),
                                initialValue: formatValue(logInfoToBuildFrom.elevationDatum),
                                onChanged: (void nbd){updateLogObject();},
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[11]);
                                },
                              ),
                              FormBuilderTextField(
                                key: Key('tubeHeightField'),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                focusNode: formNodes[11],
                                attribute: 'tubeHeight',
                                validators: [FormBuilderValidators.numeric(), FormBuilderValidators.min(0)],
                                maxLength: 15,
                                maxLengthEnforced: true,
                                decoration: InputDecoration(labelText: "Tube Height", counterText:""),
                                initialValue: formatValue(logInfoToBuildFrom.tubeHeight),
                                onChanged: (void nbd){updateLogObject();},
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[12]);
                                },
                              ),
                              FormBuilderTextField(
                                key: Key('boreholeIDField'),
                                textInputAction: TextInputAction.done,
                                focusNode: formNodes[12],
                                attribute: 'boreholeID',
                                validators: [],
                                maxLength: 100,
                                maxLengthEnforced: true,
                                decoration: InputDecoration(labelText: "Borehole ID", counterText:""),
                                initialValue: formatValue(logInfoToBuildFrom.boreholeID),
                                onChanged: (void nbd){updateLogObject();},
                              ),
                              FormBuilderDateTimePicker(
                                key: Key('startDateField'),
                                focusNode: formNodes[13],
                                attribute: "startDate",
                                inputType: InputType.date,
                                validators: [],
                                format: DateFormat("yyyy-MM-dd"),
                                decoration: InputDecoration(labelText: "Start Date"),
                                initialValue: DateTime.tryParse(logInfoToBuildFrom.startDate + " 00:00:00"),
                                onChanged: (void nbd){updateLogObject();},
                              ),
                              FormBuilderDateTimePicker(
                                key: Key('endDateField'),
                                focusNode: formNodes[14],
                                attribute: 'endDate',
                                inputType: InputType.date,
                                validators: [(endDate){
                                  if(_fbKey.currentState != null && endDate != null && _fbKey.currentState.fields["startDate"].currentState.value != null && endDate.isBefore(_fbKey.currentState.fields["startDate"].currentState.value))
                                    return "End Date must be after Start Date";
                                  return null;
                                }], //Custom validator that checks that the end date is after the start date
                                format: DateFormat('yyyy-MM-dd'),
                                decoration: InputDecoration(labelText: "End Date"),
                                initialValue: DateTime.tryParse(logInfoToBuildFrom.endDate + " 00:00:00"),
                                onChanged: (void nbd){updateLogObject();},
                              ),
                              FormBuilderTextField(
                                key: Key('surfaceElevationField'),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                focusNode: formNodes[15],
                                attribute: 'surfaceElevation',
                                validators: [FormBuilderValidators.numeric()],
                                maxLength: 15,
                                maxLengthEnforced: true,
                                decoration: InputDecoration(labelText: "Surface Elevation (ft)", counterText:""),
                                initialValue: formatValue(logInfoToBuildFrom.surfaceElevation),
                                onChanged: (void nbd){updateLogObject();},
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[16]);
                                },
                              ),
                              FormBuilderTextField(
                                key: Key('contractorField'),
                                textInputAction: TextInputAction.next,
                                focusNode: formNodes[16],
                                attribute: 'contractor',
                                validators: [],
                                maxLength: 100,
                                maxLengthEnforced: true,
                                decoration: InputDecoration(labelText: "Contractor", counterText:""),
                                initialValue: formatValue(logInfoToBuildFrom.contractor),
                                onChanged: (void nbd){updateLogObject();},
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[17]);
                                },
                              ),
                              FormBuilderTextField(
                                key: Key('equipmentField'),
                                textInputAction: TextInputAction.next,
                                focusNode: formNodes[17],
                                attribute: 'equipment',
                                validators: [],
                                maxLength: 100,
                                maxLengthEnforced: true,
                                decoration: InputDecoration(labelText: "Equipment", counterText:""),
                                initialValue: formatValue(logInfoToBuildFrom.equipment),
                                onChanged: (void nbd){updateLogObject();},
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[18]);
                                },
                              ),
                              FormBuilderTextField(
                                key: Key('methodField'),
                                textInputAction: TextInputAction.next,
                                focusNode: formNodes[18],
                                attribute: 'method',
                                validators: [],
                                maxLength: 100,
                                maxLengthEnforced: true,
                                decoration: InputDecoration(labelText: "Method", counterText:""),
                                initialValue: formatValue(logInfoToBuildFrom.method),
                                onChanged: (void nbd){updateLogObject();},
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[19]);
                                },
                              ),
                              FormBuilderTextField(
                                key: Key('loggedByField'),
                                textInputAction: TextInputAction.next,
                                focusNode: formNodes[19],
                                attribute: 'loggedBy',
                                validators: [],
                                maxLength: 100,
                                maxLengthEnforced: true,
                                decoration: InputDecoration(labelText: "Logged By", counterText:""),
                                initialValue: formatValue(logInfoToBuildFrom.loggedBy),
                                onChanged: (void nbd){updateLogObject();},
                                onFieldSubmitted: (v){
                                  FocusScope.of(context).requestFocus(formNodes[20]);
                                },
                              ),
                              FormBuilderTextField(
                                key: Key('checkedByField'),
                                textInputAction: TextInputAction.done,
                                focusNode: formNodes[20],
                                attribute: 'checkedBy',
                                validators: [],
                                maxLength: 100,
                                maxLengthEnforced: true,
                                decoration: InputDecoration(labelText: "Checked By", counterText:""),
                                onChanged: (void nbd){updateLogObject();},
                                initialValue: formatValue(logInfoToBuildFrom.checkedBy),
                              ),
                            ]
                        )
                    )
                  ],
                ))),
        floatingActionButton: FloatingActionButton(         // save button
          key: Key('saveLogInfo'),
          onPressed: () {
            if (_fbKey.currentState.saveAndValidate()) {    // check user input and save
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

  // Helper function to display toasts
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

  // Used to keep the fields updated as the user enters info
  void updateLogObject(){
    logInfoObject.project = _fbKey.currentState.fields["project"].currentState.value;
    logInfoObject.number = _fbKey.currentState.fields["number"].currentState.value;
    logInfoObject.client = _fbKey.currentState.fields["client"].currentState.value;
    logInfoObject.highway = _fbKey.currentState.fields["highway"].currentState.value;
    logInfoObject.county = _fbKey.currentState.fields["county"].currentState.value;
    logInfoObject.projection = _fbKey.currentState.fields["projection"].currentState.value;
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
      logInfoObject.startDate = "" + _fbKey.currentState.fields["startDate"].currentState.value.year.toString() + "-" + _fbKey.currentState.fields["startDate"].currentState.value.month.toString().padLeft(2, '0') + "-" + _fbKey.currentState.fields["startDate"].currentState.value.day.toString().padLeft(2, '0');
    }
    else {
      logInfoObject.startDate = ""+_fbKey.currentState.fields["startDate"].currentState.value.toString();
    }
    if(_fbKey.currentState.fields["endDate"].currentState.value != null) {
      logInfoObject.endDate = "" + _fbKey.currentState.fields["endDate"].currentState.value.year.toString() + "-" + _fbKey.currentState.fields["endDate"].currentState.value.month.toString().padLeft(2, '0') + "-" + _fbKey.currentState.fields["endDate"].currentState.value.day.toString().padLeft(2, '0');
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

  // Saves the field values
  void saveLogObject() async{
    ObjectHandler toHandle = new ObjectHandler(currentState.currentProject);
    try {
      toHandle.saveLogInfoData(currentState.currentDocument, logInfoObject);
    } finally {
      debugPrint("Async calls done");
    }
  }
}

