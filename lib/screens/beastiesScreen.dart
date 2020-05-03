import 'package:flutter/material.dart';
import '../screens/homeScreen.dart';
import '../widgets/mainMap.dart';


class beastiesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    List<Widget> beastieList = new List(6);

    TextStyle beastieStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black,
      height: 1.75,
    );

    TextStyle titleStyle = TextStyle(
      fontWeight: FontWeight.w800,
      color: Colors.black,
      height: 3,
    );
    
    beastieList[0] = Material(
      child: Text('My Beasties', style: titleStyle, textAlign: TextAlign.center)
      );
    beastieList[1] = Material(
      child: Image.asset(
      'assets/beastie1.png',
      height: 100,
      width: 100,
      )
    );
    beastieList[2] = Material(
      child: Text('TealBeastie', style: beastieStyle, textAlign: TextAlign.center)
      );
    beastieList[3] = Material(
      child:
      Image.asset(
      'assets/beastie2.png',
      height: 100,
      width: 100,
      )
    );
    beastieList[4] =Material(
      child: Text('YellowBeastie', style: beastieStyle, textAlign: TextAlign.center)
      );
    beastieList[5] = Material(
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
    ,);
    return Container(
      color: Colors.deepOrangeAccent,
      child:  ListView(
        children: <Widget>[
          beastieList[0],
          beastieList[1],
          beastieList[2],
          beastieList[3],
          beastieList[4],
          beastieList[5],
        ]
      ),
      constraints: BoxConstraints.expand(),
  );
  }
}