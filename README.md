![alt text](https://communications.oregonstate.edu/sites/communications.oregonstate.edu/files/osu-primarylogo-2-compressor.jpg)    
# BLAMO - Borehole Logging Application Made for Oregon    
 This project is being developed as a senior capstone for use by Dr. Matthew Evans and associated parties, serves to modernize the data collection process of borehole logging operations. The application aims to provide mobile front-end interfaces for data collection and automated back-end functionality for data storage and conversion for use in the field by researchers. Additionally it will help pipeline the collected data for use on the main project website [Ohelp Oregon State University Map](https://ohelp.oregonstate.edu/)    
    
## Development  
This project is developed with the Flutter SDK by Google. The primary goal of the Flutter SDK is to develop and create cross-platform mobile applications. The code is written in Dart which is also developed by Google and is a derivation of Java. Below are resources to get started in development with Flutter/Dart as well as general mobile application development resources.  
  
- [Getting Started with Flutter](https://flutter.dev/docs/get-started/install/windows)  
- [Widget Examples](https://flutter.github.io/gallery/#/)  
- [Dart Documentation](https://dart.dev/guides)  
- [Flutter Youtube](https://www.youtube.com/channel/UCwXdFgeE9KYzlDdR7TG9cMw)  
- [Understanding Mobile Page Lifecycles](https://developer.android.com/guide/components/activities/activity-lifecycle)  

### Requirements 
[Getting Started with Flutter](https://flutter.dev/docs/get-started/install/windows) will take you through the steps of setting up your environment to be able to develop locally and run the application. A few key things to note is that you can program in any IDE you wish but you are required to have Android Studio downloaded on your PC. Android Studio allows you to run the various emulators through their [Android Virtual Device Manager](https://developer.android.com/studio/run/managing-avds). Android Studio also has a Flutter and Dart plugin with various features that assist in development.  
    
### Running Application 
Once you have a running emulator you can build the project and run it on either Android Studio or through the Flutter CLI.
* **Android Studio** -  If you want to run in Android Studio you will need to create a [configuration](https://developer.android.com/studio/run/rundebugconfig) that has the Dart Entry point path being **\main.dart** in the project. Then [run](https://flutter.dev/docs/get-started/test-drive) the project using the hotbar in the upper right hand corner. Make sure you have the proper device selected and if there are no devices then you either need to select an emulator in the dropdown or follow the steps above in creating an emulator through the Android Virtual Device Manager.
* **Flutter CLI** - To run through the Flutter CLI the only requirement is that the working directory must be the same level as the pubspec.yaml in the project (\BLAMO\blamo). Then you simply input the command  **flutter run** and it will build and run the application on your running emulator. More details can be found here in the Flutter documents [Flutter CLI](https://flutter.dev/docs/development/tools/devtools/cli).
	* The other two useful commands to use in the CLI:
		* flutter clean - Clears build cache(Important for upgrading dependency and general build errors)
		* flutter doctor - Status check for all components related to the flutter project
#### Troubleshooting    
 - **Android Studio** If you're having trouble building and running the application make sure to check Settings-> Languages & Frameworks -> Click on Flutter and Dart and make sure they have the proper SDK path. If these are blank and the plugin doesn't manage that for you. You must manually download the SDK's for both Flutter and Dart and put the explicit path in the settings.    

### Testing Application
We have developed an automated group of tests that cover the entire workflow of the app. In order to run these tests you must first start an emulator. Then run the command `flutter driver --target=test_driver/blamo.dart` from the /BLAMO/blamo directory. Unfortunately, flutter driver currently provides no way to interact with system dialogues, so you must manually allow file access permission each time the test is run; this dialog will pop up during the test of the export page. Additionally, there is a 30 second window at the end of the export test where you can manually send the documents created by the test.

#### Developed by James Trotter, Evan Amaya, Sean Spink, Alex Smith