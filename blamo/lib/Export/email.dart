import 'dart:async';
import 'package:blamo/ObjectHandler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:permission_handler/permission_handler.dart';


//Function to open ACTION SHARE activity with email sender
// Needs docName and extension type csv or pdf with future option of having it zipped
// Will throw exception if pdf/csv filepath is not found
// TODO need to create backend to vacuum up all doc files and create pdf/csv based only on doc name
Future<String> sendEmail(String documentName,String docType, String projectName) async {
  List<String> attachments = [];

  ObjectHandler objectHandler = new ObjectHandler(projectName);
  //String outputPath = "storage/emulated/0/Android/data/edu.oregonstate.blamo/files/output_test.pdf";
  String outputPath;
  debugPrint("EMAIL.dart - Send email");

  Future<bool> addAttachment(String doc, String docT) async {
    try {
      outputPath = await objectHandler.getPathToFile(doc, docT);
      debugPrint("output path: " + outputPath);
      attachments.add(outputPath);
      return true;
    } catch (e) {
      print("EMAIL.dart - No filepath found for document to send");
      return false;
    }
  }

  if(docType == 'both'){
    bool csv = await addAttachment(documentName,'csv');
    bool pdf = await addAttachment(documentName, 'pdf');
    if(csv == false){
      return "$documentName.csv not found";
    } else if(pdf == false) {
      return "$documentName.pdf not found";
    }
  } else {
    bool docReturn = await addAttachment(documentName, docType);
    if(docReturn == false){
      return "$documentName.$docType not found";
    }
  }

  if(attachments != null) {
    await new Future.delayed(new Duration(seconds: 1));
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (permission.toString() != "PermissionStatus.granted") {
      Map<PermissionGroup,
          PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    }
    await new Future.delayed(new Duration(seconds: 1));
    permission =
    await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    if (permission.toString() != "PermissionStatus.granted") {
      print("Permission denied."); // TODO - Better handle permission denied case.
      return("Failed permission given");
    } else {
      debugPrint("EMAIL.dart - Inside else");
      final Email email = Email(
        attachmentPaths: attachments,
        isHTML: false,
      );
      try {
        //Exception is thrown by the internal framework of Android share intent 4/2
        // Can't catch it from here
        // Been an issue since 2012 and never got fixed
        //https://issuetracker.google.com/issues/36956569
        // Email still sends with multi attachments
        await FlutterEmailSender.send(email);
      } catch (e) {
        return 'email done';
      }
      return 'email done';
    }
  }
  return 'failed to send email';
}
