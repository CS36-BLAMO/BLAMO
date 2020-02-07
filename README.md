![alt text](https://communications.oregonstate.edu/sites/communications.oregonstate.edu/files/osu-primarylogo-2-compressor.jpg)
# BLAMO - Borehole Logging Application Made for Oregon

This project is being developed as a senior capstone for use by Dr. Matthew Evans and associated parties, serves to modernize the data collection process of borehole logging operations. The application aims to provide mobile front-end interfaces for data collection and automated back-end functionality for data storage and conversion for use in the field by researchers in outdoor environments. Additionally it will help pipeline the collected data for use on the main project website [Ohelp Oregon State University Map](https://ohelp.oregonstate.edu/)

## Local Build 
### **Requirements**  
Android studio is the preferred IDE to run this project in. It simplifies creating the emulator phone  
1. IDE - Android Studio - [Download](https://developer.android.com/studio/install)   
2. Flutter and Dart plugins for IDE  - Can be downloaded inside Android Studio File-> Settings-> Plugins  

### **Emulator**  
To create a android emulator go to Tools->AVD Manager and click on create a virtual device. Any device should work and use the newest versions of system image. This device should show up in the upper bar next to the green play button  

### **Run Configuration**
In order to build the project and load it onto the emulator you must go to Run-> Edit Configuration -> + sign at the top left to create a new configuration -> pick Flutter

In this confugration you need to put the path to **<File location you downloaded/cloned on your pc>**\BLAMO\blamo\lib\main.dart  in the Dart entrypoint field  
**example:** C:\Users\Evan\Desktop\SeniorProj\BLAMO\blamo\lib\main.dart

Hit apply and then Ok. On the Upper middle of Android Studio there is 3 dropdowns next to the green Play button. Make sure a device is selected and your flutter config is selected. Click the green start button and it will automatically build and load onto the emulator.

#### Troubleshooting

If you're having trouble building and running the application make sure to check Settings-> Languages & Frameworks -> Click on Flutter and Dart and make sure they have the proper SDK path. If these are blank and the plugin doesn't manage that for you. You must manually download the SDK's for both Flutter and Dart and put the explicit path in the settings.

## Developed by James Trotter, Evan Amaya, Sean Spink, Alex Smith