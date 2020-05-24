
import 'package:blamo/Boreholes/BoreholeList.dart';
import 'package:blamo/routeGenerator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(BLAMO());

/* This builds the initial context and offloads
*  route navigation to the routeGenerator class
*  while setting the home page as '/'
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

class HomePage extends StatefulWidget {
  final StateData pass; //Passes the StateData object to the stateful constructor

  HomePage(this.pass, {Key key}) : super(key:key);

  @override
  _HomePageState createState() => _HomePageState(pass);
}

class _HomePageState extends State<HomePage> {
  final routeName = '/';
  StateData currentState;
  _HomePageState(this.currentState);
  TextEditingController _textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //updateStateData();
    currentState.dirty = 1;
  }

  @override
  Widget build(BuildContext context) {
    if (currentState != null) {
      currentState.currentRoute = '/'; //Assigns currentState.currentRoute to the name of the current named route
      currentState.currentProject="";
    } else {
      debugPrint("(Main) Setting new StateData");
      currentState = new StateData("/");
    }
    //debugPrint("Returning empty Scaffold");

    currentState.currentDocument="";
    currentState.currentProject="";
    currentState.storage.checkForManifest().then((bool doesManifestExist) {
      if (doesManifestExist && currentState.dirty == 1) {
        updateStateData();
        debugPrint("(Main) Updating state data due to dirty");
      } else if(!doesManifestExist){
        currentState.storage.overWriteManifest("");
      }
    });
      debugPrint("(Main) List length: ${ currentState.list.length}");
      return new WillPopScope(
        onWillPop: backPressed,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/BLAMO_GREY.png"),
                fit: BoxFit.cover
            )
          ),
          child: new Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              elevation:0,
              backgroundColor: Colors.transparent,
              actions: <Widget>[]
            ),
            body: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                child: Column(
                  children: <Widget>[
                    SizedBox(height:100),
                    Container(
                      height: 385,
                      width: 300,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 5,
                            spreadRadius: 1,)
                        ],
                        borderRadius: new BorderRadius.all(Radius.circular(2.5)),
                        color: Colors.blueGrey
                      ),
                      //color: Colors.grey,
                      child: ListView(
                          padding: EdgeInsets.all(8.0),
                          scrollDirection: Axis.vertical,
                          children: _populateProjectList(),
                      ),
                    )
                  ],
                )
              )
            ),
            floatingActionButton: floatingActionButtonBuilder(),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          ),
        ),
      );
  }

  List _populateProjectList(){
    List<Widget> projectsToReturn = [];
    for(int i = 0; i < currentState.list.length; i++){
      if(currentState.list[i] != "") {
        projectsToReturn.add(
            new Container(
              height: 75,
              child: dummyProjectList(currentState.list[i]),
            )
        );
      }
    }
    return projectsToReturn;
  }

  Widget dummyProjectList(String projectName){
    return new Card(
        child: new Material(
          child: InkWell(
              onTap: () => _onTileClicked(projectName),
              onLongPress: () => _onTileLongClicked(projectName),
              splashColor: Colors.grey,
              child: new Container(
                child: Center(
                    child: Text(projectName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromRGBO(89,89,89,1),
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                      key: Key('project_' + projectName),
                    )
                ),
              )
          ),
        ),
      );
  }

  //Function for accessing a project. Use a tap to initiate
  void _onTileClicked(String projectName) async {
    currentState.currentProject = projectName;
    currentState.currentDocument = "/BoreholeList";
    currentState.dirty = 1;
    debugPrint("(main)Tapped on: ${currentState.currentProject}");

    Navigator.pushReplacementNamed(
      context,
      "/BoreholeList",
      arguments: currentState,
    );

  }

  //Function for deleting a project. Use a long hold to initiate
  void _onTileLongClicked(String projectName) async{
    debugPrint("(main)LongPressed on: $projectName");
    String result;

    //Awaits the return value for the dialog
    result = await showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text("Are you sure you want to delete ${projectName}?"),
              actions: <Widget>[
                new FlatButton(
                    child: Text("DELETE"),
                    key: Key('projectDelete'),
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

    //If the returned value from the dialog is DELETE, delete the selected project
    if (result == "DELETE") {
      await currentState.storage.deleteProject(projectName);
      _showToast("$projectName Deleted!", Colors.red);
      await new Future.delayed(new Duration(microseconds: 3)).then((onValue) {
        setState(() {
          currentState.dirty = 1;
          currentState.list.remove(projectName);
          currentState.currentDocument = "";
          currentState.currentProject = "";
        });
      });
    }
  }

  //Builds the floating action button (add project) and implements the dialog for users naming their projects
  FloatingActionButton floatingActionButtonBuilder(){
    return new FloatingActionButton.extended(
      label: Text("Create New Project"),
      tooltip: 'New Borehole Document',
      foregroundColor: Colors.white,
      backgroundColor: Colors.blueGrey,
      elevation: 50.0,
      key: Key('newProject'),
      onPressed: () {
        showDialog(
            context: context,
          builder:(context) => AlertDialog(
            title: Text('Enter Project Name'),
            content: TextField(
              maxLength: 20,
              controller: _textFieldController,
              decoration: InputDecoration(labelText: 'Name cannot be empty'),
              inputFormatters: [new BlacklistingTextInputFormatter(new RegExp('[\\,]'))],
              key: Key('projectTextField'),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('CANCEL'),
                textColor: Colors.red,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('Accept'),
                key: Key('projectAccept'),
                onPressed: () async {
                  if(_textFieldController.text.isNotEmpty && !currentState.list.contains(_textFieldController.text.toString())) {
                    await createProject(_textFieldController.text.toString());
                    Navigator.of(context).pop();
                    _textFieldController.text = "";
                  } else if(!_textFieldController.text.isNotEmpty){
                    _showToast("Empty entries not allowed!!", Colors.red);
                  } else if(currentState.list.contains(_textFieldController.text.toString())){
                    _showToast("Duplicate project names not allowed!", Colors.red);
                  } else {
                    _showToast("Oops! Unrecognized error!", Colors.red);
                  }
                },
              )
            ],
          )
        );
      },
    );
  }

  //Overrides the back button to prompt the user to confirm they wish to exit the BLAMO application
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

  //Shows a toast at the bottom with the given test (toShow) and the given color (color)
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

  //Function called that initializes the project before navigating to it
  Future<void> createProject(String projectName) async {
    String toWrite = '';

    if(currentState.list.length == 0){
      toWrite =projectName + ",";
    } else {
      for(int i = 0; i < currentState.list.length -1; i++){
        toWrite = toWrite + currentState.list[i] + ',';
      }
      toWrite = toWrite + projectName + ",";
    }
    await currentState.storage.overWriteManifest(toWrite);
    updateStateData();
  }

  //Updates the currentState object to reflect the manifest document
  void updateStateData() async{
    currentState.currentDocument="";
    currentState.currentProject= "";
    await currentState.storage.setStateData(currentState).then((StateData recieved) {
      setState(() {
        debugPrint("(Main) Updated data setState:");
        currentState.list = recieved.list;
        currentState.dirty = 0;
      });
    });
  }
}
