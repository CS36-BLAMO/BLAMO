import 'dart:async';

import 'package:blamo/Export/CSVExporter.dart';
import 'package:blamo/Boreholes/BoreholeList.dart';
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

  ExportPage(this.pass, {Key key}) : super(key:key);

  @override
  _ExportPageState createState() => _ExportPageState(pass);
}

// Basic structure for title and skeleton for expanded page
class _ExportPageState extends State<ExportPage> with TickerProviderStateMixin {
  final routeName = '/ExportPage';
  StateData currentState;
  //Creating structured list of output types
  List<String> docTypes = ['csv','pdf','both'];
  //parameters to pass to emailer
  String pickedDoc = null;
  String pickedDocType = null;

  //Variable for animations
  int _emailState = 0;
  int _pdfState = 0;
  int _csvState = 0;

  List<String> boreholeList;

  _ExportPageState(this.currentState);

  //Pre cache image in order to be loaded when user first sees page
  Image myImage;

  @override
  void initState(){
    //myImage = Image.asset('assets/images/');
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

    //TODO THIS NEEDS TO BE REMOVED WHEN EMPTY STRING BUG IS FIXED FOR currentState.list
    boreholeList = []..addAll(currentState.list);
    boreholeList.removeLast();

    return WillPopScope(
      onWillPop: backPressed,
      child: new Scaffold(
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
                              height: 160,
                              child: _saveFileGFTile(context)
                          ),
                        ),
                        Container(
                            width: 500,
                            height: 170,
                            child:_emailGFTile(context,boreholeList)
                        )
                      ]),
                )
              )
            )
          ],
        )
      ),
    );
  }
  //Takes you back to the Overview page for the selected borehole
  Future<bool> backPressed() async {
    Navigator.pushReplacementNamed(
      context,
      "/Document",
      arguments: currentState,
    );
    return Future.value(false);
  }

  GFCard _emailGFTile(BuildContext context, List<String> boreholeList) => GFCard(
    boxFit: BoxFit.cover,
    color: Color.fromRGBO(255,255,255,0.9),
    content: new Column(
      children: <Widget>[
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible (
              flex: 3,
              fit: FlexFit.loose,
              child: new DropdownButtonHideUnderline(
                  child: DropdownButton(
                    key: Key('docDropdown'),
                    hint: Text(
                      'Borehole',
                      style: TextStyle(
                          fontSize: 15,
                          color: Color.fromRGBO(89,89,89,1)
                      )
                    ),
                    value: pickedDoc,
                    items:
                    boreholeList.map((String value) {
                      //print("Value from List of strings " + value);
                      return new DropdownMenuItem(
                        value: value,
                        child: new Text(
                          value,
                          key: Key('doc_' + value),
                          style: TextStyle(
                              fontSize: 20,
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
            ),
            Flexible (
              flex: 1,
              fit: FlexFit.tight,
              child: new DropdownButtonHideUnderline(
                  child: DropdownButton(
                      key: Key('typeDropdown'),
                      hint: Text(
                          'Type',
                          style: TextStyle(
                              fontSize: 15,
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
                              key: Key('type_' + value),
                              style: TextStyle(
                                fontSize: 20,
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
            ),

          ]
        ),
        SizedBox(height:10),
        new Container(
          width: double.infinity,
          child: new MaterialButton(
            child: setEmailButton(),
            key: Key('sendEmail'),
            onPressed: () async {
              print("Pressing send email");
              if(pickedDoc != null && pickedDocType != null) {
                setState(() {
                  if(_emailState == 0) {
                    animateEmail();
                  }
                });
                return sendEmail(pickedDoc, pickedDocType, currentState.currentProject).then((onValue) {
                  setState(() {
                    _emailState = 0;
                  });
                  if (onValue == "$pickedDoc.csv not found"){
                    toastEmailResponse("$pickedDoc.csv not found");
                  } else if (onValue == "$pickedDoc.pdf not found"){
                    toastEmailResponse("$pickedDoc.pdf not found");
                  } else if (onValue == "failed to send email"){
                    toastEmailResponse("failed to send email");
                  }
                });
              } else {
                toastEmailResponse("Select a Borehole and format type");
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
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible (
          flex: 3,
          fit: FlexFit.loose,
          child: Text(
            "Save ${currentState.currentDocument}",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              color: Color.fromRGBO(89,89,89,1)
            ),
          ),
        ),
        SizedBox(height:20),
        Flexible (
          flex: 3,
          fit: FlexFit.loose,
          child: Row (
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible (
                  flex: 3,
                  fit: FlexFit.loose,
                  child: new Container(
                      width: 150,
                      child: new MaterialButton(
                        child: setPDF(),
                        key: Key('savePDF'),
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
                            } else if (finish == "error"){
                              setState(() {
                                _pdfState = 2;
                              });
                              Fluttertoast.showToast(
                                  msg: "Error in PDF creation - see written PDF for details.",
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
                ),
                Spacer(flex: 1),
                Flexible (
                  flex: 3,
                  fit: FlexFit.loose,
                  child: new Container(
                      width: 150,
                      child: new MaterialButton(
                        child: setCSV(),
                        key: Key('saveCSV'),
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
                  ),
                )
              ]
          ),
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
      return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible (
                flex: 1,
                fit: FlexFit.tight,
                child: new Icon(
                  Icons.save_alt,
                  color: Colors.white
                ),
              ),
              Flexible (
                flex: 3,
                fit: FlexFit.tight,
                child: new Text(
                  "  PDF",
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.white
                  ),
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
            Flexible (
                flex: 1,
                fit: FlexFit.tight,
                child: Icon(
                    Icons.check,
                    color: Colors.white)
            ),
            Flexible (
              flex: 3,
              fit: FlexFit.tight,
              child: new Text(
                "  PDF",
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.white
                ),
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
            Flexible (
              flex: 1,
              fit: FlexFit.tight,
              child: new Icon(
                  Icons.save_alt,
                  color: Colors.white
              ),
            ),
            Flexible (
              flex: 3,
              fit: FlexFit.loose,
              child: new Text(
                "  CSV",
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.white
                ),
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
            Flexible (
              flex: 1,
              fit: FlexFit.tight,
              child: Icon(
                  Icons.check,
                  color: Colors.white
              ),
            ),
            Flexible (
              flex: 3,
              fit: FlexFit.tight,
              child: new Text(
                "  CSV",
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.white
                ),
              ),
            )
          ]
      );
    }
  }
  //Shows toast with passed in message
  void toastEmailResponse(String errorMessage){
    //Cancels previous toasts
    Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 3,
        backgroundColor: Color(0xFF3B3B3B),
        textColor: Colors.white,
        fontSize: 18
    );
  }
}


//TODO cloud save to Box -- Maybe can "trick" Action Share to do Box export