import 'package:flutter/material.dart';
import '../screens/homeScreen.dart';
import '../widgets/mainMap.dart';

class personalScoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    List<Widget> scoreboardList = new List(2);

    TextStyle scoreStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black,
      height: 1.75,
    );
    scoreboardList[0] = Material(
      child: Text('Lifetime Score: 7/10 - 70%', style: scoreStyle, textAlign: TextAlign.center)
    );
    scoreboardList[1] = Material(
      child: FlatButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MathGoApp())
                    );
                  },
                  child: Text(
                    'Back to Map',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                    )
                  ),
                )
    );

    return Container(
      color: Colors.deepOrangeAccent,
      child:  ListView(
        children: <Widget>[
          scoreboardList[0],
          scoreboardList[1],
        ]
      ),
      constraints: BoxConstraints.expand(),
  );
  }
}