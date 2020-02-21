import 'package:blamo/main.dart';
import 'package:flutter/material.dart';
import 'package:blamo/File_IO/FileHandler.dart';

class DocumentPage extends StatefulWidget {
  StateData pass;
  final PersistentStorage storage = PersistentStorage();

  DocumentPage(this.pass);

  @override
  _DocumentPageState createState() => _DocumentPageState(pass);
}

class _DocumentPageState extends State<DocumentPage> {
  final routeName = '/Document';
  StateData currentState;
  _DocumentPageState(this.currentState);

  @override
  Widget build(BuildContext context) {
    if (currentState != null) {
      currentState.currentRoute = '/Document';
    }

    widget.pass.storage.checkDocument(currentState.currentDocument).then((bool doesDocumentExist) {
      if (doesDocumentExist && currentState.dirty == 1) {
        upDateStateData(-1);
      } else if(!doesDocumentExist){
        debugPrint("(main)Creating new document");
        int documentNumber = currentState.documentIterator;
        widget.pass.storage.overWriteDocument(currentState.currentDocument,'$documentNumber\n0\n0');
      }
    });

    return new Scaffold(
      drawer: Drawer(
        child: SideMenu(currentState),
      ),

      appBar: new AppBar(
          title: new Text(currentState.currentDocument),
          actions: <Widget>[
          ],
          backgroundColor: Colors.deepOrange
      ),

      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, i){
          String title;
          switch(i){
            case 0:
              title = "Loginfo";
              break;
            case 1:
              title = "Tests";
              break;
            case 2:
              title = "Units";
              break;
          }
          return new ExpansionTile(
            title: new Text(title),
            children: <Widget>[
              new Column(
                children: _buildExpandedContent(title),
              )
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {createFudgedData();},
      ),

    );
  }

  void createFudgedData() async{
    String a, b, c;
    a = "Banana";
    b = "Strawberry";
    c = "Smoothie";

    await widget.pass.storage.overWriteTest(currentState.currentDocument, a,"TestName: $a\n");
    await widget.pass.storage.overWriteTest(currentState.currentDocument, b,"TestName: $b\n");
    await widget.pass.storage.overWriteUnit(currentState.currentDocument, c,"UnitName: $c\n");
    int newTestCount = 2;
    int unitCount = 1;
    await widget.pass.storage.overWriteDocument(currentState.currentDocument, "${currentState.currentDocument}\n$newTestCount\n$unitCount\n");
    await widget.pass.storage.writeDocument(currentState.currentDocument, "$a,");
    await widget.pass.storage.writeDocument(currentState.currentDocument, "$b,");
    await widget.pass.storage.writeDocument(currentState.currentDocument, "$c,");
    setState(() {
      currentState.dirty = 1;
    });
  }

  //Creates a new document manifest
  void createNewTest(String testName) async{
    await widget.pass.storage.overWriteTest(currentState.currentDocument, testName,"TestName: $testName\n");
    int newTestCount = widget.pass.testCount++;
    int unitCount = widget.pass.unitCount;
    widget.pass.storage.overWriteDocument(currentState.currentDocument, "${currentState.currentDocument}\n$newTestCount\n$unitCount");
  }

  //Creates a new Unit file
  void createNewUnit(String unitName) async{
    await widget.pass.storage.overWriteUnit(currentState.currentDocument, unitName,"UnitName: $unitName\n");
    widget.pass.unitCount++;
  }

  //Creates a new LogInfo file
  void createNewLogInfo(int docIteration) async{
    await widget.pass.storage.overWriteDocument(currentState.currentDocument, "DocumentNumber: $docIteration\n");
  }

  //Updates the currentState object to reflect the manifest document
  void upDateStateData(int num) async{
    await widget.pass.storage.setStateData(currentState).then((StateData received) {
      currentState.list = received.list;

      currentState.testCount = received.testCount;
      currentState.unitCount = received.unitCount;
      currentState.testList = received.testList;
      currentState.unitList = received.unitList;

      currentState.dirty = 0;
      setState((){});
    });
  }

  //Builds the collapseable list views for The overview page. The overview page provides a link to the tests, loginfo, and Unit pages
  _buildExpandedContent(String passedTitle) {
    List<Widget> columnContent = [];
    if (passedTitle == "LogInfo") {
      columnContent.add(
          new ListTile(
            title: new Text(passedTitle),
          )
      );
    } else if (passedTitle == "Tests") {
      for (int i = 0; i < widget.pass.testList.length; i++) {
        columnContent.add(
            new ListTile(
              title: new Text(widget.pass.testList[i]),
            )
        );
      }
    } else {
      for (int i = 0; i < widget.pass.unitList.length; i++) {
        columnContent.add(
            new ListTile(
              title: new Text(widget.pass.unitList[i]),
            )
        );
      }
    }
    return columnContent;
  }
}
