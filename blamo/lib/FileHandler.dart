//import 'package:flutter/cupertino.dart';
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
    fileName = "Manifest";
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

  void setFileToDocument(int documentNumber){
    fileName="Document-Meta.txt";
    pathExtension="Document$documentNumber/";
    nameIterator = 0;
  }

  /*These next three functions should only be called from when in a document
  * i.e. pathExtension is already established with a Document$documentNumber
  * */
  void setFileToUnit(int unitNumber){
    fileName="Unit$unitNumber.txt";
    nameIterator = 0;
  }

  void setFileToTest(int testNumber){
    fileName="Test$testNumber.txt";
    nameIterator = 0;
  }

  void setFileToLogInfo(){
    fileName="LogInfo.txt";
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
    return File('$path/$pathExtension$fileName');
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

  Future<String> readDocument(int documentNumber) async {
    changePathExtension('Document$documentNumber/');
    changeFilename('Document-Meta.txt');
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

  Future<String> readTest(int documentNumber, int testNumber) async {
    changePathExtension('Document$documentNumber/');
    changeFilename('Test$testNumber.txt');
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

  Future<String> readUnit(int documentNumber, int unitNumber) async {
    changePathExtension('Document$documentNumber/');
    changeFilename('Unit$unitNumber.txt');
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
    setFileToManifest();
    final file = await _localFile;

    // Write the file
    return file.writeAsString(toWrite);
  }

  Future<File> overWriteDocument(int documentNumber, String toWrite) async {
    changePathExtension('Document$documentNumber/');
    changeFilename('Document-Meta.txt');
    final file = await _localFile;

    // Write the file
    return file.writeAsString('Document$documentNumber');
    //return file.writeAsString(toWrite);
  }

  Future<File> overWriteTest(int documentNumber, int testNumber,String toWrite) async {
    changePathExtension('Document$documentNumber/');
    changeFilename('Test$testNumber.txt');
    final file = await _localFile;

    // Write the file
    return file.writeAsString(toWrite);
  }

  Future<File> overWriteUnit(int documentNumber, int unitNumber, String toWrite) async {
    changePathExtension('Document$documentNumber/');
    changeFilename('Unit$unitNumber.txt');
    final file = await _localFile;

    // Write the file
    return file.writeAsString(toWrite);
  }
  /*---End OverWrite Block---*/

  /*---Boolean file Checking, checks for the existence of Specific files---
  * checkForManifest() -> Checks the root directory if the manifest exists
  * */
  Future<bool> checkForManifest() async {
    setFileToManifest();
    return File(await _localPath + "/Manifest.txt").exists();
  }
  /*---End Of file checking functions---*/

  Future<StateData> setStateData(StateData toRead) async{
    String toParse;
    toParse = await readManifest();
    toRead.list = toParse.split(",");
    if((toRead.list[0] == "") && (toRead.list.length == 1)){
      toRead.randomNumber = 0;
    } else {
      toRead.randomNumber = toRead.list.length;
    }
    return toRead;
  }
}