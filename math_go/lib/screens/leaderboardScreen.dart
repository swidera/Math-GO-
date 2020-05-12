import 'package:flutter/material.dart';
import '../screens/homeScreen.dart';
import '../widgets/mainMap.dart';
import '../models/getLeaderboard.dart';

class leaderboardScreen extends StatelessWidget {
leaderboardScreen(this.leaderboard);

final List<leaderInfo> leaderboard;
  @override
  Widget build(BuildContext context) {

    List<Widget> leaderboardList = new List(6);

    TextStyle leaderStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black,
      height: 1.75,
    );

    for (int i=0; i<leaderboard.length; i++){
        leaderboardList[0] = Material(
          child: Text(leaderboard[i].username+" : "+leaderboard[i].amountCaptured.toString()+" Beasties", style: leaderStyle, textAlign: TextAlign.center)
        );
    }

    leaderboardList.add(Material(
      child: FlatButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MathGo())
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
    ));

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