import 'package:blamo/main.dart';
import 'package:flutter/material.dart';

//Side menu class that creates the side menu state
class SideMenu extends StatefulWidget {
  final StateData pass;
  SideMenu(this.pass);

  @override
  _SideMenuState createState() => _SideMenuState(pass);
}

// Side menu nav list state. Container of a ListView that lays out the different pages that can be accessed
// If you want to add a page just insert your own ListTile under the divider. Navigator.push is on click redirect to page you want
class _SideMenuState extends State<SideMenu> {
  StateData currentState;

  _SideMenuState(this.currentState);
  @override
  Widget build(BuildContext context) {
    if(currentState.currentDocument == ""){
      return Container(
          child: new ListView(
              children: <Widget>[
                new UserAccountsDrawerHeader(
                  accountName: null, accountEmail: null,
                  decoration: new BoxDecoration(
                      image: new DecorationImage(
                          image: new AssetImage(
                              'assets/images/OSU-eng-logo.png',)
                      )
                  ),
                ),
                Divider(color: Colors.grey),
                new ListTile(
                  title: new Text("Home"),
                  leading: Icon(
                      Icons.home,
                      color: Colors.blue
                  ),
                  onTap: () {
                    if (currentState.currentRoute != '/') {
                      currentState.currentRoute = '/';
                      currentState.currentDocument = "";
                      Navigator.pushReplacementNamed(
                        context,
                        "/",
                        arguments: currentState,
                      );
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
                Divider(color: Colors.grey),
                new ListTile(
                    title: new Text("Settings"),
                    leading: Icon(
                        Icons.settings,
                        color: Colors.blue
                    ),
                    onTap: () {
                      if (currentState.currentRoute != '/SettingsPage') {
                        Navigator.pushReplacementNamed(
                          context,
                          "/SettingsPage",
                          arguments: currentState,
                        );
                      } else {
                        Navigator.pop(context);
                      }
                    }),
                Divider(color: Colors.grey),
              ]
          )
      );
    } else {
      return Container(
          child: new ListView(
              children: <Widget>[
                new UserAccountsDrawerHeader(
                  accountName: null, accountEmail: null,
                  decoration: new BoxDecoration(
                      image: new DecorationImage(
                          image: new AssetImage(
                              'assets/images/OSU-eng-logo.png')
                      )
                  ),
                ),
                Divider(color: Colors.grey),
                new ListTile(
                  title: new Text("Home"),
                  leading: Icon(
                      Icons.home,
                      color: Colors.blue
                  ),
                  onTap: () {
                    if (currentState.currentRoute != '/') {
                      currentState.currentRoute = '/';
                      currentState.currentDocument = "";
                      Navigator.pushReplacementNamed(
                        context,
                        "/",
                        arguments: currentState,
                      );
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
                Divider(color: Colors.grey),
                new ListTile(
                  title: new Text("Export"),
                  leading: Icon(
                      Icons.import_export,
                      color: Colors.blue
                  ),
                  onTap: () {
                    if (currentState.currentRoute != '/ExportPage') {
                      currentState.currentRoute = '/ExportPage';
                      Navigator.pushReplacementNamed(
                        context,
                        "/ExportPage",
                        arguments: currentState,
                      );
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
                Divider(color: Colors.grey),
                new ListTile(
                    title: new Text("Log Info"),
                    leading: Icon(
                        Icons.info,
                        color: Colors.blue
                    ),
                    onTap: () {
                      if (currentState.currentRoute != '/LogInfoPage') {
                        Navigator.pushReplacementNamed(
                          context,
                          "/LogInfoPage",
                          arguments: currentState,
                        );
                      } else {
                        Navigator.pop(context);
                      }
                    }),
                Divider(color: Colors.grey),
                new ListTile(
                    title: new Text("Units"),
                    leading: Icon(
                        Icons.assessment,
                        color: Colors.blue
                    ),
                    onTap: () {
                      if (currentState.currentRoute != '/UnitsPage') {
                        Navigator.pushReplacementNamed(
                          context,
                          "/UnitsPage",
                          arguments: currentState,
                        );
                      } else {
                        Navigator.pop(context);
                      }
                    }),
                Divider(color: Colors.grey[900]),
                new ListTile(
                    title: new Text("Tests"),
                    leading: Icon(
                        Icons.assignment,
                        color: Colors.blue
                    ),
                    onTap: () {
                      if (currentState.currentRoute != '/TestsPage') {
                        Navigator.pushReplacementNamed(
                          context,
                          "/TestsPage",
                          arguments: currentState,
                        );
                      } else {
                        Navigator.pop(context);
                      }
                    }),
                Divider(color: Colors.grey),
                new ListTile(
                    title: new Text("Settings"),
                    leading: Icon(
                        Icons.settings,
                        color: Colors.blue
                    ),
                    onTap: () {
                      if (currentState.currentRoute != '/SettingsPage') {
                        currentState.currentDocument = "";
                        Navigator.pushReplacementNamed(
                          context,
                          "/SettingsPage",
                          arguments: currentState,
                        );
                      } else {
                        Navigator.pop(context);
                      }
                    }),
                Divider(color: Colors.grey),
              ]
          )
      );
    }
  }
}