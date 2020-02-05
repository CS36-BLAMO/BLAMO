import 'package:blamo/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:flutter_test/flutter_test.dart';

class LogInfoPage extends StatefulWidget {
  StateData pass; //Passes the StateData object to the stateful constructor

  LogInfoPage(this.pass);

  @override
  _LogInfoPageState createState() => new _LogInfoPageState(pass);
}

class _LogInfoPageState extends State<LogInfoPage> {
  final routeName = '/TestPage';
  StateData currentState;
  _LogInfoPageState(this.currentState);

  @override
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  Widget build(BuildContext context) {
    if(currentState.currentRoute != null) {
      currentState.currentRoute = '/LogInfoPage'; //Assigns currentState.currentRoute to the name of the current named route
    }
    return new Scaffold(
        backgroundColor: Colors.white,
        drawer: new Drawer(
        child: SideMenu(currentState),
      ),
        appBar: new AppBar(
            title: new Text("Log Info Page"),
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
                    attribute: 'title',
                    validators: [],
                    decoration: InputDecoration(labelText: "Project Name"),
                  ),
                  FormBuilderDateTimePicker(
                    attribute: "start-date",
                    inputType: InputType.date,
                    validators: [],
                    format: DateFormat("dd-MM-yyyy"),
                    decoration: InputDecoration(labelText: "Start Date"),
                  ),
                  FormBuilderDateTimePicker(
                    attribute: 'end-date',
                    inputType: InputType.date,
                    validators: [],
                    format: DateFormat('dd-MM-yyyy'),
                    decoration: InputDecoration(labelText: "End Date"),
                  ),
                  FormBuilderTextField(
                    attribute: 'driller',
                    validators: [],
                    decoration: InputDecoration(labelText: "Driller"),
                  ),
                  FormBuilderTextField(
                    attribute: 'geologist',
                    validators: [],
                    decoration: InputDecoration(labelText: "Project Geologist"),
                  ),
                  FormBuilderTextField(
                    attribute: 'recorder',
                    validators: [],
                    decoration: InputDecoration(labelText: "Recorder"),
                  ),
                  FormBuilderTextField(
                    attribute: 'northing',
                    validators: [FormBuilderValidators.numeric()],
                    decoration: InputDecoration(
                      labelText: "Northing",),
                  ),
                  FormBuilderTextField(
                    attribute: 'easting',
                    validators: [FormBuilderValidators.numeric()],
                    decoration: InputDecoration(
                      labelText: "Easting"),
                  ),
                  FormBuilderTextField(
                    attribute: 'highway',
                    validators: [],
                    decoration: InputDecoration(labelText: "Highway"),
                  ),
                  FormBuilderTextField(
                    attribute: 'county',
                    validators: [],
                    decoration: InputDecoration(labelText: "County"),
                  ),
                  FormBuilderTextField(
                    attribute: 'purpose',
                    validators: [],
                    decoration: InputDecoration(labelText: "Purpose"),
                  ),
                  FormBuilderTextField( 
                    attribute: 'hole-no',
                    validators: [FormBuilderValidators.numeric()],
                    decoration: InputDecoration(labelText: "Hole No."),
                  ),
                  FormBuilderTextField( 
                    attribute: 'ea-no',
                    validators: [FormBuilderValidators.numeric()],
                    decoration: InputDecoration(labelText: "E.A. No."),
                  ),
                  FormBuilderTextField( 
                    attribute: 'key-no',
                    validators: [FormBuilderValidators.numeric()],
                    decoration: InputDecoration(labelText: "Key No."),
                  ),
                  FormBuilderTextField( 
                    attribute: 'start-card-no',
                    validators: [FormBuilderValidators.numeric()],
                    decoration: InputDecoration(labelText: "Start Card No."),
                  ),
                  FormBuilderTextField( 
                    attribute: 'elevation',
                    validators: [FormBuilderValidators.numeric()],
                    decoration: InputDecoration(labelText: "Ground Elevation (m)"),
                  ),
                  FormBuilderTextField( 
                    attribute: 'tube-height',
                    validators: [FormBuilderValidators.numeric()],
                    decoration: InputDecoration(labelText: "Tube Height"),
                  ),
                  FormBuilderTextField(
                    attribute: 'equipment',
                    validators: [],
                    decoration: InputDecoration(labelText: "Equipment"),
                  ),
                ]
                )
              )
            ],
          ))),
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (_fbKey.currentState.saveAndValidate()) {
                  print(_fbKey.currentState.value); // formbuilders have onEditingComplete property, could be worth looking into. Run it by client.
                }
              },
              child: Icon(Icons.save),
          ),
    );
  }
}

