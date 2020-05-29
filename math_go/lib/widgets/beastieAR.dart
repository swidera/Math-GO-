import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:math_go/widgets/beastieMath.dart';
import 'package:math_go/widgets/mainMap.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
//import 'package:image/image.dart';
import '../widgets/mainMap.dart';
import '../widgets/beastieMath.dart';
import '../models/getBeasties.dart';

class BeastieAr extends StatefulWidget {
  @override
  final String loggedInUser;
  //final beastieInfo beastieName;
  //final String loggedInUser;
  final beastieInfo beastie;

  //TO DO: set constructor to take beastieInfo object and logged in user string
  const BeastieAr({Key key, this.loggedInUser, this.beastie}) : super(key: key);

  _BeastieArState createState() => _BeastieArState();
}

class _BeastieArState extends State<BeastieAr> {
  ArCoreController arCoreController;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("AR Screen"),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MathGo(widget.loggedInUser)),
              );
            },
          ),
        ),
        body: ArCoreView(
          onArCoreViewCreated: _onArCoreViewCreated,
          enableTapRecognizer: true,
        ),
      ),
    );
  }


  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    //TO DO: Set beastie constructor to pass Beastie Object and logged in User name
    arCoreController.onNodeTap = (name) => onTapHandler(widget.beastie.imageUrl);
    _addBeastie(arCoreController);
  }

  Future _addBeastie(ArCoreController controller) async {
    //TO DO: Set widget to load beastie.image url instead of passed in beastiename
    final ByteData textureBytes = await rootBundle.load(widget.beastie.imageUrl);

    final material = ArCoreMaterial(
      color: Color.fromARGB(120, 66, 134, 244),
      metallic: 1.0,
      textureBytes: textureBytes.buffer.asUint8List()
    );
    final cube = ArCoreCube(
      materials: [material],
      size: vector.Vector3(0.5, 0.5, 0.5),
    );
    final node = ArCoreNode(
      shape: cube,
      position: vector.Vector3(-0.5, 0.5, -3.5),
    );
    controller.addArCoreNode(node);
  }

  void onTapHandler(String name) {
    Navigator.push(
      context,
      //TO DO: set beastie math constructor to take in beastie info object and logged in user
      MaterialPageRoute(builder: (context) => BeastieMathProb(loggedInUser: widget.loggedInUser, beastie: widget.beastie))
    );
  }

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }
}