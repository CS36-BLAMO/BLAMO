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
  var formNodes = new List<FocusNode>(16);

  @override
  void initState() {
    super.initState();

    for( var i = 0; i < 16; i++) {
      formNodes[i] = FocusNode();
    }

  }

  @override
  void dispose () {
    
    for(var i = 0; i < 16; i++) {
      formNodes[i].dispose();
    }

    super.dispose();
  }

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
                    textInputAction: TextInputAction.next,
                    focusNode: formNodes[0],
                    attribute: 'objectID',
                    validators: [],
                    decoration: InputDecoration(labelText: "ObjectID"),
                    onFieldSubmitted: (v){
                      FocusScope.of(context).requestFocus(formNodes[1]);
                    },
                  ),
                  FormBuilderTextField(
                    textInputAction: TextInputAction.next,
                    focusNode: formNodes[1],
                    attribute: 'testType',
                    validators: [],
                    decoration: InputDecoration(labelText: "Test Type"),
                    onFieldSubmitted: (v){
                      FocusScope.of(context).requestFocus(formNodes[2]);
                    },
                  ),
                  FormBuilderTextField(
                    textInputAction: TextInputAction.next,
                    focusNode: formNodes[2],
                    attribute: 'project',
                    validators: [],
                    decoration: InputDecoration(labelText: "Project"),
                    onFieldSubmitted: (v){
                      FocusScope.of(context).requestFocus(formNodes[3]);
                    },
                  ),
                  FormBuilderTextField(
                    textInputAction: TextInputAction.next,
                    focusNode: formNodes[3],
                    attribute: 'number',
                    validators: [FormBuilderValidators.numeric()],
                    decoration: InputDecoration(labelText: "Number"),
                    onFieldSubmitted: (v){
                      FocusScope.of(context).requestFocus(formNodes[4]);
                    },
                  ),
                  FormBuilderTextField(
                    textInputAction: TextInputAction.next,
                    focusNode: formNodes[4],
                    attribute: 'client',
                    validators: [],
                    decoration: InputDecoration(labelText: "Client"),
                    onFieldSubmitted: (v){
                      FocusScope.of(context).requestFocus(formNodes[5]);
                    },
                  ),
                  FormBuilderTextField(
                    textInputAction: TextInputAction.next,
                    focusNode: formNodes[5],
                    attribute: 'lat',
                    validators: [FormBuilderValidators.numeric()],
                    decoration: InputDecoration(labelText: "Latitude"),
                    onFieldSubmitted: (v){
                      FocusScope.of(context).requestFocus(formNodes[6]);
                    },
                  ),
                  FormBuilderTextField(
                    textInputAction: TextInputAction.next,
                    focusNode: formNodes[6],
                    attribute: 'long',
                    validators: [FormBuilderValidators.numeric()],
                    decoration: InputDecoration(labelText: "Longitude"),
                    onFieldSubmitted: (v){
                      FocusScope.of(context).requestFocus(formNodes[7]);
                    },
                  ),
                  FormBuilderTextField(
                    textInputAction: TextInputAction.next,
                    focusNode: formNodes[7],
                    attribute: 'elevationDatum',
                    validators: [],
                    decoration: InputDecoration(labelText: "Elevation Datum"),
                    onFieldSubmitted: (v){
                      FocusScope.of(context).requestFocus(formNodes[8]);
                    },
                  ),
                  FormBuilderTextField(
                    textInputAction: TextInputAction.next,
                    focusNode: formNodes[8],
                    attribute: 'boreholeID',
                    validators: [FormBuilderValidators.numeric()],
                    decoration: InputDecoration(labelText: "Borehole ID"),
                    onFieldSubmitted: (v){
                      FocusScope.of(context).requestFocus(formNodes[9]);
                    },
                  ),
                  FormBuilderDateTimePicker(
                    textInputAction: TextInputAction.next,
                    focusNode: formNodes[9],
                    attribute: "startDate",
                    inputType: InputType.date,
                    validators: [],
                    format: DateFormat("dd-MM-yyyy"),
                    decoration: InputDecoration(labelText: "Start Date"),
                    onFieldSubmitted: (v){
                      FocusScope.of(context).requestFocus(formNodes[10]);
                    },
                  ),
                  FormBuilderDateTimePicker(
                    textInputAction: TextInputAction.next,
                    focusNode: formNodes[10],
                    attribute: 'endDate',
                    inputType: InputType.date,
                    validators: [],
                    format: DateFormat('dd-MM-yyyy'),
                    decoration: InputDecoration(labelText: "End Date"),
                    onFieldSubmitted: (v){
                      FocusScope.of(context).requestFocus(formNodes[11]);
                    },
                  ),
                  FormBuilderTextField(
                    textInputAction: TextInputAction.next,
                    focusNode: formNodes[11],
                    attribute: 'surfaceElevation',
                    validators: [FormBuilderValidators.numeric()],
                    decoration: InputDecoration(labelText: "Surface Elevation (ft)"),
                    onFieldSubmitted: (v){
                      FocusScope.of(context).requestFocus(formNodes[12]);
                    },
                  ),
                  FormBuilderTextField(
                    textInputAction: TextInputAction.next,
                    focusNode: formNodes[12],
                    attribute: 'contractor',
                    validators: [],
                    decoration: InputDecoration(labelText: "Contractor"),
                    onFieldSubmitted: (v){
                      FocusScope.of(context).requestFocus(formNodes[13]);
                    },
                  ),
                  FormBuilderTextField(
                    textInputAction: TextInputAction.next,
                    focusNode: formNodes[13],
                    attribute: 'method',
                    validators: [],
                    decoration: InputDecoration(labelText: "Method"),
                    onFieldSubmitted: (v){
                      FocusScope.of(context).requestFocus(formNodes[14]);
                    },
                  ),
                  FormBuilderTextField(
                    textInputAction: TextInputAction.next,
                    focusNode: formNodes[14],
                    attribute: 'loggedBy',
                    validators: [],
                    decoration: InputDecoration(labelText: "Logged By"),
                    onFieldSubmitted: (v){
                      FocusScope.of(context).requestFocus(formNodes[15]);
                    },
                  ),
                  FormBuilderTextField(
                    focusNode: formNodes[15],
                    attribute: 'checkedBy',
                    validators: [],
                    decoration: InputDecoration(labelText: "Checked By")
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

