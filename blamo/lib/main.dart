import 'package:flutter/material.dart';
import 'package:blamo/Export/index.dart';

//This class will be used to house all the data between each route
class StateData {
  String currentRoute;
  int randomNumber;
  var list = ["Document 1","Document 2","Document 3","Document 4","Document 5","Document 6"];

  StateData(this.currentRoute, [this.randomNumber = 6]);
}

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
/* All pages must take in state data. The Stateful widget sole job
*  is to pass the StateData object to the constructor during the
*  createState() portion. Override for class constructor is needed to
*  assign the variable to be passed.
* */
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

/* Builds the initial page for the user
*  Using Scaffolding to follow a fairly traditional layout for familiarity
*  The drawer needs to house the other pages our team is working on (Settings, Export, etc)
*/
class _HomePageState extends State<HomePage> {
  static const routeName = '/';
  StateData currentState = StateData(routeName);

  @override
  Widget build(BuildContext context) {
    if(ModalRoute.of(context).settings.arguments != null) {
      currentState = ModalRoute
          .of(context)
          .settings
          .arguments;
      currentState.currentRoute = '/'; // Recieves StateData objects from Navbar
    }

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
      drawer: Drawer(
        child:SideMenu(currentState),
      ),
      appBar: new AppBar(
          title: new Text("Home"),
          actions: <Widget>[

          ],
          backgroundColor: Colors.deepOrange
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 2,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: List.generate(currentState.randomNumber + 1, (index) {
          String toReturn;
          int colorVal = index*100;
          if(index >= 9){
            colorVal = 800;
          }
          if(index == 0){
            toReturn = '+';
            return Center(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Text(toReturn),
                color: Colors.deepOrange[colorVal],
              ),);
          } else {
            toReturn = currentState.list[index-1];
          }
          return Container(
            padding: const EdgeInsets.all(8),
            child: Text(toReturn),
            color: Colors.orange[colorVal],
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            SecondPage.routeName,
            arguments: currentState,
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
  static const routeName = '/SecondPage';

  @override
  Widget build(BuildContext context) {
    StateData currentState = ModalRoute.of(context).settings.arguments;
    currentState.currentRoute='/SecondPage';

    final String text = currentState.currentRoute;
    return new Scaffold(
      drawer: new Drawer(),
      appBar: new AppBar(
          title: new Text("Page #2"),
          actions: <Widget>[
          ],
          backgroundColor: Colors.deepOrange
      ),
      body: Center(
          child: Text('$text')
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
      return Container(
        child: new ListView(
          children: <Widget> [
            new UserAccountsDrawerHeader(accountName: null, accountEmail: null,
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage('assets/images/OSU-eng-logo.png')
                )
              ),
            ),
            new ListTile(
              title: new Text("Home"),
              leading: Icon(
                Icons.home,
                color: Colors.blue
              ),
              onTap: () {
                if(currentState.currentRoute != "/"){
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
            Divider(
              color: Colors.black,
            ),
            new ListTile(
              title: new Text("Export"),
              leading: Icon(
                  Icons.import_export,
                  color: Colors.blue
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExportPage()),
                );
              },
            ),
            Divider(),
          ]
        )
      );
  }
}
