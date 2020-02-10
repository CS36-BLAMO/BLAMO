import 'package:blamo/routeGenerator.dart';
import 'package:flutter/material.dart';
import 'package:blamo/FileHandler.dart';

//This class will be used to house all the data between each route
class StateData {
  String currentRoute;
  int randomNumber;
  var list = [""];

  StateData(this.currentRoute, [this.randomNumber = 0]);

}

 /* the idea behind the home page is a series of existing logs will appear in the white space, While the button in 
  * the bottom right will allow users to create a new log 
  * (the "second page" in this code is mostly a demonstration and can/should be removed in later implimentation) additionally, 
  * the drawer will provide easy familiar navigation between setting, export, etc. Activities/pages of the project
  */
void main() => runApp(BLAMO());

/* This builds the initial context and offloads
*  route navigation to the routeGenerator class
*/
class BLAMO extends StatelessWidget {


  @override
  Widget build(BuildContext context){
    return MaterialApp(
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

/* All pages must take in state data. The Stateful widget sole job
*  is to pass the StateData object to the constructor during the
*  createState() portion. Override for class constructor is needed to
*  assign the variable to be passed.
* */
class HomePage extends StatefulWidget {
  StateData pass;
  final PersistentStorage storage = PersistentStorage();
  HomePage(this.pass);

  @override
  _HomePageState createState() => _HomePageState(pass);
}

/* Builds the initial page for the user
*  Using Scaffolding to follow a fairly traditional layout for familiarity
*  The drawer needs to house the other pages our team is working on (Settings, Export, etc)
*/
class _HomePageState extends State<HomePage> {
  final routeName = '/';
  StateData currentState;

  _HomePageState(this.currentState);

  @override
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if(currentState != null) {
      currentState.currentRoute='/';//Assigns currentState.currentRoute to the name of the current named route
    }

    widget.storage.checkForManifest().then((bool doesManifestExist) {
      if(doesManifestExist){
        widget.storage.readManifest().then((String toWrite) {
          debugPrint(toWrite);
        });
      } else {
        widget.storage.overWriteManifest("Document1, Document2, Document3,");
        debugPrint("Written to the file, have a good one!");
      }
    });

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
      drawer: new Drawer(
        //child: SideMenu()
      ),
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
            Divider(color: Colors.grey),
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
            Divider(color: Colors.grey),
            new ListTile(
              title: new Text("Export"),
              leading: Icon(
                  Icons.import_export,
                  color: Colors.blue
              ),
              onTap: () {
                if(currentState.currentRoute != "/ExportPage"){
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
            Divider( color: Colors.grey),
            new ListTile(
              title: new Text("Log Info"),
              leading: Icon(
                Icons.info,
                color: Colors.blue
              ),
              onTap: () {
                if(currentState.currentRoute != "/LogInfoPage"){
                    Navigator.pushReplacementNamed(
                      context,
                      "/LogInfoPage",
                      arguments: currentState,
                    );
                  } else {
                    Navigator.pop(context);
                  }
              }),
            Divider(color: Colors.grey[900]),
            new ListTile(
              title: new Text("Unit X Info"),
              leading: Icon(
                Icons.assessment,
                color: Colors.blue
              ),
              onTap: () {
                if(currentState.currentRoute != "/UnitPage"){
                    Navigator.pushReplacementNamed(
                      context,
                      "/UnitPage",
                      arguments: currentState,
                    );
                  } else {
                    Navigator.pop(context);
                  }
              }),
            Divider(color: Colors.grey),
            new ListTile(
              title: new Text("Test X"),
              leading: Icon(
                Icons.assignment,
                color: Colors.blue
              ),
              onTap: () {
                if(currentState.currentRoute != "/TestPage"){
                    Navigator.pushReplacementNamed(
                      context,
                      "/TestPage",
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
                if(currentState.currentRoute != "/SettingsPage"){
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
