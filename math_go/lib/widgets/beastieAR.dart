import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
//import 'package:image/image.dart';

class BeastieAr extends StatefulWidget {
  @override
  _BeastieArState createState() => _BeastieArState();
}

class _BeastieArState extends State<BeastieAr> {
  ArCoreController arCoreController;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Hello World'),
        ),
        body: ArCoreView(
          onArCoreViewCreated: _onArCoreViewCreated,
        ),
      ),
    );
  }


  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;

    _addBeastie(arCoreController);
  }

  Future _addBeastie(ArCoreController controller) async {
    final ByteData textureBytes = await rootBundle.load('assets/angler-fish.png');

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

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }
}