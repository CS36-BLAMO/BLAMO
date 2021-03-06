import 'package:flutter/material.dart';

import 'package:blamo/Boreholes/BoreholeList.dart';

//Side menu class that creates the side menu state
class SideMenu extends StatefulWidget {
  final StateData pass;
  SideMenu(this.pass, {Key key}) : super(key:key);

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
                      currentState.currentProject = "";
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
                  key: Key('homeNav'),
                ),
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
                    if (currentState.currentRoute == '/LogInfoPage') {
                      showDialog(
                        context: context,
                        builder: (context) =>
                        AlertDialog(
                          title: Text(
                              "Are you sure you want to leave this page?\n\nAll unsaved data will be discarded.",
                            style: TextStyle(
                              fontSize: 20,
                            ),),
                          actions: <Widget>[
                            FlatButton(
                              child: Text(
                                "Yes",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.red,
                                ),
                              ),
                              onPressed: () {
                                currentState.currentRoute = '/';
                                currentState.currentDocument = "";
                                Navigator.pushReplacementNamed(
                                  context,
                                  "/",
                                  arguments: currentState,
                                );
                              }
                            ),
                            FlatButton(
                              child: Text(
                                "No",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              onPressed: () => Navigator.pop(context, false),
                            ),
                          ]
                        )
                      );
                    } else if (currentState.currentRoute != '/') {
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
                    if (currentState.currentRoute == '/LogInfoPage') {
                      showDialog(
                        context: context,
                        builder: (context) =>
                        AlertDialog(
                          title: Text(
                              "Are you sure you want to leave this page?\n\nAll unsaved data will be discarded.",
                            style: TextStyle(
                              fontSize: 20,
                            ),),
                          actions: <Widget>[
                            FlatButton(
                              child: Text(
                                "Yes",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.red,
                                ),
                              ),
                              onPressed: () {
                                currentState.currentRoute = '/ExportPage';
                                Navigator.pushReplacementNamed(
                                  context,
                                  "/ExportPage",
                                  arguments: currentState,
                                );
                              }
                            ),
                            FlatButton(
                              child: Text(
                                "No",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              onPressed: () => Navigator.pop(context, false),
                            ),
                          ]
                        )
                      );
                    } else if (currentState.currentRoute != '/ExportPage') {
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
                  key: Key('exportNav'),
                ),
                Divider(color: Colors.grey),
                new ListTile(
                  title: new Text("Borehole List"),
                  leading: Icon(
                      Icons.list,
                      color: Colors.blue
                  ),
                  onTap: () {
                    if (currentState.currentRoute == '/LogInfoPage') {
                      showDialog(
                          context: context,
                          builder: (context) =>
                              AlertDialog(
                                  title: Text(
                                      "Are you sure you want to leave this page?\n\nAll unsaved data will be discarded.",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text(
                                        "Yes",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.red,
                                        ),
                                      ),
                                      onPressed: () {
                                        currentState.currentRoute = '/BoreholeList';
                                        currentState.currentDocument="";
                                        Navigator.pushReplacementNamed(
                                          context,
                                          "/BoreholeList",
                                          arguments: currentState,
                                        );
                                      }
                                    ),
                                    FlatButton(
                                      child: Text(
                                        "No",
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                      onPressed: () => Navigator.pop(context, false),
                                    ),
                                  ]
                              )
                      );
                    } else if (currentState.currentRoute != '/BoreholeList') {
                      currentState.currentRoute = '/BoreholeList';
                      currentState.currentDocument="";
                      Navigator.pushReplacementNamed(
                        context,
                        "/BoreholeList",
                        arguments: currentState,
                      );
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  key: Key('boreholeListNav'),
                ),
                Divider(color: Colors.grey),
                new ListTile(
                  title: new Text("Overview"),
                  leading: Icon(
                      Icons.pageview,
                      color: Colors.blue
                  ),
                  onTap: () {
                    if (currentState.currentRoute == '/LogInfoPage') {
                      showDialog(
                          context: context,
                          builder: (context) =>
                              AlertDialog(
                                  title: Text(
                                      "Are you sure you want to leave this page?\n\nAll unsaved data will be discarded.",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text(
                                        "Yes",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.red,
                                        ),
                                      ),
                                      onPressed: () {
                                        currentState.currentRoute = '/Document';
                                        Navigator.pushReplacementNamed(
                                          context,
                                          "/Document",
                                          arguments: currentState,
                                        );
                                      }
                                    ),
                                    FlatButton(
                                      child: Text(
                                        "No",
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                      onPressed: () => Navigator.pop(context, false),
                                    ),
                                  ]
                              )
                      );
                    } else if (currentState.currentRoute != '/Document') {
                      currentState.currentRoute = '/Document';
                      Navigator.pushReplacementNamed(
                        context,
                        "/Document",
                        arguments: currentState,
                      );
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  key: Key('overviewNav'),
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
                  },
                  key: Key('loginfoNav'),
                ),
                Divider(color: Colors.grey),
                new ListTile(
                  title: new Text("Units"),
                  leading: Icon(
                      Icons.assessment,
                      color: Colors.blue
                  ),
                  onTap: () {
                    if (currentState.currentRoute == '/LogInfoPage') {
                      showDialog(
                          context: context,
                          builder: (context) =>
                              AlertDialog(
                                  title: Text(
                                      "Are you sure you want to leave this page?\n\nAll unsaved data will be discarded.",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text(
                                        "Yes",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.red,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pushReplacementNamed(
                                          context,
                                          "/UnitsPage",
                                          arguments: currentState,
                                        );
                                      }
                                    ),
                                    FlatButton(
                                      child: Text(
                                        "No",
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                      onPressed: () => Navigator.pop(context, false),
                                    ),
                                  ]
                              )
                      );
                    } else if (currentState.currentRoute != '/UnitsPage') {
                      Navigator.pushReplacementNamed(
                        context,
                        "/UnitsPage",
                        arguments: currentState,
                      );
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  key: Key('unitsNav'),
                ),
                Divider(color: Colors.grey[900]),
                new ListTile(
                  title: new Text("Tests"),
                  leading: Icon(
                      Icons.assignment,
                      color: Colors.blue
                  ),
                  onTap: () {
                    if (currentState.currentRoute == '/LogInfoPage') {
                      showDialog(
                          context: context,
                          builder: (context) =>
                              AlertDialog(
                                  title: Text(
                                      "Are you sure you want to leave this page?\n\nAll unsaved data will be discarded.",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text(
                                        "Yes",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.red,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pushReplacementNamed(
                                          context,
                                          "/TestsPage",
                                          arguments: currentState,
                                        );
                                      }
                                    ),
                                    FlatButton(
                                      child: Text(
                                        "No",
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                      onPressed: () => Navigator.pop(context, false),
                                    ),
                                  ]
                              )
                      );
                    } else if (currentState.currentRoute != '/TestsPage') {
                      Navigator.pushReplacementNamed(
                        context,
                        "/TestsPage",
                        arguments: currentState,
                      );
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  key: Key('testsNav'),
                ),
                Divider(color: Colors.grey[900]),
              ]
          )
      );
    }
  }
}