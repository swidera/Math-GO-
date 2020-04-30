import 'package:flutter/material.dart';
import '../screens/loginScreen.dart';

class homeScreen extends StatefulWidget {
  @override
  _homeScreen createState() => _homeScreen();
}

class _homeScreen extends State<homeScreen> {
  bool _active = false;

  void _handleTap() {
    setState(() {
      _active = !_active;
    });
  }
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                    'APP MAIN PAGE',
                  ),
                FlatButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => loginScreen())
                    );
                  },
                  child: Text(
                    'BACK'
                  ),
                )
              ]
              )
            ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Home'),
                
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.business),
                title: Text('Business'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.school),
                title: Text('School'),
              ),
            ],
            currentIndex: 0,
            selectedItemColor: Colors.amber[800]
          ),
          )
        )
    );
  }
}






