import 'package:flutter_driver/driver_extension.dart';

import 'package:blamo/main.dart' as blamo;

// This is the entry point for the flutter driver tests
void main() {
  enableFlutterDriverExtension();

  blamo.main();
}