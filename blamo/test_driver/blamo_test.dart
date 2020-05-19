import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

// How to perform flutter drive tests:
// Open emulator
// run flutter drive --target=test_driver/blamo.dart
// note: you must manually allow blamo access to files every time during the export test
void main() {

  // Takes a screenshot of the emulator screen and saves it to screenshots folder
  // Screenshots can be used to inspect ui elements after the tests have been run
  Future<void> takeScreenshot(FlutterDriver driver, String path) async {
    final List<int> pixels = await driver.screenshot();
    final File file = new File(path);
    await file.writeAsBytes(pixels);
  }

  // Helper function that creates project and opens it
  Future<void> createProject(FlutterDriver driver) async {
    final newProjectFinder = find.byValueKey('newProject');
    final projectTextFieldFinder = find.byValueKey('projectTextField');
    final projectAcceptFinder = find.byValueKey('projectAccept');
    //create project and navigate to borehole list
    await driver.tap(newProjectFinder);
    await driver.tap(projectTextFieldFinder);
    await driver.enterText('uniqueProjectName');
    await driver.waitFor(find.text('uniqueProjectName'));
    await driver.tap(projectAcceptFinder);
    final projectFinder = find.byValueKey('project_uniqueProjectName');
    await driver.tap(projectFinder);
  }

  // Helper function that creates a borehole
  Future<void> createBorehole(FlutterDriver driver) async {
    final newBoreholeFinder = find.byValueKey('newBorehole');
    await driver.tap(newBoreholeFinder);
  }

  // This group of tests covers the entire workflow of the app
  group('BLAMO App', () {
    // Finders are used to locate ui elements
    final newProjectFinder = find.byValueKey('newProject');
    final projectTextFieldFinder = find.byValueKey('projectTextField');
    final projectAcceptFinder = find.byValueKey('projectAccept');

    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
      new Directory('screenshots').create();
    });

    tearDownAll(() async {
      if(driver != null) {
        driver.close();
      }
    });

    // This tests project creation and deletion
    test('create and delete project', () async {
      await driver.tap(newProjectFinder);
      await takeScreenshot(driver, 'screenshots/test1_screenshot1.png');
      await driver.tap(projectTextFieldFinder);
      await takeScreenshot(driver, 'screenshots/test1_screenshot2.png');
      await driver.enterText('uniqueProjectName');
      await driver.waitFor(find.text('uniqueProjectName'));
      await takeScreenshot(driver, 'screenshots/test1_screenshot3.png');
      await driver.tap(projectAcceptFinder);
      final projectFinder = find.byValueKey('project_uniqueProjectName');
      await takeScreenshot(driver, 'screenshots/test1_screenshot4.png');
      await driver.tap(projectFinder);
      await takeScreenshot(driver, 'screenshots/test1_screenshot5.png');
      final drawerOpenFinder = find.byTooltip('Open navigation menu');
      await driver.tap(drawerOpenFinder);
      final homeNavFinder = find.byValueKey('homeNav');
      await driver.tap(homeNavFinder);
      // There is no native way to long press a ui element with flutter driver
      // This is a workaround, scrolling for half a second while not moving
      await driver.scroll(projectFinder, 0, 0, Duration(milliseconds: 500));
      await takeScreenshot(driver, 'screenshots/test1_screenshot6.png');
      final projectDeleteFinder = find.byValueKey('projectDelete');
      await driver.tap(projectDeleteFinder);
      await takeScreenshot(driver, 'screenshots/test1_screenshot7.png');
    });

    // This tests borehole creation and deletion
    test('create and delete borehole', () async {
      createProject(driver);
      //create and delete borehole
      final newBoreholeFinder = find.byValueKey('newBorehole');
      await driver.tap(newBoreholeFinder);
      await takeScreenshot(driver, 'screenshots/test2_screenshot1.png');
      final drawerOpenFinder = find.byTooltip('Open navigation menu');
      await driver.tap(drawerOpenFinder);
      final boreholeListNavFinder = find.byValueKey('boreholeListNav');
      await driver.tap(boreholeListNavFinder);
      await takeScreenshot(driver, 'screenshots/test2_screenshot2.png');
      final boreholeFinder = find.byValueKey('borehole_BH_1');
      await driver.scroll(boreholeFinder, 0, 0, Duration(milliseconds: 500));
      await takeScreenshot(driver, 'screenshots/test2_screenshot3.png');
      final boreholeDeleteFinder = find.byValueKey('boreholeDelete');
      await driver.tap(boreholeDeleteFinder);
      await takeScreenshot(driver, 'screenshots/test2_screenshot4.png');
    });

    // This test navigates to the log info form and then enters info into all
    // fields before saving.
    test('LogInfo', () async {
      createBorehole(driver);
      //enter text in LogInfo
      final drawerOpenFinder = find.byTooltip('Open navigation menu');
      await driver.tap(drawerOpenFinder);
      final logInfoNavFinder = find.byValueKey('loginfoNav');
      await driver.tap(logInfoNavFinder);
      await takeScreenshot(driver, 'screenshots/test3_screenshot1.png');
      var fieldKeys = ['client', 'highway', 'county', 'north', 'east', 'lat',
        'long', 'location', 'elevationDatum', 'tubeHeight', 'boreholeID',
        'surfaceElevation', 'contractor', 'equipment', 'method', 'loggedBy',
        'checkedBy'];
      var fieldInputs = ['client', 'highway', 'county', '10000.00', '9999.99',
        '-122.00', '45.00', 'location', 'elevationDatum', '100', 'boreholeID',
        '12345.5', 'contractor', 'equipment', 'method', 'loggedBy', 'checkedBy'];
      // Go through all text fields
      for(int i = 0; i < fieldKeys.length; i++) {
        SerializableFinder formFieldFinder = find.byValueKey(fieldKeys[i] + 'Field');
        await driver.waitFor(formFieldFinder);
        await driver.scrollIntoView(formFieldFinder, alignment: 0, timeout: Duration(seconds: 10));
        await driver.tap(formFieldFinder);
        await driver.enterText(fieldInputs[i]);
      }

      final projectionDropdownFinder = find.byValueKey('projectionField');
      final startDateFinder = find.byValueKey('startDateField');
      final endDateFinder = find.byValueKey('endDateField');

      // Interact with projection dropdown
      await driver.scrollIntoView(projectionDropdownFinder, alignment: 0, timeout: Duration(seconds: 10));
      await driver.tap(projectionDropdownFinder);
      final selectProjectionFinder = find.byValueKey('projection_GCS WGS 1984');
      await driver.tap(selectProjectionFinder);

      // Interact with both date pickers
      await driver.scrollIntoView(startDateFinder, alignment: 0, timeout: Duration(seconds: 10));
      await driver.tap(startDateFinder);
      final startDateOkFinder = find.text('OK');
      await driver.tap(startDateOkFinder);

      await driver.scrollIntoView(endDateFinder, alignment: 0, timeout: Duration(seconds: 10));
      await driver.tap(endDateFinder);
      final endDateDayFinder = find.text('30');
      await driver.tap(endDateDayFinder);
      final endDateOkFinder = find.text('OK');
      await driver.tap(endDateOkFinder);

      final saveLogInfoFinder = find.byValueKey('saveLogInfo');
      await driver.tap(saveLogInfoFinder);
      await takeScreenshot(driver, 'screenshots/test3_screenshot2.png');

      await driver.tap(drawerOpenFinder);
      final overviewNavFinder = find.byValueKey('overviewNav');
      await driver.tap(overviewNavFinder);
      final dialogFinder = find.text('Yes');
      await driver.tap(dialogFinder);
    }, timeout: Timeout(Duration(minutes: 1)));

    // This test creates 10 units and enter info for all of them then deletes
    // the last unit
    test('Units', () async {
      final drawerOpenFinder = find.byTooltip('Open navigation menu');
      await driver.tap(drawerOpenFinder);
      final unitsNavFinder = find.byValueKey('unitsNav');
      await driver.tap(unitsNavFinder);

      await takeScreenshot(driver, 'screenshots/test4_screenshot1.png');
      for(int i = 0; i < 10; i++) {
        SerializableFinder newUnitFinder = find.byTooltip('New Unit');
        await driver.tap(newUnitFinder);

        SerializableFinder depthUBFinder = find.byValueKey('depth-ubField');
        SerializableFinder depthLBFinder = find.byValueKey('depth-lbField');
        SerializableFinder methodsFinder = find.byValueKey('methodsField');
        SerializableFinder notesFinder = find.byValueKey('notesField');
        SerializableFinder asphaltFinder = find.byValueKey('unitAsphaltTag');

        await driver.tap(depthUBFinder);
        await driver.enterText('-' + i.toString());
        await driver.tap(depthLBFinder);
        await driver.enterText('-' + (i+1).toString());
        await driver.tap(methodsFinder);
        await driver.enterText('methods' + i.toString());
        await driver.tap(notesFinder);
        await driver.enterText('Very long set of notes\nwith a few\nnewlines thrown in\nfor good measure\nthe end');
        await driver.tap(asphaltFinder);

        SerializableFinder saveUnitFinder = find.byValueKey('saveUnit');
        await driver.tap(saveUnitFinder);
        SerializableFinder backOutFinder = find.pageBack();
        await driver.tap(backOutFinder);
        SerializableFinder dialogFinder = find.text('Yes');
        await driver.tap(dialogFinder);
      }
      await takeScreenshot(driver, 'screenshots/test4_screenshot2.png');

      final unitToDeleteFinder = find.byValueKey('unit_10');
      await driver.scroll(unitToDeleteFinder, 0, 0, Duration(milliseconds: 500));
      final deleteUnitFinder = find.byValueKey('deleteUnit');
      await driver.tap(deleteUnitFinder);

      sleep(Duration(seconds: 2));

      await driver.tap(drawerOpenFinder);
      final overviewNavFinder = find.byValueKey('overviewNav');
      await driver.tap(overviewNavFinder);
    }, timeout: Timeout(Duration(minutes: 1)));

    // This test creates 10 tests and enter info for all, then deletes the last test
    test('Tests', () async {
      final drawerOpenFinder = find.byTooltip('Open navigation menu');
      await driver.tap(drawerOpenFinder);
      final testsNavFinder = find.byValueKey('testsNav');
      await driver.tap(testsNavFinder);

      await takeScreenshot(driver, 'screenshots/test5_screenshot1.png');

      var fieldKeys = ['testType', 'perRec', 'sdr', 'rdd', 'rqd', 'mCon',
        'dryDensity', 'liquidLimit', 'plasticLimit', 'fines', 'blows1',
        'blows2', 'blows3', 'blowCount'];
      var fieldInputs = ['testType', '99.9', '10.0', '20.0', '30.0', '40.0',
        '50.0', '60.0', '70.0', '80.0', '1', '2', '3', '5'];

      for(double i = 0; i < 10; i++) {
        SerializableFinder newTestFinder = find.byTooltip('New Test Document');
        await driver.tap(newTestFinder);

        SerializableFinder beginTestFinder = find.byValueKey('beginTestField');
        SerializableFinder endTestFinder = find.byValueKey('endTestField');
        await driver.tap(beginTestFinder);
        await driver.enterText('-' + (i+0.1).toString());
        await driver.tap(endTestFinder);
        await driver.enterText('-' + (i+0.9).toString());
        for(int j = 0; j < fieldKeys.length; j++) {
          SerializableFinder formFieldFinder = find.byValueKey(fieldKeys[j] + 'Field');
          await driver.scrollIntoView(formFieldFinder, alignment: 0, timeout: Duration(seconds: 10));
          await driver.tap(formFieldFinder);
          await driver.enterText(fieldInputs[j]);
        }
        SerializableFinder testAsphaltFinder = find.byValueKey('testAsphaltTag');
        await driver.tap(testAsphaltFinder);

        SerializableFinder saveTestFinder = find.byValueKey('saveTest');
        await driver.tap(saveTestFinder);
        SerializableFinder backOutFinder = find.pageBack();
        await driver.tap(backOutFinder);
        SerializableFinder dialogFinder = find.text('Yes');
        await driver.tap(dialogFinder);
      }
      await takeScreenshot(driver, 'screenshots/test5_screenshot2.png');

      final testToDeleteFinder = find.byValueKey('test_10');
      await driver.scroll(testToDeleteFinder, 0, 0, Duration(milliseconds: 500));
      final deleteTestFinder = find.byValueKey('deleteTest');
      await driver.tap(deleteTestFinder);

      sleep(Duration(seconds: 2));

      await driver.tap(drawerOpenFinder);
      final overviewNavFinder = find.byValueKey('overviewNav');
      await driver.tap(overviewNavFinder);
    }, timeout: Timeout(Duration(minutes: 5)));

    // This tests the functions of the export page, including pdf and csv creation
    // as well as the email button. There is no way to automate email sending, so
    // there is a 30 second window to manually send an email if need be.
    test('Export', () async {
      final drawerOpenFinder = find.byTooltip('Open navigation menu');
      await driver.tap(drawerOpenFinder);
      final exportNavFinder = find.byValueKey('exportNav');
      await driver.tap(exportNavFinder);

      await takeScreenshot(driver, 'screenshots/test6_screenshot1.png');

      final savePDFFinder = find.byValueKey('savePDF');
      final saveCSVFinder = find.byValueKey('saveCSV');
      final sendEmailFinder = find.byValueKey('sendEmail');
      final docDropdownFinder = find.byValueKey('docDropdown');
      final typeDropdownFinder = find.byValueKey('typeDropdown');

      //after this next tap, you must manually allow file access
      //there is no way for flutter driver to interact with system dialogs
      await driver.tap(savePDFFinder);

      await driver.tap(docDropdownFinder);
      final selectDocFinder = find.byValueKey('doc_BH_1');
      await driver.tap(selectDocFinder);
      await takeScreenshot(driver, 'screenshots/test6_screenshot2.png');
      await driver.tap(saveCSVFinder);
      await driver.tap(typeDropdownFinder);
      final selectTypeFinder = find.byValueKey('type_both');
      await driver.waitFor(selectTypeFinder);
      await driver.tap(selectTypeFinder);
      await takeScreenshot(driver, 'screenshots/test6_screenshot3.png');
      await driver.tap(sendEmailFinder);
      //30 second window to send email manually, if you want to
      sleep(Duration(seconds: 30));
    }, timeout: Timeout(Duration(minutes: 2)));

  });
} 