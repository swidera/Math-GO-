import 'package:flutter/material.dart';
import '../screens/loginScreen.dart';

class viewBeastiesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Scaffold(
          body: GridView.count(
          crossAxisCount: 3,
          children: List.generate(100, (index) {
            return Center(
              child: Text(
                'Item $index',
                style: Theme.of(context).textTheme.headline,
              ),
            );
          }),
        )
        )
        )
    );
  }
}




