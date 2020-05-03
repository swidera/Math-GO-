import 'package:flutter/material.dart';
import '../screens/homeScreen.dart';
import '../widgets/mainMap.dart';

class leaderboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    List<Widget> leaderboardList = new List(6);

    TextStyle leaderStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black,
      height: 1.75,
    );


    
    leaderboardList[0] = Material(
      child: Text('defaultuser: 750 Beasties', style: leaderStyle, textAlign: TextAlign.center)
    );
      
    leaderboardList[1] = Material(
      child: Text('jdoe1: 551 Beasties', style: leaderStyle, textAlign: TextAlign.center)
    );
    leaderboardList[2] = Material(
      child: Text('beastie27: 467 Beasties', style: leaderStyle, textAlign: TextAlign.center)
    );
    leaderboardList[3] = Material(
      child: Text('jim5: 452 Beasties', style: leaderStyle, textAlign: TextAlign.center)
    );
    leaderboardList[4] = Material(
      child: Text('timmy: 398 Beasties', style: leaderStyle, textAlign: TextAlign.center)
    );
    leaderboardList[5] = Material(
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
          leaderboardList[0],
          leaderboardList[1],
          leaderboardList[2],
          leaderboardList[3],
          leaderboardList[4],
          leaderboardList[5],
        ]
      ),
      constraints: BoxConstraints.expand(),
  );
  }
}