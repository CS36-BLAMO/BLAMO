import 'package:flutter/cupertino.dart';
import 'dart:convert';

import 'package:path_provider/path_provider.dart';
import 'package:blamo/main.dart';

import 'dart:io';
import 'dart:async';

/* This is the method for getting a devices document directory (Persistant)
  * In this chunk I we provide functions for getting the file path, writing
  * and reading a string from the documents directory
  */
class PersistentStorage {
  String devicePath;
  String fileName;
  String pathExtension; //Structure for a path is $path/pathExtension/filename
  int nameIterator;

  PersistentStorage(){
    fileName = "Manifest.txt";
    pathExtension = "";
    nameIterator = 0;
  }

  PersistentStorage.withExtension(this.fileName, this.pathExtension, [this.nameIterator = 0]);

  /*This block handles directory navigation
  *    fileName -> name of the file you're working with
  *    pathExtension -> name of the extended path from device native path
  *    nameIterator -> Iterative file name (test1, test2, ... , test$nameIterator)
  * */
  void changeFilename(String newFileName){
    fileName = newFileName;
  }

  void changePathExtension(String newExtension){
    pathExtension = newExtension;
  }

  void changeNameIterator(int newIterator){
    nameIterator = newIterator;
  }

  void setFileToManifest(){
    fileName="Manifest.txt";
    pathExtension = "";
    nameIterator = 0;
  }

  void setFileToDocument(String documentName){
    fileName="_Document-Meta.txt";
    pathExtension="$documentName";
    nameIterator = 0;
  }

  /*These next three functions should only be called from when in a document
  * i.e. pathExtension is already established with a Document$documentNumber
  * */
  void setFileToUnit(String unitName){
    fileName="_$unitName.txt";
    nameIterator = 0;
  }

  void setFileToTest(String testName){
    fileName="_$testName.txt";
    nameIterator = 0;
  }

  void setFileToLogInfo(){
    fileName="_LogInfo.txt";
    nameIterator = 0;
  }
  /*end document setters*/

  /*---End of Navigation Block---*/

  /*This block handles getting the path, and files associated with any data*/
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/' + pathExtension + fileName);
  }

  /*---End Path Getters---*/


/*This block handles read operations for the different types of files in our
* file system.
*    readManifest -> reads state data needed to persist through reboots
*    readDocument -> reads document meta-data (ideally used to map out the file system) requires document number
*    readTest     -> reads test data and expects 2 integers (Document number, Test number)
*    readUnit     -> reads unit data and expects 2 integers (Document number, Unit number)
*/
  Future<String> readManifest() async {
    changePathExtension("");
    changeFilename("Manifest.txt");
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return "oops!";
    }
  }

  Future<String> readDocument(String documentName) async {
    //--Debug
    debugPrint("(FH)Reading from: /$documentName" + "_Document-Meta.txt\n");

    changePathExtension(documentName);
    changeFilename('_Document-Meta.txt');
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return "oops!";
    }
  }

  Future<String> readTest(String documentName, String testName) async {
    //--Debug
    debugPrint("(FH)Reading from: /$documentName" + "_$testName.txt\n");

    changePathExtension(documentName);
    changeFilename('_$testName.txt');
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return "oops!";
    }
  }

  Future<String> readUnit(String documentName, String unitName) async {
    //--Debug
    debugPrint("(FH)Reading from: /$documentName" + "_$unitName.txt\n");

    changePathExtension(documentName);
    changeFilename('_$unitName.txt');
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return "oops!";
    }
  }

  /*---End Read Operations Block---*/

