import 'package:blamo/main.dart';
import 'package:flutter/material.dart';
import 'package:blamo/Export/pdf_builder.dart';

/*This page will serve as a manual export option all different avenues
 * Only email and Box at the moment for placeholder but can be expanded to others
 * Each page will live in its own dir for proper file structure.
 */

class ExportPage extends StatefulWidget {
  StateData pass; //Passes the StateData object to the stateful constructor

  ExportPage(this.pass);

  @override
  _ExportPageState createState() => _ExportPageState(pass);
}

// Basic structure for title and skeleton for expanded page
class _ExportPageState extends State<ExportPage> {
  final routeName = '/ExportPage';
  StateData currentState;

  _ExportPageState(this.currentState);


  @override
  Widget build(BuildContext context) {
    if(currentState.currentRoute != null) {
      currentState.currentRoute = '/ExportPage'; //Assigns currentState.currentRoute to the name of the current named route
    }

    return new Scaffold(
      drawer: new Drawer(
         child: SideMenu(currentState),
      ),
      appBar: new AppBar(
          title: new Text("Export"),
          actions: <Widget>[
          ],
          backgroundColor: Colors.deepOrangeAccent
      ),
      body: Center(
        child: Center(child:_exportList()),
      ),
    );
  }
}
//
Widget _exportList() => ListView(
  children: [
    Center(child:_tile('Email',Icons.email)),
    Divider(),
    Center(child:_tile('Box',Icons.cloud_upload)),
    Divider(),
    Center(child:_pdfTile('PDF',Icons.picture_as_pdf))
  ],
);

//Individual ListView item formatting with passed in icon and export to string
ListTile _tile(String destination, IconData icon) => ListTile(
  title: Text(destination,
      style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize:25
      )),
  leading: Padding(
    padding: const EdgeInsets.all(20.0),
    child: Icon(
      icon,
      color: Colors.blue,
    ),
  ),
);


ListTile _pdfTile(String destination, IconData icon) => ListTile(
  title: Text(destination,
      style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize:25
      )),
  leading: Padding(
    padding: const EdgeInsets.all(20.0),
    child: Icon(
      icon,
      color: Colors.blue,
    ),
  ),
  onTap: () {docCreate();}
);
//TODO Add functionality for onclick to grab CSV and email, text popup for email to send to
//TODO cloud save to Box(Both form AND CSV?)