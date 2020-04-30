import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'mathgo.dart';

//Resource Used for Google Map Implementation: https://codelabs.developers.google.com/codelabs/google-maps-in-flutter/#4

bool isSwitched = false;

void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, 
    DeviceOrientation.landscapeLeft, 
    DeviceOrientation.landscapeRight
  ]);

  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(MathGoApp());
}
