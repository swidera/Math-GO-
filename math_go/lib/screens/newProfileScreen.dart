import 'package:flutter/material.dart';
import '../screens/loginScreen.dart';
import '../models/createProfile.dart';

class newProfile extends StatefulWidget {
  @override
  _newProfile createState() => _newProfile();
}

class _newProfile extends State<newProfile> {
  String _usernameInput;
  String _pwInput;
  String _emailInput;
  final userNameController = TextEditingController();
  final pwController = TextEditingController();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.all(50.0),
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: emailController
                ),
                Text(
                  'Email'
                ),
                TextField(
                  controller: userNameController
                ),
                Text(
                  'Username'
                ),
                TextField(
                  controller: pwController
                ),
                Text(
                  'Password'
                ),
                FlatButton(
                  onPressed: () async{
                    //check if user exist
                    String createStatus = await createUser(userNameController.text, pwController.text);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return  AlertDialog(
                          title:  Text(createStatus)
                        );}
                    );
                  },
                  color: Colors.deepOrangeAccent,
                  child: Text(
                    'CREATE'
                  ),
                ),
                FlatButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => loginScreen())
                    );
                  },
                  color: Colors.deepOrangeAccent,
                  child: Text(
                    'GO BACK'
                  ),
                )
                ],)
              )
          )
       )
    );
  }
}