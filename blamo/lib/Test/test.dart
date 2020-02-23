import 'package:blamo/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:flutter_test/flutter_test.dart';

class TestPage extends StatefulWidget {
  StateData pass; //Passes the StateData object to the stateful constructor

  TestPage(this.pass);
  @override
  _TestPageState createState() => new _TestPageState(pass);
}

class _TestPageState extends State<TestPage> {
  final routeName = '/TestPage';
  StateData currentState;
  _TestPageState(this.currentState);

  @override
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  Widget build(BuildContext context) {
    if(currentState.currentRoute != null) {
      currentState.currentRoute = '/TestPage'; //Assigns currentState.currentRoute to the name of the current named route
    }
    return new Scaffold(
        backgroundColor: Colors.white,
        drawer: new Drawer(
        child: SideMenu(currentState),
      ),
        appBar: new AppBar(
            title: new Text("Test Page"),
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
                  ),
                  FormBuilderTextField(
                      attribute: 'endTestDepth',
                      validators: [FormBuilderValidators.numeric()],
                      decoration: InputDecoration(labelText: "End Test Depth (m)")
                  ),
                  FormBuilderTextField(
                    attribute: 'soilType',
                    validators: [],
                    decoration: InputDecoration(labelText: "Soil Type"), //ASK - preferred title?
                  ),
                  FormBuilderTextField(
                    attribute: 'description',
                    validators: [],
                    decoration: InputDecoration(labelText: "Description"),
                  ),
                  FormBuilderTextField(
                    attribute: 'moistureContent',
                    validators: [FormBuilderValidators.numeric()],
                    decoration: InputDecoration(labelText: "Moisture Content (%)"),
                  ),
                  FormBuilderTextField(
                    attribute: 'dryDensity',
                    validators: [],
                    decoration: InputDecoration(labelText: "Dry Density (pcf)"),
                  ),
                  FormBuilderTextField(
                    attribute: 'liquidLimit',
                    validators: [FormBuilderValidators.numeric()],
                    decoration: InputDecoration(labelText: "Liquid Limit (%)"),
                  ),
                  FormBuilderTextField(
                    attribute: 'plasticLimit',
                    validators: [FormBuilderValidators.numeric()],
                    decoration: InputDecoration(labelText: "Plastic Limit (%)"),
                  ),
                  FormBuilderTextField(
                    attribute: 'fines',
                    validators: [FormBuilderValidators.numeric()],
                    decoration: InputDecoration(labelText: "Fines (%)"),
                  ),
                  FormBuilderTextField(
                    attribute: 'blows1',
                    validators: [FormBuilderValidators.numeric()],
                    decoration: InputDecoration(labelText: "Blows 1st"),
                  ),
                  FormBuilderTextField(
                    attribute: 'blows2',
                    validators: [FormBuilderValidators.numeric()],
                    decoration: InputDecoration(labelText: "Blows 2nd"),
                  ),
                  FormBuilderTextField(
                    attribute: 'blows3',
                    validators: [FormBuilderValidators.numeric()],
                    decoration: InputDecoration(labelText: "Blows 3rd"),
                  ),
                  FormBuilderTextField(
                    attribute: 'blowCount',
                    validators: [FormBuilderValidators.numeric()],
                    decoration: InputDecoration(labelText: "Blow Count"),
                  ),
                 /*
                  FormBuilderCheckboxList( //TODO - redirect to longer comprehensive list of tags? Refactor to a list of autocompleting text fields? (SEE: unit.dart, 51)
                    attribute: 'material-description',
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
                  )*/
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
