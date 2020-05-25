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

class BeastieAr extends StatefulWidget {
  @override
  final String title;
  final String beastieName;

  const BeastieAr({Key key, this.title, this.beastieName}) : super(key: key);

  _BeastieArState createState() => _BeastieArState();
}

class _BeastieArState extends State<BeastieAr> {
  ArCoreController arCoreController;
  String loggedInUser ='';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MathGo(loggedInUser)),
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
    arCoreController.onNodeTap = (name) => onTapHandler(widget.beastieName);
    _addBeastie(arCoreController);
  }

  Future _addBeastie(ArCoreController controller) async {
    final ByteData textureBytes = await rootBundle.load(widget.beastieName);

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
      MaterialPageRoute(builder: (context) => BeastieMathProb(title: 'Math Problem Screen', beastieID: '0KWJpU5owfk1nMrw4ucd'))
    );
  }

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }
}