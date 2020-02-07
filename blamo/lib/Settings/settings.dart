import 'package:blamo/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


/*This page will serve as a manual export option all different avenues
 * Only email and Box at the moment for placeholder but can be expanded to others
 * Each page will live in its own dir for proper file structure.
 */
class SettingsPage extends StatefulWidget {
  StateData pass; //Passes the StateData object to the stateful constructor

  SettingsPage(this.pass);
  @override
  _SettingsPageState createState() => _SettingsPageState(pass);
}

// Basic structure for title and skeleton for expanded page
class _SettingsPageState extends State<SettingsPage> {
  final routeName = '/SettingsPage';
  StateData currentState;
  _SettingsPageState(this.currentState);

  @override
  Widget build(BuildContext context) {
    if(currentState.currentRoute != null) {
      currentState.currentRoute = '/SettingsPage'; //Assigns currentState.currentRoute to the name of the current named route
    }
    return new Scaffold(
      backgroundColor: Colors.grey[300],
      drawer: new Drawer(
        child: SideMenu(currentState),
      ),
      appBar: new AppBar(
          title: new Text("Settings"),
          actions: <Widget>[
          ],
          backgroundColor: Colors.grey[800],
      ),
      body:
       _settingsList(),
       );
  }
}
// List of Boxes that are customizeable, we can parameterize the values and change the colors and indicate the allotment of changing these.
// When hooked up to the persistent saved data it can change those values.Each Card can have 3 ListTiles in it
Widget _settingsList() => ListView(
  children: [
    _tileBoxProfile('Profile'),
    _tileBoxStorage('Storage'),
    _tileBoxBox('Box Configuration'),
  ],
);

SizedBox _tileBoxProfile(String settingName) => SizedBox(
    height: 80,
    child: Card(
      child: Column(
        children: [
          ListTile(
            title: Text(settingName,
              style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
            subtitle: Text('Current User: PLACEHOLDER\nCurrent Email: PLACEHOLDER@gmail.com'),
            leading: Icon(
              Icons.person,
              color: Colors.grey[800],
            )
          )
        ]
      )
    )
);
SizedBox _tileBoxBox(String settingName) => SizedBox(
    height: 80,
    child: Card(
        child: Column(
            children: [
              ListTile(
                  title: Text(settingName,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                  subtitle: Text('Current Account: Box@Box.box\nRecent Cloud save: 12:22 01/01/2020'),
                  leading: Icon(
                    Icons.cloud,
                    color: Colors.grey[800],
                  )
              )
            ]
        )
    )
);
SizedBox _tileBoxStorage(String settingName) => SizedBox(
    height: 80,
    child: Card(
        child: Column(
            children: [
              ListTile(
                  title: Text(settingName,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                  subtitle: Text('Storage capacity: 99%\nRecently saved file: 9:20pm 02/20/20'),
                  leading: Icon(
                    Icons.folder,
                    color: Colors.grey[800],
                  ),
              )
            ]
        )
    )
);

//TODO parameterize settings to pull from global object
//TODO ON tap of each setting being able to change parameters