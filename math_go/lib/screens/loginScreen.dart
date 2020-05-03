import 'package:flutter/material.dart';
import '../widgets/loginInput.dart';
import '../widgets/titleBar.dart';
import '../screens/newProfileScreen.dart';

class loginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.deepOrangeAccent,
      title: 'Login',
      home: loginPage(),
    );
  }
}

class loginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      color: Colors.deepOrangeAccent,
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                titleBar(),
                loginInput(),
                FlatButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => newProfile())
                    );
                  },
                  child: Text(
                    'Create New Profile',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrangeAccent
                    )
                  ),
                )
              ]
              )
            )
          )
        )
    );
  }
}






