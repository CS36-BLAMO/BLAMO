import 'package:blamo/routeGenerator.dart';
import 'package:flutter/material.dart';
import 'package:blamo/File_IO/FileHandler.dart';
import 'package:blamo/SideMenu.dart';
import 'package:blamo/CustomActionBar.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

//This class will be used to house all the data between each route
class StateData {
  String currentRoute;
  String currentDocument;
  String currentUnit;
  String currentTest;

  int documentIterator = 0;
  int unitCount = 0;
  int testCount = 0;
  int randomNumber;
  int dirty;

  List<String> list = [""];
  List<String> testList = [];
  List<String> unitList = [];

  final PersistentStorage storage = PersistentStorage();

  StateData(this.currentRoute, [this.dirty = 1]){
    this.currentDocument = "";
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
  final StateData pass;
  //--Toremove
  //final PersistentStorage storage = PersistentStorage();

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

  TextEditingController _textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentState.storage.setStateData(currentState).then((StateData recieved) {
      setState(() {
        currentState.list = recieved.list;
        currentState.currentRoute = '/';
        currentState.dirty = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentState != null) {
      currentState.currentRoute = '/'; //Assigns currentState.currentRoute to the name of the current named route
    }
    currentState.currentDocument="";
    currentState.storage.checkForManifest().then((bool doesManifestExist) {
      if (doesManifestExist && currentState.dirty == 1) {
        updateStateData();
      } else if(!doesManifestExist){
        currentState.storage.overWriteManifest("");
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
    return WillPopScope (  // WillPopScope handles native android back button
      onWillPop: backPressed,          //Requires a future
      child: new Scaffold(
        drawer: Drawer(
          child: SideMenu(currentState),
        ),

        appBar: CustomActionBar("Home").getAppBar(),

        body: gridViewBuilder(currentState.list),

        floatingActionButton: floatingActionButtonBuilder(),

      ),
    );
  }

  Future<bool> backPressed() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Do you want to exit the BLAMO application?"),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "No",
              style: TextStyle(
                  fontSize: 25,
              ),
            ),
            onPressed: () => Navigator.pop(context,false),
          ),
          FlatButton(
            child: Text(
              "Yes",
              style: TextStyle(
                fontSize: 25,
                color: Colors.red
              ),
            ),
            onPressed: () => Navigator.pop(context,true),
          )
        ]
      )
    );
  }

  //Creates a new document manifest
  Future<void> createNewDocument(String docName) async{
    await currentState.storage.overWriteDocument(docName, "$docName\n0\n0");
  }

  //Updates the currentState object to reflect the manifest document
  Future<void> updateStateData() async{
    await currentState.storage.setStateData(currentState).then((StateData recieved) {
      currentState.list = recieved.list;
      currentState.dirty = 0;
    });
  }

  Future<void> updateStateDataCreateDoc(String docName) async{
    await updateStateData();
    await createNewDocument(docName);
  }

  void _onTileClicked(int index) async {
    currentState.documentIterator = index;
    currentState.currentDocument = currentState.list[index];
    currentState.dirty = 1;
    debugPrint("(main)Tapped on: ${currentState.currentDocument}");

    Navigator.pushReplacementNamed(
      context,
      "/Document",
      arguments: currentState,
    );
    //currentState.currentDocument = "";
  }

  void _showToast(String toShow, MaterialColor color){
    Fluttertoast.showToast(
        msg: toShow,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: color,
        textColor: Colors.black,
        fontSize: 16.0
    );
  }

