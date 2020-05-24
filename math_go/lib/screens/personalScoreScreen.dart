import 'package:flutter/material.dart';
import '../widgets/mainMap.dart';

class personalScoreScreen extends StatelessWidget {
  
  final String lifetimeScore;
  final String loggedInUser;
  personalScoreScreen(this.lifetimeScore, this.loggedInUser);
  @override
  Widget build(BuildContext context) {
    List<Widget> scoreboardList = new List(2);

    TextStyle scoreStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black,
      height: 1.75,
    );
    scoreboardList[0] = Material(
      child: Text(lifetimeScore, style: scoreStyle, textAlign: TextAlign.center)
    );
    scoreboardList[1] = Material(
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