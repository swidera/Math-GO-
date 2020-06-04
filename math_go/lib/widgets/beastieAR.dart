import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:math_go/widgets/beastieMath.dart';
import 'package:math_go/widgets/mainMap.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
import '../widgets/mainMap.dart';
import '../widgets/beastieMath.dart';
import '../models/getBeasties.dart';

class BeastieAr extends StatefulWidget {
  @override
  final String loggedInUser;
  final beastieInfo beastie;

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
          title: Text("Wild Beastie Appeared..."),
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
    //create ar core controller
    arCoreController = controller;
    //create on tap handler for capture screen
    arCoreController.onNodeTap = (name) => onTapHandler();
    //add beastie to environment
    _addBeastie(arCoreController);
  }
  //add beastie function to add "3d" beastie to environment
  Future _addBeastie(ArCoreController controller) async {
    //load beastie.image url as ByteData
    final ByteData textureBytes = await rootBundle.load('assets/' + widget.beastie.imageUrl);
    //set ar core material
    final material = ArCoreMaterial(
      color: Color.fromARGB(120, 66, 134, 244),
      metallic: 1.0,
      //texture will be png beastie
      textureBytes: textureBytes.buffer.asUint8List()
    );
    //add material to cube
    final cube = ArCoreCube(
      materials: [material],
      size: vector.Vector3(0.75, 0.75, 0.75),
    );
    //set position of node
    final node = ArCoreNode(
      shape: cube,
      position: vector.Vector3(-0.5, 0.5, -3.5),
    );
    //add node to controller
    controller.addArCoreNode(node);
  }
  //on tap handler to direct to math screen
  void onTapHandler() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BeastieMathProb(loggedInUser: widget.loggedInUser, beastie: widget.beastie))
    );
  }
  //dispose of controller
  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }
}