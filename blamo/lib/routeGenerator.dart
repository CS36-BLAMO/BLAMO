import 'package:flutter/material.dart';
import 'package:blamo/main.dart';
import 'package:blamo/Export/index.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings){
    var args;

    if(settings.arguments == null){
      args = StateData('/');
    } else {
      args = settings.arguments;
    }

    switch (settings.name){
      case '/':
        return MaterialPageRoute(builder: (_) => HomePage(args));
        break;
      case "/ExportPage":
        return MaterialPageRoute(builder: (_) => ExportPage(args));
        break;
    }
    return null;
  }
}