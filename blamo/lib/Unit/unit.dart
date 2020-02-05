import 'package:blamo/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:flutter_test/flutter_test.dart';

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

@override
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  Widget build(BuildContext context) {
    if(currentState.currentRoute != null) {
      currentState.currentRoute = '/UnitPage'; //Assigns currentState.currentRoute to the name of the current named route
    }
    return new Scaffold(
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
                  ),
                  FormBuilderTextField(
                    attribute: 'depth-lb',
                    validators: [FormBuilderValidators.numeric()],
                    decoration: InputDecoration(labelText: "Depth Lower Bound (m)")
                  ),
                  FormBuilderCheckboxList( //TODO - redirect to longer comprehensive list of tags? Refactor to a list of autocompleting text fields? (SEE: test.dart, 56)
                    attribute: 'tags',
                    validators: [],
                    initialValue: [],
                    options: [ // TODO need gint's set of tags, ability for user to make own tags.
                      FormBuilderFieldOption(value: "Sandy GRAVEL (Shoulder Aggregate)"),
                      FormBuilderFieldOption(value: "GP"),
                      FormBuilderFieldOption(value: "Varlegated Gray"),
                      FormBuilderFieldOption(value: "Nonplastic"),
                      FormBuilderFieldOption(value: "Moist"),
                      FormBuilderFieldOption(value: "(FILL)")
                    ],
                  ),
                  FormBuilderTextField(
                    attribute: 'methods',
                    validators: [],
                    decoration: InputDecoration(labelText: "Drilling Methods"),
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

