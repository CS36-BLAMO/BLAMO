import 'package:flutter/cupertino.dart';
import 'dart:convert';
//import 'package:blamo/CustomActionBar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:blamo/Boreholes/BoreholeList.dart';
import 'package:permission_handler/permission_handler.dart';
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
  String projectPrepend;
  int nameIterator;


  PersistentStorage(){
    fileName = "Manifest.txt";
    projectPrepend = "";
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

  void changeProjectName(String newProjectName){
    if(newProjectName == ""){
      projectPrepend = "";
    } else {
      projectPrepend = newProjectName + "_";
    }

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
    return File('$path/' + projectPrepend + pathExtension + fileName);
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
    debugPrint("(FH)Reading from: /" + projectPrepend + "$documentName"  + "_Document-Meta.txt\n");

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
    debugPrint("(FH)Reading from: /" + projectPrepend + "$documentName"  + "_$testName.txt\n");

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
    debugPrint("(FH)Reading from: /" + projectPrepend + "$documentName" + "_$unitName.txt\n");

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

    Future<String> readLogInfo(String documentName) async {
    //--Debug
    debugPrint("(FH)Reading from: /$projectPrepend"+ "$documentName" + "_LogInfo.txt\n");

    changePathExtension(documentName);
    changeFilename('_LogInfo.txt');
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

  Future<void> overWriteTest(String documentName, String testName,String toWrite) async {
    //--Debug
    debugPrint("(FH)Writing to: /$documentName" + "_$testName.txt\n\nContents: $toWrite\n");

    changePathExtension(documentName);
    changeFilename('_$testName.txt');
    final file = await _localFile;

    // Write the file
    return await file.writeAsString(toWrite);
  }

  Future<void> overWriteUnit(String documentName, String unitName, String toWrite) async {
    //--Debug
    debugPrint("(FH)Writing to: /$documentName" + "_$unitName.txt\n\nContents: $toWrite\n");

    changePathExtension(documentName);
    changeFilename('_$unitName.txt');
    final file = await _localFile;

    // Write the file
    return await file.writeAsString(toWrite);
  }

  Future<void> overWriteLogInfo(String documentName, String toWrite) async {
    //--Debug
    debugPrint("(FH)Writing to: /$documentName" + "_LogInfo.txt\n\nContents: $toWrite\n");

    changePathExtension(documentName);
    changeFilename('_LogInfo.txt');
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

  /* Deletion functions for removing Documents, Units, and Tests
  *  deleteProject      -> deletes the project, including all documents(renamed to boreholes)
  *  deleteDocument     -> deletes the document from the manifest and all of its correlated files
  *  deleteUnit         -> deletes an individual unit, takes in doc name and unit name
  *  deleteTest         -> deletes an individual test, takes in doc name and test name
  *  deleteLogInfo      -> deletes an individual loginfo, takes in doc name
  *  deleteDocumentMeta -> deletes an individual document-meta, takes in doc name
  * */

  Future<int> deleteProject(String projectName) async{
    changeProjectName(projectName);
    bool isProjectInit = await checkForManifest();
    List<String> tempLocProject = [];
    String toParseProjects = await readManifest();
    debugPrint("(FH) readManifest in SD: $toParseProjects");

    if(isProjectInit) {
      tempLocProject = toParseProjects.split(",");
      debugPrint("(FH)Project deletion list to delete from: ${tempLocProject
          .toString()}");
      for (int i = 0; i < tempLocProject.length; i++) {
        if(tempLocProject[i] != '') {
          debugPrint("(FH) deleting document: ${tempLocProject[i]}");
          await deleteProjectHelper(tempLocProject[i], projectName);
          await new Future.delayed(new Duration(microseconds: 10));
        }
      }


      await deleteProjectManifest();
      await new Future.delayed(new Duration(microseconds: 5));
    }
    changeProjectName("");
    toParseProjects = await readManifest();
    tempLocProject = toParseProjects.split(",");
    //Remove documentName from manifest
    toParseProjects = "";
    debugPrint("(FH)Project deletion list to build new manifest from: ${tempLocProject.toString()}");
    for(int i = 0; i < tempLocProject.length; i++){
      if(tempLocProject[i] != projectName && tempLocProject[i] != ''){
        debugPrint("(FH) Adding ${tempLocProject[i]} to new document manifest");
        toParseProjects += tempLocProject[i] + ",";
      }
    }

    await overWriteManifest(toParseProjects);
    await new Future.delayed(new Duration(microseconds: 3));
    return 0;
  }

  Future<int> deleteProjectHelper(String documentName, String projectName) async {
    //getFile arch for document manifest and unit/test list
    StateData tempStateData = new StateData("");
    tempStateData.currentDocument = documentName;
    tempStateData.currentProject = projectName;
    changeProjectName(projectName);
    tempStateData = await setStateData(tempStateData);

    //Delete the units from the unitList
    for(int i = 0; i < tempStateData.unitList.length; i++){
      debugPrint("(FH)Document Deletion - Deleting Unit: ${tempStateData.unitList[i]}");
      await deleteUnit(documentName, tempStateData.unitList[i]);
    }

    //Delete the tests from the testList
    for(int i = 0; i < tempStateData.testList.length; i++){
      debugPrint("(FH)Document Deletion - Deleting test: ${tempStateData.testList[i]}");
      await deleteTest(documentName, tempStateData.testList[i]);
    }

    //Delete documentmeta manifest
    await deleteDocumentMeta(documentName);

    //Delete logInfo
    await deleteLogInfo(documentName);

    return 0;
  }

  Future<int> deleteDocument(String documentName, String projectName) async {
    //getFile arch for document manifest and unit/test list
    StateData tempStateData = new StateData("");
    tempStateData.currentDocument = documentName;
    tempStateData.currentProject = projectName;
    changeProjectName(projectName);
    tempStateData = await setStateData(tempStateData);
    String manifestString = "";

    //Delete the units from the unitList
    for(int i = 0; i < tempStateData.unitList.length; i++){
      debugPrint("(FH)Document Deletion - Deleting Unit: ${tempStateData.unitList[i]}");
      await deleteUnit(documentName, tempStateData.unitList[i]);
    }

    //Delete the tests from the testList
    for(int i = 0; i < tempStateData.testList.length; i++){
      debugPrint("(FH)Document Deletion - Deleting test: ${tempStateData.testList[i]}");
      await deleteTest(documentName, tempStateData.testList[i]);
    }


    //Delete documentmeta manifest
    await deleteDocumentMeta(documentName);

    //Delete logInfo
    await deleteLogInfo(documentName);

    //
    tempStateData.currentRoute = "/";
    tempStateData = await setStateData(tempStateData);

    //Remove documentName from manifest
    for(int i = 0; i < tempStateData.list.length; i++){
      if(tempStateData.list[i] != documentName && tempStateData.list[i] != ""){
        debugPrint("(FH) Adding ${tempStateData.list[i] + ","} to new document manifest");
        manifestString += tempStateData.list[i] + ",";
      }
    }
    overWriteManifest(manifestString);

    return 0;
  }

  Future<int> deleteTest(String documentName, String testName) async {
    File fp = File(await _localPath + "/$projectPrepend" + documentName + '_$testName.txt');
    try {
      await fp.delete();
      return 0;
    } catch(e) {
      debugPrint("(FH)Deletion of Test failed with error: ${e.toString()}");
      return 1;
    }
  }

  Future<int> deleteUnit(String documentName, String unitName) async {
    File fp = File(await _localPath + "/$projectPrepend" + documentName + '_$unitName.txt');
    try {
      await fp.delete();
      return 0;
    } catch(e) {
      debugPrint("(FH)Deletion of Unit failed with error: ${e.toString()}");
      return 1;
    }
  }

  Future<int> deleteLogInfo(String documentName) async {
    File fp = File(await _localPath + "/$projectPrepend" + documentName + '_LogInfo.txt');
    try {
      await fp.delete();
      return 0;
    } catch(e) {
      debugPrint("(FH)Deletion of Log Info failed with error: ${e.toString()}\n--PathVariables--\nProject: $projectPrepend\nDocument: $documentName\n");
      return 1;
    }
  }

  Future<int> deleteDocumentMeta(String documentName) async {
    File fp = File(await _localPath + "/$projectPrepend" + documentName + '_Document-Meta.txt');
    try {
      await fp.delete();
      return 0;
    } catch(e) {
      debugPrint("(FH)Deletion of Document Meta failed with error: ${e.toString()}");
      return 1;
    }
  }

  Future<int> deleteProjectManifest() async {
    File fp = File(await _localPath + "/$projectPrepend" + 'Manifest.txt');
    try {
      await fp.delete();
      return 0;
    } catch(e) {
      debugPrint("(FH)Deletion of Project Manifest failed with error: ${e.toString()}");
      return 1;
    }
  }

  /*---End Of file deletion functions---*/

  /*---Boolean file Checking, checks for the existence of Specific files---
  * checkForManifest() -> Checks the root directory if the manifest exists
  * */
  Future<bool> checkForManifest() async {
    setFileToManifest();
    return File(await _localPath + "/$projectPrepend" + "Manifest.txt").exists();
  }

  Future<bool> checkDocument(String documentName) async {
    setFileToManifest();
    return File(await _localPath + "/$projectPrepend" + documentName + '_Document-Meta.txt').exists();
  }

  Future<bool> checkTest(String documentName, String testName) async {
    setFileToManifest();
    return File(await _localPath + "/$projectPrepend" + "$documentName" + '_$testName.txt').exists();
  }

  Future<bool> checkUnit(String documentName, String unitName) async {
    setFileToManifest();
    return File(await _localPath + "/$projectPrepend" + "$documentName" + '_$unitName.txt').exists();
  }
  /*---End Of file checking functions---*/

  //Updates the statedata object with the currentDocument
  Future<StateData> setStateData(StateData toRead) async {
    String toParse;
    List<String> tempLoc = [];
    toRead.testList = [];
    toRead.unitList = [];
    changeProjectName(toRead.currentProject);
    if(toRead.currentRoute == "/" || toRead.currentRoute == "/BoreholeList") {
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
  Future<bool> checkForFile(String documentName, String extension) async{
    PermissionStatus permission =
    await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    if (permission.toString() != "PermissionStatus.granted") {
      Map<PermissionGroup, PermissionStatus> permissions =
      await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    }
    await new Future.delayed(new Duration(milliseconds: 50));
    permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    if (permission.toString() != "PermissionStatus.granted"){
      print("Permission denied. PDF write cancelled."); // TODO - Better handle permission denied case.
    } else {
      final output = await getExternalStorageDirectory();
      String filepath = "${output.path}/$projectPrepend$documentName.$extension";
      return File(filepath).exists();
    }
    return false;
  }

  Future<String> getPathToFile(String documentName, String extension) async{
    PermissionStatus permission =
    await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    if (permission.toString() != "PermissionStatus.granted") {
      Map<PermissionGroup, PermissionStatus> permissions =
      await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    }
    await new Future.delayed(new Duration(milliseconds: 50));
    permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    if (permission.toString() != "PermissionStatus.granted"){
      print("Permission denied. PDF write cancelled."); // TODO - Better handle permission denied case.
    } else {
      final output = await getExternalStorageDirectory();
      String filepath = "${output.path}/$projectPrepend$documentName.$extension";
      return filepath;
    }
    return null;
  }
}