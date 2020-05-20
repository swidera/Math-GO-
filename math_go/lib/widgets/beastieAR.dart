import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';


class BeastieAr extends StatefulWidget {
  final String title;

  const BeastieAr({Key key, this.title}) : super(key: key);

  State createState() => _BeastieArState();
}

class _BeastieArState extends State<BeastieAr> {
  //AR Variables
  ArCoreController arCoreController;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          title: const Text('test'),
        ),
        body: ArCoreView(
          onArCoreViewCreated: _onArCoreViewCreated,
          enableTapRecognizer: true,
        ),
      );
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    arCoreController.onNodeTap = (name) => onTapHandler(name);
  }

  void onTapHandler(String name) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) =>
          AlertDialog(content: Text('onNodeTap on $name')),
    );
  }
}

//FIX ME:
//Below is potential fix to sigterm exit
//https://stackoverflow.com/questions/61167711/sample-flutter-ar-project-app-crashes-unable-to-start-activity-componentinfo