import 'package:flutter/material.dart';
import 'package:blamo/Export/index.dart';

 /* the idea behind the home page is a series of existing logs will appear in the white space, While the button in 
  * the bottom right will allow users to create a new log 
  * (the "second page" in this code is mostly a demonstration and can/should be removed in later implimentation) additionally, 
  * the drawer will provide easy familiar navigation between setting, export, etc. Activities/pages of the project
  */
void main() {
  runApp(new MaterialApp(
      home: new HomePage(),
      routes: <String, WidgetBuilder> {
        "/SecondPage": (BuildContext context) => new SecondPage(),
        "/ExportPage": (BuildContext context) => new ExportPage()
      }
  ));
}

/* Builds the initial page for the user
*  Using Scaffolding to follow a fairly traditional layout for familiarity
*  The drawer needs to house the other pages our team is working on (Settings, Export, etc)
*/
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /* Scaffolding constructor is as follows, and can be filled out of order using the precursor of
    
    * X: new Y(),
    *
    * Scaffold(key, appBar, Widget body, Widget floatingActionButton, FloatingActionButtonLocation
    * floatingActionButtonLocation, FloatingActionButtonAnimator floatingActionButtonAnimator,
    * List<Widget> persistentFooterButtons, Widget drawer, Widget endDrawer,
    * Widget bottomNavigationBar, Widget bottomSheet, Color backgroundColor,
    * bool resizeToAvoidBottomPadding, bool resizeToAvoidBottomInset, bool primary: true,
    * DragStartBehavior drawerDragStartBehavior: DragStartBehavior.start,
    * bool extendBody: false, bool extendBodyBehindAppBar: false, Color drawerScrimColor,
    * double drawerEdgeDragWidth )
    *
    * */
    return new Scaffold(
        drawer: new Drawer(
          child: new ListView(
            children: <Widget> [
              new UserAccountsDrawerHeader(
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: new AssetImage('assets/images/OSU-eng-logo.png')
                    )
                  ),
              ),
              new ListTile(
                title: new Text("Home"),
                leading: Icon(
                  Icons.home,
                  color: Colors.blue
                )
              ),
              Divider(),
              new ListTile(
                title: new Text("Export"),
                leading: Icon(
                  Icons.import_export,
                  color: Colors.blue
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ExportPage()),
                  );
                },
              ),
              Divider()
            ]
          )
        ),
        appBar: new AppBar(
            title: new Text("Home"),
            actions: <Widget>[
            ],
            backgroundColor: Colors.deepOrange
        ),
        body: Center(
           child: Text("COWBOY BEAN BOWL")
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ExportPage()),
            );
          },
          child: Icon(Icons.create),
          backgroundColor: Colors.amber,
        ),

    );
  }
}

/* This is where Users will be creating and filling out documents for logging
* This second page will house the text fields and (presumably) imaging options
*/
class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: new Drawer(),
      appBar: new AppBar(
          title: new Text("Page #2"),
          actions: <Widget>[

          ],
          backgroundColor: Colors.deepOrange
      ),
      body: Center(
          child: Text("SEE YOU LATER SPACE COWBOY")
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.create),
        backgroundColor: Colors.amber,
      ),

    );
  }
}
