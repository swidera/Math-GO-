import 'package:flutter/material.dart';
import 'package:math_go/screens/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main(){

bool isSwitched = false;

WidgetsFlutterBinding.ensureInitialized();
 
SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, 
    DeviceOrientation.landscapeLeft, 
    DeviceOrientation.landscapeRight
  ]);

runApp(
  loginScreen()
  );
}
