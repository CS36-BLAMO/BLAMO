import 'package:blamo/LogInfo/loginfo.dart';
import 'package:blamo/main.dart';
import 'package:flutter/material.dart';
import 'package:blamo/Unit/unit.dart';
import 'package:blamo/Unit/units.dart';
import 'package:blamo/Boreholes/BoreholeList.dart';
import 'package:blamo/Export/index.dart';
import 'package:blamo/Test/test.dart';
import 'package:blamo/Document/overview.dart';
import 'package:blamo/Test/tests.dart';

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
      case '/BoreholeList':
        return MaterialPageRoute(builder: (_) => BoreholePage(args));
        break;
      case "/ExportPage":
        return MaterialPageRoute(builder: (_) => ExportPage(args));
        break;
      case "/LogInfoPage":
        return MaterialPageRoute(builder: (_) => LogInfoPage(args));
        break;
      case "/UnitsPage":
        return MaterialPageRoute(builder: (_) => UnitsPage(args));
        break;
      case "/UnitPage":
        return MaterialPageRoute(builder: (_) => UnitPage(args));
        break;
      case "/TestPage":
        return MaterialPageRoute(builder: (_) => TestPage(args));
        break;
      case "/TestsPage":
        return MaterialPageRoute(builder: (_) => TestsPage(args));
        break;
      case "/Document":
        return MaterialPageRoute(builder: (_) => DocumentPage(args));
        break;
    }
    return null;
  }
}