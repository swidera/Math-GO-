import 'package:flutter/material.dart';
import '../screens/homeScreen.dart';
import '../widgets/mainMap.dart';
import '../models/getLeaderboard.dart';

class leaderboardScreen extends StatelessWidget {

  final List<leaderInfo> leaderboard;
  final String loggedInUser;
  leaderboardScreen(this.leaderboard, this.loggedInUser);

  @override
  Widget build(BuildContext context) {

    List<Widget> leaderboardList = new List<Widget>();

    TextStyle leaderStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black,
      height: 1.75,
    );

    for (int i=0; i<leaderboard.length; i++){
        leaderboardList.add(Material(
          child: Text(leaderboard[i].username+" : "+leaderboard[i].amountCaptured.toString()+" Beasties", style: leaderStyle, textAlign: TextAlign.center)
        ));
        //if last one, add back button next
        if(leaderboard.length==i+1){
          leaderboardList.add(Material(
            child: FlatButton(
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MathGo(loggedInUser))
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
        }
    }

    return Container(
      color: Colors.deepOrangeAccent,
      child:  ListView(
        children: leaderboardList
      ),
      constraints: BoxConstraints.expand(),
  );
  }
}