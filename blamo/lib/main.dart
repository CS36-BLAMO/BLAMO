import 'package:blamo/routeGenerator.dart';
import 'package:flutter/material.dart';
import 'package:blamo/File_IO/FileHandler.dart';


//This class will be used to house all the data between each route
class StateData {
  String currentRoute;
  int randomNumber;
  int dirty;
  List<String> list = [""];

  StateData(this.currentRoute, [this.randomNumber = 0]){
    this.dirty = 1;
  }

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
  void initState() {
    super.initState();
    widget.storage.setStateData(currentState).then((StateData recieved) {
      setState(() {
        currentState.list = recieved.list;
        currentState.randomNumber = recieved.randomNumber;
        currentState.currentRoute = '/';
        currentState.dirty = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentState != null) {
      currentState.currentRoute = '/'; //Assigns currentState.currentRoute to the name of the current named route
      //---debug
      //debugPrint(currentState.currentRoute);
    }

    widget.storage.checkForManifest().then((bool doesManifestExist) {
      if (doesManifestExist && currentState.dirty == 1) {
        upDateStateData(0);
      } else if(!doesManifestExist){
        widget.storage.overWriteManifest("");
        //---debug
        //debugPrint("Written to the file, have a good one!");
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
        child: SideMenu(currentState),
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
        children: List.generate(widget.pass.list.length - 1, (index) {
          String toReturn;
          int colorVal = (index+1) * 100;
          if (index >= 9) {
            colorVal = 800;
          }
          toReturn = currentState.list[index];
          return new InkResponse(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Center(
                    child: Text(toReturn,
                    textAlign: TextAlign.center,
                  )
            ),
            color: Colors.orange[colorVal],
          ),
          enableFeedback: true,
          onTap: () => _onTileClicked(index));
        }),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          int i;
          String toWrite = '';
          int newestDoc;
          if(widget.pass.randomNumber == 0){
            toWrite = "Document0,";
            newestDoc = 0;
          }else {
            for (i = 0; i < widget.pass.randomNumber - 1; i++) {
              toWrite = toWrite + widget.pass.list[i] + ',';
            }
            toWrite = toWrite + "Document$i,";
            newestDoc = i;
          }

          /*
          //---DubugUsed for debugging prints out the new document contents, and actual doc contents
          widget.storage.readManifest().then((String read) {
            debugPrint("Current file string:"+read);
          });
          debugPrint("toWrite is:" + toWrite);
          //widget.storage.overWriteManifest("");
          */

          widget.storage.overWriteManifest(toWrite).then((Empty){
            upDateStateData(newestDoc);
          });
        },
        child: Icon(Icons.create),
        backgroundColor: Colors.amber,
      ),

    );
  }

  //Creates a new document manifest
  void createNewDocument(int docIteration) async{
    await widget.storage.overWriteDocument(docIteration, "DocumentNumber: $docIteration\n");
  }

  //Updates the currentState object to reflect the manifest document
  void upDateStateData(int num) async{
    await widget.storage.setStateData(currentState).then((StateData recieved) {
      currentState.list = recieved.list;
      currentState.randomNumber = recieved.randomNumber;
      currentState.dirty = 0;
      setState((){});
    });
    createNewDocument(num);
  }

  void _onTileClicked(int index){
    debugPrint("Clicked on $index");
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
                if(widget.pass.currentRoute != '/'){
                  widget.pass.currentRoute = '/';
                  Navigator.pushReplacementNamed(
                      context,
                      "/",
                      arguments: widget.pass,
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
                if(widget.pass.currentRoute != '/ExportPage'){
                  widget.pass.currentRoute = '/ExportPage';
                  Navigator.pushReplacementNamed(
                    context,
                    "/ExportPage",
                    arguments: widget.pass,
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
                if(currentState.currentRoute != '/LogInfoPage'){
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
                if(currentState.currentRoute != '/UnitPage'){
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
                if(currentState.currentRoute != '/TestPage'){
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
                if(currentState.currentRoute != '/SettingsPage'){
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
