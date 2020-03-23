import 'package:blamo/Export/CSVExporter.dart';
import 'package:blamo/main.dart';
import 'package:flutter/material.dart';
import 'package:blamo/PDF/pdf_builder.dart';
import 'package:blamo/SideMenu.dart';
import 'package:blamo/CustomActionBar.dart';
import 'email.dart';

/*This page will serve as a manual export option all different avenues
 * Only email and Box at the moment for placeholder but can be expanded to others
 * Each page will live in its own dir for proper file structure.
 */

class ExportPage extends StatefulWidget {
  final StateData pass; //Passes the StateData object to the stateful constructor

  ExportPage(this.pass);

  @override
  _ExportPageState createState() => _ExportPageState(pass);
}

// Basic structure for title and skeleton for expanded page
class _ExportPageState extends State<ExportPage> {
  final routeName = '/ExportPage';
  StateData currentState;
  //Creating structured list of output types
  List<String> docTypes = ['csv','pdf'];
  //parameters to pass to emailer
  String pickedDoc /*TODO= null*/;
  String pickedDocType /*= null*/;
  List<String>curDoc = [];

  _ExportPageState(this.currentState);


  @override
  Widget build(BuildContext context) {

    if (currentState.currentRoute != null) {
      currentState.currentRoute =
      '/ExportPage'; //Assigns currentState.currentRoute to the name of the current named route
    }

    //Temp fix for emailer to force doc
    curDoc.add(currentState.currentDocument);

    return new Scaffold(
      drawer: new Drawer(
        child: SideMenu(currentState),
      ),
      appBar: CustomActionBar("Export").getAppBar(),
      body: Center(
        child: Center(child:_exportList(currentState,pickedDoc)),
      ),
    );
  }

  Widget _exportList(StateData currentState,String pickedPath) => ListView(
    children: [
      Center(child:_tile('Box',Icons.cloud_upload)),
      Divider(),
      Center(child:_pdfTile('Save ' + currentState.currentDocument + ' as PDF', Icons.picture_as_pdf)),
      Divider(),
      Center(child:_csvTile('Save ' + currentState.currentDocument + ' as CSV',Icons.pie_chart)),
      Divider(),
      SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              new Column(
                  children: <Widget>[
                    new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          //new Text(
                          //    currentState.currentDocument,
                          //    style: TextStyle(fontSize: 25)
                          //),
                          new DropdownButtonHideUnderline(
                              child: DropdownButton(
                                  hint: Text('Select Document'),
                                  value: pickedDoc,
                                  items:
                                  currentState.list.map((String value) {
                                    //print("Value from List of strings " + value);
                                    return new DropdownMenuItem(
                                      value: value,
                                      child: new Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String value){
                                    //Will be needed in future
                                    setState(() {
                                      pickedDoc = value;
                                    });
                                  }
                              )
                          ),
                          const SizedBox(width:20),
                          new DropdownButtonHideUnderline(
                              child: DropdownButton(
                                  hint: Text(
                                      'Select Format',
                                      style: TextStyle(fontSize: 20)
                                  ),
                                  value: pickedDocType,
                                  items:
                                  docTypes.map((String value) {
                                    //print("Value from List of strings " + value);
                                    return new DropdownMenuItem(
                                      value: value,
                                      child: new Text(
                                          value,
                                          style: TextStyle(fontSize: 20)
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String value){
                                    setState(() {
                                      pickedDocType = value;
                                    });
                                  }
                              )
                          )
                        ]
                    ),
                    new RaisedButton(
                      onPressed: (){
                        print("Pressing send email");
                        sendEmail(pickedDoc, pickedDocType);
                      },
                      textColor: Colors.white,
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              Color(0xFF0D47A1),
                              Color(0xFF1976D2),
                              Color(0xFF42A5F5),
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.all(7.5),
                        child: const Text(
                            'Send Email',
                            style: TextStyle(fontSize: 20)
                        ),
                      ),
                    )
                  ]
              ),
            ],
          )
      )
    ],
  );

//Individual ListView item formatting with passed in icon and export to string
  ListTile _tile(String destination, IconData icon) => ListTile(
    title: Text(destination,
        style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize:20
        )),
    leading: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Icon(
        icon,
        color: Colors.blue,
      ),
    ),
  );

  ListTile _csvTile(String destination, IconData icon) => ListTile(
    title: Text(destination,
        style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize:20
        )),
    leading: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Icon(
        icon,
        color: Colors.blue,
      ),
    ),
    onTap: () {
      CSVExporter csvExporter = new CSVExporter(currentState);
      //--DEBUG includes dubugging prints
      //csvExporter.testStuff();
      csvExporter.exportToCSV();
    },
  );

  ListTile _emailTile(String destination, IconData icon, BuildContext context,
      String pickedPath) =>
      ListTile(
          title: Text(destination,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20
              )),
          leading: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Icon(
              icon,
              color: Colors.blue,
            ),
          ),
          onTap: () {
            debugPrint("Tapping Email Button with pickedDoc:");
            //sendEmail();
            //await emailer.pickFile().then((onValue) async {
            //  print("in .then with value: $onValue");
            //  await emailer.sendEmail();
            //});
          }
      );

  ListTile _pdfTile(String destination, IconData icon) => ListTile(
      title: Text(destination,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize:20
          )),
      leading: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Icon(
          icon,
          color: Colors.blue,
        ),
      ),
      onTap: () {docCreate(currentState);}
  );
}

//TODO cloud save to Box -- Maybe can "trick" Action Share to do Box export