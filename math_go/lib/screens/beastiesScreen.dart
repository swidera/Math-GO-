import 'package:flutter/material.dart';
import 'package:math_go/models/getBeasties.dart';
import '../widgets/mainMap.dart';

class beastiesScreen extends StatelessWidget {

  final List<beastieInfo> myBeasties;
  final String loggedInUser;
  beastiesScreen(this.myBeasties, this.loggedInUser);

  @override
  Widget build(BuildContext context) {

    List<Widget> beastieList = new List<Widget>();

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

    for (int i=0; i<myBeasties.length; i++){
        beastieList.add(Material(
          child: Text(myBeasties[i].name, style: beastieStyle, textAlign: TextAlign.center)
        ));
        //if last one, add back button next
        if(myBeasties.length==i+1){
          beastieList.add(Material(
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
        children: beastieList
      ),
      constraints: BoxConstraints.expand(),
  );
  }
}