/*This block handles all of the creation/overwrite opperations for file IO
* overWriteManifest -> Creates and writes into the manifest doc in the root
* overWriteDocument -> Creates and writes into the Document-meta.text (requires document number)
* overWriteTest     -> Creates and writes into the test document (requires: document number and test number)
* overWrite         -> Creates and writes into the unit document (requires: document number and unit number)
* */
  Future<File> overWriteManifest(String toWrite) async {
    //--Debug
    debugPrint("(FH)Printing to manifest: $toWrite");
    setFileToManifest();
    final file = await _localFile;

    // Write the file
    return await file.writeAsString(toWrite);
  }

  Future<File> overWriteDocument(String documentName, String toWrite) async {
    //--Debug
    debugPrint("(FH)Writing to: /$documentName" + "_Document-Meta.txt\n\nContents: $toWrite\n");

    changePathExtension(documentName);
    changeFilename('_Document-Meta.txt');
    final file = await _localFile;

    // Write the file
    //return file.writeAsString('Document$documentNumber');
    return await file.writeAsString(toWrite);
  }

  Future<File> overWriteTest(String documentName, String testName,String toWrite) async {
    //--Debug
    debugPrint("(FH)Writing to: /$documentName" + "_$testName.txt\n\nContents: $toWrite\n");

    changePathExtension(documentName);
    changeFilename('_$testName.txt');
    final file = await _localFile;

    // Write the file
    return await file.writeAsString(toWrite);
  }

  Future<File> overWriteUnit(String documentName, String unitName, String toWrite) async {
    //--Debug
    debugPrint("(FH)Writing to: /$documentName" + "_$unitName.txt\n\nContents: $toWrite\n");

    changePathExtension(documentName);
    changeFilename('_$unitName.txt');
    final file = await _localFile;

    // Write the file
    return await file.writeAsString(toWrite);
  }
  /*---End OverWrite Block---*/

  Future<File> writeManifest(String toWrite) async {
    setFileToManifest();
    final file = await _localFile;

    // Write the file
    return await file.writeAsString(toWrite, mode: FileMode.append, encoding: utf8 ,flush: true);
  }

  Future<File> writeDocument(String documentName, String toWrite) async {
    changePathExtension(documentName);
    changeFilename('_Document-Meta.txt');
    final file = await _localFile;

    // Write the file
    //return file.writeAsString('Document$documentNumber');
    return await file.writeAsString(toWrite, mode: FileMode.append, encoding: utf8 ,flush: true);
  }

  Future<File> writeTest(String documentName, String testName, String toWrite) async {
    changePathExtension(documentName);
    changeFilename('_$testName.txt');
    final file = await _localFile;

    // Write the file
    return await file.writeAsString(toWrite, mode: FileMode.append, encoding: utf8 ,flush: true);
  }

  Future<File> writeUnit(String documentName, String unitName, String toWrite) async {
    changePathExtension(documentName);
    changeFilename('_$unitName.txt');
    final file = await _localFile;

    // Write the file
    return await file.writeAsString(toWrite, mode: FileMode.append, encoding: utf8 ,flush: true);
  }

  /*---Boolean file Checking, checks for the existence of Specific files---
  * checkForManifest() -> Checks the root directory if the manifest exists
  * */
  Future<bool> checkForManifest() async {
    setFileToManifest();
    return File(await _localPath + "/Manifest.txt").exists();
  }

  Future<bool> checkDocument(String documentName) async {
    setFileToManifest();
    return File(await _localPath + "/$documentName" + '_Document-Meta.txt').exists();
  }

  Future<bool> checkTest(String documentName, String testName) async {
    setFileToManifest();
    return File(await _localPath + "/$documentName" + '_$testName.txt').exists();
  }

  Future<bool> checkUnit(String documentName, String unitName) async {
    setFileToManifest();
    return File(await _localPath + "/$documentName" + '_$unitName.txt').exists();
  }
  /*---End Of file checking functions---*/

  //Updates the statedata object with the currentDocument
  Future<StateData> setStateData(StateData toRead) async{
    String toParse;
    List<String> tempLoc = [];
    toRead.testList = [];
    toRead.unitList = [];

    if(toRead.currentRoute == "/") {
      setFileToManifest();
      toParse = await readManifest();
      debugPrint("(FH) readManifest in SD: $toParse");

      toRead.list = toParse.split(",");
      if ((toRead.list[0] == "") && (toRead.list.length == 1)) {
        toRead.randomNumber = 0;
      } else {
        toRead.randomNumber = toRead.list.length;
      }
    } else {
      if (toRead.currentDocument != "") {
        setFileToDocument(toRead.currentDocument);
        toParse = await readDocument(toRead.currentDocument);
        tempLoc = toParse.split('\n');

        //--Debug
        //debugPrint("(FH)Updating SD: ${toRead.currentDocument}");
        //debugPrint("(FH)TemplocSize: ${tempLoc.length}");

        for (int i = 0; i < tempLoc.length; i++) {
          debugPrint("(FH)TempLoc[$i]: ${tempLoc[i]}");
        }

        toRead.testCount = int.parse(tempLoc[1]);
        toRead.unitCount = int.parse(tempLoc[2]);

        if (toRead.testCount != 0 || toRead.unitCount != 0) {
          tempLoc = tempLoc[3].split(',');
        }

        if (toRead.testCount != 0) {
          for (int i = 0; i < toRead.testCount; i++) {
            toRead.testList.add(tempLoc[i]);
          }
        }

        if (toRead.unitCount != 0) {
          for (int j = 0; j < toRead.unitCount; j++) {
            toRead.unitList.add(tempLoc[j + (toRead.testCount)]);
          }
        }
      }
    }
    return toRead;
  }
}