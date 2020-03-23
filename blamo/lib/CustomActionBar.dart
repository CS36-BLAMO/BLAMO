import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

class CustomActionBar{
  final String headerText;

  CustomActionBar(this.headerText);

  GradientAppBar getAppBar(){
    return new GradientAppBar(
        title: new Text(headerText),
      backgroundColorStart: Colors.deepOrange,
      backgroundColorEnd: Colors.orange,
    );
  }

}