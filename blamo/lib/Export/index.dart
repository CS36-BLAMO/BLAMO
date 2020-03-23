import 'dart:async';

import 'package:blamo/Export/CSVExporter.dart';
import 'package:blamo/main.dart';
import 'package:flutter/material.dart';
import 'package:blamo/PDF/pdf_builder.dart';
import 'package:blamo/SideMenu.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:blamo/CustomActionBar.dart';
import 'email.dart';
import 'package:getflutter/getflutter.dart';

/*This page will serve as a manual export option all different avenues
 * Only email and Box at the moment for placeholder but can be expanded to others
 * Each page will live in its own dir for proper file structure.
 */

class ExportPage extends StatefulWidget {
  final StateData pass; //Passes the StateData object to the stateful constructor

  ExportPage(this.pass);

  @override
  _ExportPageState createState() => _ExportPageState(pass);
}

// Basic structure for title and skeleton for expanded page
class _ExportPageState extends State<ExportPage> with TickerProviderStateMixin {
  final routeName = '/ExportPage';
  StateData currentState;
  //Creating structured list of output types
  List<String> docTypes = ['csv','pdf'];
  //parameters to pass to emailer
  String pickedDoc = null;
  String pickedDocType = null;

  //Variable for animations
  int _emailState = 0;
  int _pdfState = 0;
  int _csvState = 0;
  List<String>curDoc = [];

  _ExportPageState(this.currentState);

  //Pre cache image in order to be loaded when user first sees page
  Image myImage;

  @override
  void initState(){
    //myImage = Image.asset('assets/images/plants.jpg');
    super.initState();
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    //precacheImage(myImage.image, context);
  }

