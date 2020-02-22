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
                    attribute: 'type-no',
                    validators: [],
                    decoration: InputDecoration(labelText: "Test Type And Number"),
                  ),
                  FormBuilderTextField(
                    attribute: 'tst-depth-ub',
                    validators: [FormBuilderValidators.numeric()],
                    decoration: InputDecoration(labelText: "Depth Upper Bound (m)"),
                  ),
                  FormBuilderTextField(
                      attribute: 'tst-depth-lb',
                      validators: [FormBuilderValidators.numeric()],
                      decoration: InputDecoration(labelText: "Depth Lower Bound (m)")
                  ),
                  FormBuilderTextField(
                    attribute: 'recovery-%',
                    validators: [FormBuilderValidators.numeric()],
                    decoration: InputDecoration(labelText: "Percent Recovery"),
                  ),
                  FormBuilderTextField(
                    attribute: 'sdr-rdd-rqd',
                    validators: [],
                    decoration: InputDecoration(labelText: "Soil Driving Resistance / Rock Discontinuity Data or RQD"), //ASK - preferred title?
                  ),
                  FormBuilderTextField(
                    attribute: 'prcnt-moisture',
                    validators: [],
                    decoration: InputDecoration(labelText: "Percent Natural Moisture"),
                  ),
                  FormBuilderTextField(
                    attribute: 'user-material-desc',
                    validators: [],
                    decoration: InputDecoration(labelText: "Material Description"),
                  ),
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
