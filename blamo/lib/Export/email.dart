import 'dart:async';
import 'package:blamo/ObjectHandler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:permission_handler/permission_handler.dart';


//Function to open ACTION SHARE activity with email sender
// Needs docName and extension type csv or pdf with future option of having it zipped
// Will throw exception if pdf/csv filepath is not found
// TODO need to create backend to vacuum up all doc files and create pdf/csv based only on doc name
Future<String> sendEmail(String documentName,String docType) async {
  ObjectHandler objectHandler = new ObjectHandler();
  //String outputPath = "storage/emulated/0/Android/data/edu.oregonstate.blamo/files/output_test.pdf";
  String outputPath;
  debugPrint("EMAIL.dart - Send email");

  try {
    outputPath = await objectHandler.getPathToFile(documentName, docType);
    debugPrint("output path: " + outputPath);
  } catch (e) {
    print("EMAIL.dart - No filepath found for document to send");
    return "No $docType type file found for $documentName";
  }

  if(outputPath != null) {
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
      print(
          "Permission denied."); // TODO - Better handle permission denied case.
    } else {
      debugPrint("EMAIL.dart - Inside else");
      final Email email = Email(
        attachmentPath: outputPath,
        isHTML: false,
      );
      await FlutterEmailSender.send(email);
    }
  }
}