  void _onTileLongPressed(int index) async {
    currentState.documentIterator = index;
    currentState.currentDocument = currentState.list[index];
    String result;
    result = await showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text("Are you sure you want to delete ${currentState
                  .currentDocument}?"),
              actions: <Widget>[
                new FlatButton(
                    child: Text("DELETE"),
                    textColor: Colors.red,
                    onPressed: () {
                      Navigator.pop(context, "DELETE");
                    }),
                new FlatButton(
                  child: Text("CANCEL"),
                  onPressed: () {
                    Navigator.pop(context, "CANCEL");
                  },
                )
              ],
            )
    );
    if (result == "DELETE") {
      debugPrint("(main)LongPressed on: ${currentState.currentDocument}");
      await currentState.storage.deleteDocument(currentState.currentDocument);
      _showToast("${currentState.currentDocument} Deleted!", Colors.red);
      await new Future.delayed(new Duration(microseconds: 3)).then((onValue) {
        setState(() {
          currentState.dirty = 1;
          currentState.list.remove(currentState.currentDocument);
          currentState.currentDocument = "";
        });
      });
    }
  }



  /* These are the object builders for the main scaffolding
   *  FloatingActionButtonBuilder -> Builds the functionalty and style of the FAB in the bottom right of the screen, creates new documents onPressed
   *  gridViewBuilder             -> Builds the main gridview dynamically on document creation
   */
    FloatingActionButton floatingActionButtonBuilder(){
      return new FloatingActionButton.extended(
        label: Text("New Document"),
        tooltip: 'New Borehole Document',
        icon: new Icon(Icons.add),
        foregroundColor: Colors.black,
        backgroundColor: Colors.grey,
        elevation: 50.0,
        onPressed:(){
          showDialog(
            context: context,
            builder:(context) => AlertDialog(
              title: Text('Enter Document Name'),
              content: TextField(
                maxLength: 20,
                controller: _textFieldController,
                decoration: InputDecoration(labelText: 'Name Cannot Be Empty'),
                inputFormatters: [new BlacklistingTextInputFormatter(new RegExp('[\\,]'))],
              ),
              actions: <Widget> [
                new FlatButton(
                     child: new Text('CANCEL'),
                     textColor: Colors.red,
                     onPressed: () {
                       Navigator.of(context).pop();
                     },
                ),
                new FlatButton(
                  child: new Text('ACCEPT'),
                  onPressed: () async {
                    int i;
                    String toWrite = '';
                    String newestDoc;
                    String newNameWithComma = _textFieldController.text + ","; //TODO REGEX TO PARSE INPUT FOR SPECIAL CHARS AND DUP NAMES
                    print("INPUT FIELD RECIEVED:" + newNameWithComma);
                    if(_textFieldController.text.isNotEmpty) {
                        if (currentState.list.length == 1) {
                          toWrite = newNameWithComma;
                          newestDoc = _textFieldController.text;
                        } else {
                          for (i = 0; i < currentState.list.length - 1; i++) {
                            toWrite = toWrite + currentState.list[i] + ',';
                          }
                          toWrite = toWrite + newNameWithComma;
                          //toWrite = "Document$i,";
                          newestDoc = _textFieldController.text;
                        }
                        //In order for this to create doc and update homepage there needs to be a comma at the end of the filename
                        //Or else it will fail to create
                        await currentState.storage.overWriteManifest(toWrite);
                        await currentState.storage.overWriteLogInfo(_textFieldController.text, "{project:null,number:null,client:null,highway:null,county:null,projection:NAD 1983 2011 Oregon Statewide Lambert Ft Intl,north:null,east:null,lat:null,long:null,location:null,elevationDatum:null,tubeHeight:null,boreholeID:null,startDate:null,endDate:null,surfaceElevation:null,contractor:null,equipment:null,method:null,loggedBy:null,checkedBy:null}");

                        await updateStateDataCreateDoc(newestDoc);
                        setState(() {});
                        //Remove AlertDialog and allow for another doc to be created
                        Navigator.of(context).pop();
                        _textFieldController.text = "";
                    }
                  },
                )
              ]
            ),
          );
        },
      );
    }

    GridView gridViewBuilder(List<String> listToBuildFrom){
      return new GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 2,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: List.generate(listToBuildFrom.length - 1, (indexReg) {

          int index = listToBuildFrom.length - 2 - (indexReg);

          if(indexReg==0){
            index = listToBuildFrom.length - 2;
          }
          debugPrint("UpperBound: ${listToBuildFrom.length}");
          debugPrint("indexReg: $index" + " With Docname: " + listToBuildFrom[index]);
          String toReturn;
          int colorVal = (index+1) * 100;
          if (index >= 9) {
            colorVal = 800;
          }
          toReturn = listToBuildFrom[index];
          return new Container(
            child: new Card(
              child: new Material(
                child: InkWell(
                    onTap: () => _onTileClicked(index),
                    onLongPress: () => _onTileLongPressed(index),
                    splashColor: Colors.grey,
                    child: new Container(
                      child: Center(
                          child: Text(toReturn,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                          )
                      ),
                    )
                ),
                color: Colors.transparent,
              ),
              color: Colors.orange[colorVal],
              elevation: 10,
            ),
          );
        }),
      );
    }
    //---End Builders---
}