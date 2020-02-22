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
  var formNodes = new List<FocusNode>(20);

  @override
  void initState() {
    super.initState();

    for( var i = 0; i < 20; i++) {
      formNodes[i] = FocusNode();
    }

  }

  @override
  void dispose () {
    
    for(var i = 0; i < 20; i++) {
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
                    attribute: 'title',
                    validators: [],
                    decoration: InputDecoration(labelText: "Project Name"),
                    onFieldSubmitted: (v){
                      FocusScope.of(context).requestFocus(formNodes[1]);
                    },
                  ),
                  FormBuilderTextField(
                    textInputAction: TextInputAction.next,
                    focusNode: formNodes[1],
                    attribute: 'purpose',
                    validators: [],
                    decoration: InputDecoration(labelText: "Purpose"),
                    onFieldSubmitted: (v){
                      FocusScope.of(context).requestFocus(formNodes[2]);
                    },
                  ),
                  FormBuilderTextField(
                    textInputAction: TextInputAction.next,
                    focusNode: formNodes[2],
                    attribute: 'highway',
                    validators: [],
                    decoration: InputDecoration(labelText: "Highway"),
                    onFieldSubmitted: (v){
                      FocusScope.of(context).requestFocus(formNodes[3]);
                    },
                  ),
                  FormBuilderTextField(
                    textInputAction: TextInputAction.next,
                    focusNode: formNodes[3],
                    attribute: 'county',
                    validators: [],
                    decoration: InputDecoration(labelText: "County"),
                    onFieldSubmitted: (v){
                      FocusScope.of(context).requestFocus(formNodes[4]);
                    },
                  ),
                  FormBuilderTextField(
                    textInputAction: TextInputAction.next,
                    focusNode: formNodes[4],
                    attribute: 'northing',
                    validators: [FormBuilderValidators.numeric()],
                    decoration: InputDecoration(
                      labelText: "Northing",),
                    onFieldSubmitted: (v){
                      FocusScope.of(context).requestFocus(formNodes[5]);
                    },
                  ),
                  FormBuilderTextField(
                    textInputAction: TextInputAction.next,
                    focusNode: formNodes[5],
                    attribute: 'easting',
                    validators: [FormBuilderValidators.numeric()],
                    decoration: InputDecoration(
                        labelText: "Easting"),
                    onFieldSubmitted: (v){
                      FocusScope.of(context).requestFocus(formNodes[6]);
                    },
                  ),
                  FormBuilderTextField(
                    textInputAction: TextInputAction.next,
                    focusNode: formNodes[6],
                    attribute: 'equipment',
                    validators: [],
                    decoration: InputDecoration(labelText: "Equipment"),
                    onFieldSubmitted: (v){
                      FocusScope.of(context).requestFocus(formNodes[7]);
                    },
                  ),
                  FormBuilderTextField(
                    textInputAction: TextInputAction.next,
                    focusNode: formNodes[7],
                    attribute: 'driller',
                    validators: [],
                    decoration: InputDecoration(labelText: "Driller"),
                    onFieldSubmitted: (v){
                      FocusScope.of(context).requestFocus(formNodes[8]);
                    },
                  ),
                  FormBuilderTextField(
                    textInputAction: TextInputAction.next,
                    focusNode: formNodes[8],
                    attribute: 'geologist',
                    validators: [],
                    decoration: InputDecoration(labelText: "Project Geologist"),
                    onFieldSubmitted: (v){
                      FocusScope.of(context).requestFocus(formNodes[9]);
                    },
                  ),
                  FormBuilderTextField(
                    textInputAction: TextInputAction.next,
                    focusNode: formNodes[9],
                    attribute: 'recorder',
                    validators: [],
                    decoration: InputDecoration(labelText: "Recorder"),
                    onFieldSubmitted: (v){
                      FocusScope.of(context).requestFocus(formNodes[10]);
                    },
                  ),
                  FormBuilderDateTimePicker(
                    textInputAction: TextInputAction.next,
                    focusNode: formNodes[10],
                    attribute: "start-date",
                    inputType: InputType.date,
                    validators: [],
                    format: DateFormat("dd-MM-yyyy"),
                    decoration: InputDecoration(labelText: "Start Date"),
                    onFieldSubmitted: (v){
                      FocusScope.of(context).requestFocus(formNodes[11]);
                    },
                  ),
                  FormBuilderDateTimePicker(
                    textInputAction: TextInputAction.next,
                    focusNode: formNodes[11],
                    attribute: 'end-date',
                    inputType: InputType.date,
                    validators: [],
                    format: DateFormat('dd-MM-yyyy'),
                    decoration: InputDecoration(labelText: "End Date"),
                    onFieldSubmitted: (v){
                      FocusScope.of(context).requestFocus(formNodes[12]);
                    },
                  ),
                  FormBuilderTextField(
                    textInputAction: TextInputAction.next,
                    focusNode: formNodes[12],
                    attribute: 'ttl-depth',
                    validators: [FormBuilderValidators.numeric()],
                    decoration: InputDecoration(labelText: "Total Depth"),
                    onFieldSubmitted: (v){
                      FocusScope.of(context).requestFocus(formNodes[13]);
                    },
                  ),
                  FormBuilderTextField(
                    textInputAction: TextInputAction.next,
                    focusNode: formNodes[13],
                    attribute: 'elevation',
                    validators: [FormBuilderValidators.numeric()],
                    decoration: InputDecoration(labelText: "Ground Elevation (m)"),
                    onFieldSubmitted: (v){
                      FocusScope.of(context).requestFocus(formNodes[14]);
                    },
                  ),
                  FormBuilderTextField(
                    textInputAction: TextInputAction.next,
                    focusNode: formNodes[14],
                    attribute: 'tube-height',
                    validators: [FormBuilderValidators.numeric()],
                    decoration: InputDecoration(labelText: "Tube Height"),
                    onFieldSubmitted: (v){
                      FocusScope.of(context).requestFocus(formNodes[15]);
                    },
                  ),
                  FormBuilderTextField(
                    textInputAction: TextInputAction.next,
                    focusNode: formNodes[15],
                    attribute: 'hole-no',
                    validators: [FormBuilderValidators.numeric()],
                    decoration: InputDecoration(labelText: "Hole No."),
                    onFieldSubmitted: (v){
                      FocusScope.of(context).requestFocus(formNodes[16]);
                    },
                  ),
                  FormBuilderTextField(
                    textInputAction: TextInputAction.next,
                    focusNode: formNodes[16],
                    attribute: 'ea-no',
                    validators: [FormBuilderValidators.numeric()],
                    decoration: InputDecoration(labelText: "E.A. No."),
                    onFieldSubmitted: (v){
                      FocusScope.of(context).requestFocus(formNodes[17]);
                    },
                  ),
                  FormBuilderTextField(
                    textInputAction: TextInputAction.next,
                    focusNode: formNodes[17],
                    attribute: 'key-no',
                    validators: [FormBuilderValidators.numeric()],
                    decoration: InputDecoration(labelText: "Key No."),
                    onFieldSubmitted: (v){
                      FocusScope.of(context).requestFocus(formNodes[18]);
                    },
                  ),
                  FormBuilderTextField(
                    textInputAction: TextInputAction.next,
                    focusNode: formNodes[18],
                    attribute: 'start-card-no',
                    validators: [FormBuilderValidators.numeric()],
                    decoration: InputDecoration(labelText: "Start Card No."),
                    onFieldSubmitted: (v){
                      FocusScope.of(context).requestFocus(formNodes[19]);
                    },
                  ),
                  FormBuilderTextField(
                    focusNode: formNodes[19],
                    attribute: 'bridge-no',
                    validators: [FormBuilderValidators.numeric()],
                    decoration: InputDecoration(labelText: "Bridge No."),
                  )
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

