import 'package:flutter/material.dart';

// Template theme for application
// Allows continuity between colors/settings
// Long list of properties for ThemeData class
// Use this to unify all colors/text/other styling in the application easily
final ThemeData appTheme = new ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    primaryColorBrightness: Brightness.light,
    accentColor: Colors.grey,
    accentColorBrightness: Brightness.light
);