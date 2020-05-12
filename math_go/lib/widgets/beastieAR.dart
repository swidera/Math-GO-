import 'dart:io';
import 'package:flutter/services.dart'
import 'package:arcore_plugin/arcore_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class _BeastieArState extends State<BeastieAr> {
 
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      //app bar 
      appBar: AppBar(
        title: Text('AR Screen'),
        backgroundColor: Colors.orange
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.map),
                title: Text('Home'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.child_care),
                title: Text('Beasties'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.score),
                title: Text('Score'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.map),
                title: Text('Leaderboard'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.system_update_alt),
                title: Text('Logout'),
              ),
            ],
            currentIndex: pageIndex,
            selectedItemColor: Colors.deepOrangeAccent,
            onTap: changePage,
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
    );
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