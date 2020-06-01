import 'package:flutter/material.dart';
import '../screens/loginScreen.dart';
import '../screens/leaderboardScreen.dart';
import '../screens/personalScoreScreen.dart';
import '../screens/beastiesScreen.dart';
import '../widgets/mainMap.dart';

class homeScreen extends StatefulWidget {
  @override
  _homeScreen createState() => _homeScreen();
}

class _homeScreen extends  State<homeScreen> {

  int pageIndex = 0;

  List<Widget> pageOptions = <Widget>[
    Text(
      'Main App'
    ),
    Text(
      'Beasties Page'
    ),
    Text(
      'Personal Score Page'
    ),
    Text(
      'Leaderboard'
    ),
    Text(
      'Logging out...'
    )
  ];

  void changePage(int pagePicked) {

    if(pagePicked==4){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => loginScreen())
      );
    }

    if(pagePicked==3){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => leaderboardScreen())
      );
    }

    if(pagePicked==2){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => personalScoreScreen())
      );
    }

    if(pagePicked==1){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MathGoApp())
      );
    }

    setState(() {
      pageIndex = pagePicked;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('Hi')
              ]
              )
            ),
          bottomNavigationBar: BottomNavigationBar(
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.map),
                  title: Text('Home'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.child_care),
                  title: Text('Beasties'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.score),
                  title: Text('Score'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.map),
                  title: Text('Leaderboard'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.system_update_alt),
                  title: Text('Logout'),
                ),
              ],
              currentIndex: pageIndex,
              selectedItemColor: Colors.deepOrangeAccent,
              onTap: changePage,
            ),
          )
        )
    );
  }
}







