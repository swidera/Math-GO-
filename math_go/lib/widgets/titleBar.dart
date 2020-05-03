import 'package:flutter/material.dart';

class titleBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'MATH GO!',
      textScaleFactor: 4,
      style: TextStyle(
          fontFamily: 'fantasy',
          letterSpacing: 2.0,
          fontWeight: FontWeight.bold,
          color: Colors.deepOrangeAccent
        ),
    );
  }
}