  @override
  Widget build(BuildContext context) {

    if (currentState.currentRoute != null) {
      currentState.currentRoute =
      '/ExportPage'; //Assigns currentState.currentRoute to the name of the current named route
    }

    return new Scaffold(
      drawer: new Drawer(
        child: SideMenu(currentState),
      ),
      appBar: CustomActionBar("Export").getAppBar(),

      body: new Stack(
        children: <Widget> [
          new Container(
            //decoration: new BoxDecoration(
            //  image: new DecorationImage(
            //      image: myImage.image,
            //      fit: BoxFit.cover,
            //  )
            //)
          ),
          new Container(
            child: Align(
              alignment: Alignment.topCenter,
              child: new SingleChildScrollView(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(height: 25),
                      Flexible(
                        flex: 1,
                        fit: FlexFit.loose,
                        child: Container(
                            width: 500,
                            height: 175,
                            child: _saveFileGFTile(context)
                        ),
                      ),
                      Container(
                          width: 500,
                          height: 175,
                          child:_emailGFTile(context)
                      )
                    ]),
              )
            )
          )
        ],
      )
    );
  }

  GFCard _emailGFTile(BuildContext context) => GFCard(
    boxFit: BoxFit.cover,
    color: Color.fromRGBO(255,255,255,0.9),
    content: new Column(
      children: <Widget>[
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new DropdownButtonHideUnderline(
                child: DropdownButton(
                    hint: Text(
                      'Select Document',
                      style: TextStyle(
                          fontSize: 21,
                          color: Color.fromRGBO(89,89,89,1)
                      )
                    ),
                    value: pickedDoc,
                    items:
                    currentState.list.map((String value) {
                      //print("Value from List of strings " + value);
                      return new DropdownMenuItem(
                        value: value,
                        child: new Text(
                          value,
                          style: TextStyle(
                              fontSize: 27,
                            fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(89,89,89,1),
                          )
                        ),
                      );
                    }).toList(),
                    onChanged: (String value){
                      //Will be needed in future
                      setState(() {
                        pickedDoc = value;
                      });
                    }
                )
            ),
            SizedBox(width:10),
            new DropdownButtonHideUnderline(
                child: DropdownButton(
                    hint: Text(
                        'Select Format',
                        style: TextStyle(
                            fontSize: 21,
                            color: Color.fromRGBO(89,89,89,1)
                        )
                    ),
                    value: pickedDocType,
                    items:
                    docTypes.map((String value) {
                      //print("Value from List of strings " + value);
                      return new DropdownMenuItem(
                        value: value,
                        child: new Text(
                            value,
                            style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(89,89,89,1),
                            )
                        ),
                      );
                    }).toList(),
                    onChanged: (String value){
                      setState(() {
                        pickedDocType = value;
                      });
                    }
                )
            ),

          ]
        ),
        SizedBox(height:15),
        new Container(
          width: double.infinity,
          child: new MaterialButton(
            child: setEmailButton(),
            onPressed: () async {
              print("Pressing send email");
              if(pickedDoc != null && pickedDocType != null) {
                setState(() {
                  if(_emailState == 0) {
                    animateEmail();
                  }
                });
                return sendEmail(pickedDoc, pickedDocType).then((
                    onValue) {
                  if (onValue == "No $pickedDocType type file found for $pickedDoc") {
                    setState(() {
                      _emailState = 0;
                    });
                    Fluttertoast.showToast(
                        msg: "$pickedDoc does not have a saved .$pickedDocType file",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIos: 3,
                        backgroundColor: Color(0xFF3B3B3B),
                        textColor: Colors.white,
                        fontSize: 18
                    );
                  } else {
                    setState(() {
                      _emailState = 0;
                    });
                  }
                });
              } else {
                Fluttertoast.showToast(
                    msg: "Select a document and format type",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIos: 3,
                    backgroundColor: Color(0xFF3B3B3B),
                    textColor: Colors.white,
                    fontSize: 18
                );
              }
            },
            elevation: 4.0,
            height: 48.0,
            color: Colors.blue,
          )
        )
      ]
    ),
  );
  GFCard _saveFileGFTile(BuildContext context) => GFCard(
    boxFit: BoxFit.contain,
    color: Color.fromRGBO(255,255,255,0.9),
    content: new Column(
      children: <Widget>[
        new Text(
          "Save ${currentState.currentDocument}",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(89,89,89,1)
          ),
        ),
        SizedBox(height:25),
        new Row (
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Container(
                  width: 150,
                  child: new MaterialButton(
                    child: setPDF(),
                    onPressed: () async {
                      setState(() {
                        if(_pdfState == 0) {
                          animatePDF();
                        }
                      });
                      if(_pdfState == 1){
                        String finish = await docCreate(currentState);
                        if(finish == "done"){
                          setState(() {
                            _pdfState = 2;
                          });
                        } else if(finish == "failed") {
                          setState(() {
                            _pdfState = 0;
                          });
                          Fluttertoast.showToast(
                              msg: "Failed to save ${currentState.currentDocument} as .pdf",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIos: 3,
                              backgroundColor: Color(0xFF3B3B3B),
                              textColor: Colors.white,
                              fontSize: 18
                          );
                        }
                      }
                    },
                    elevation: 4.0,
                    height: 48.0,
                    color: Colors.blue,
                  )
              ),
              SizedBox(width: 50),
              new Container(
                  width: 150,
                  child: new MaterialButton(
                    child: setCSV(),
                    onPressed: () async {
                      setState(() {
                        if(_csvState == 0) {
                          animateCSV();
                        }
                      });
                      if(_csvState == 1){
                        CSVExporter csvExporter = new CSVExporter(currentState);
                        String finish = await csvExporter.exportToCSV();
                        if(finish == "done"){
                          setState(() {
                            _csvState = 2;
                          });
                        } else if(finish == "failed") {
                          setState(() {
                            _csvState = 0;
                          });
                          Fluttertoast.showToast(
                              msg: "Failed to save ${currentState.currentDocument} as .csv",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIos: 3,
                              backgroundColor: Color(0xFF3B3B3B),
                              textColor: Colors.white,
                              fontSize: 18
                          );
                        }
                      }
                    },
                    elevation: 4.0,
                    height: 48.0,
                    color: Colors.blue,
                  )
              )
            ]
        )
      ]
    ),
  );

  void animatePDF(){
    setState(() {
      _pdfState = 1;
    });
  }
  void animateCSV() {
    setState(() {
      _csvState = 1;
    });
  }
  void animateEmail() {
    setState(() {
      _emailState = 1;
    });
  }
  Widget setEmailButton(){
    if(_emailState == 0) {
      return new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Icon(
                Icons.email,
                color: Colors.white
            ),
            new Text(
              "  Send Email",
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.white
              ),
            )
          ]
      );
    } else if (_emailState == 1) {
      return CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white)
      );
    } else {
      return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.email, color: Colors.white),
            new Text(
              "  Send Email",
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.white
              ),
            )
          ]
      );
    }
  }
  Widget setPDF(){
    if(_pdfState == 0) {
      return new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Icon(
              Icons.save_alt,
              color: Colors.white
            ),
            new Text(
              "  PDF",
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.white
              ),
            )
          ]
      );
    } else if (_pdfState == 1) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white)
      );
    } else {
      return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.check, color: Colors.white),
            new Text(
              "  PDF",
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.white
              ),
            )
          ]
      );
    }
  }
  Widget setCSV() {
    if(_csvState == 0) {
      return new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Icon(
                Icons.save_alt,
                color: Colors.white
            ),
            new Text(
              "  CSV",
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.white
              ),
            )
          ]
      );
    } else if (_csvState == 1) {
      return CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white)
      );
    } else {
      return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.check, color: Colors.white),
            new Text(
              "  CSV",
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.white
              ),
            )
          ]
      );
    }
  }
}


//TODO cloud save to Box -- Maybe can "trick" Action Share to do Box export