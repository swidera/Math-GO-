//import 'dart:io';
import 'package:arcore_plugin/arcore_plugin.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'dart:async';
import 'mainMap.dart';

class _BeastieArState extends State<BeastieAr> {
  //AR Variables
  String recongizedImage;
  ArCoreViewController arCoreViewController;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      //app bar 
      appBar: AppBar(
        title: Text('AR Screen'),
        backgroundColor: Colors.orange,
        centerTitle: true,
        leading: new IconButton ( 
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push( 
              context,
              MaterialPageRoute(builder: (context) => MathGo())
            );
          },
        ),
      ),
      body: Center(
          child: ArCoreView(
          focusBox: Container(
            width: screenSize.width * 0.5,
            height: screenSize.width * 0.5,
            decoration: BoxDecoration(
                border: Border.all(width: 1, style: BorderStyle.solid)),
          ),
          width: screenSize.width,
          height: screenSize.height,
          onImageRecognized: _onImageRecognized,
          onArCoreViewCreated: _onTextViewCreated,
        )));
  }

  void _onTextViewCreated(ArCoreViewController controller) {
    arCoreViewController = controller;
    controller.getArCoreView();
  }

  void _onImageRecognized(String recImgName) {
    print("image recongized: $recImgName");

    // you can pause the image recognition via arCoreViewController.pauseImageRecognition();
    // resume it via arCoreViewController.resumeImageRecognition();
  }
}

class BeastieAr extends StatefulWidget {
  final String title;

  const BeastieAr({Key key, this.title}) : super(key: key);

  State createState() => _BeastieArState();
}