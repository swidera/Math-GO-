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
  final formKey = GlobalKey<FormState>();
  // final userNameController = TextEditingController();
  // final pwController = TextEditingController();
  // final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.all(50.0),
        child: Scaffold(
          body: Form(
            key: formKey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter Email',
                        border: UnderlineInputBorder(),
                      ),
                      onSaved: (value) {
                        _emailInput = value;
                      },
                      validator: (value) {
                        if(value.isEmpty) {
                          return 'Please enter an email';
                        }
                        else {
                          return null;
                        }
                      }
                    ),
                  TextFormField(
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        hintText: 'Enter Username',
                        border: UnderlineInputBorder(),
                      ),
                      onSaved: (value) {
                        _usernameInput= value;
                      },
                      validator: (value) {
                        if(value.isEmpty) {
                          return 'Please enter a username';
                        }
                        else {
                          return null;
                        }
                      }
                    ),
                  TextFormField(
                      autofocus: true,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter password',
                        border: UnderlineInputBorder(),
                      ),
                      onSaved: (value) {
                        _pwInput = value;
                      },
                      validator: (value) {
                        if(value.isEmpty) {
                          return 'Please enter a password';
                        }
                        else {
                          return null;
                        }
                      }
                    ),
                  FlatButton(
                    onPressed: () async{
                      //validate input
                      if(formKey.currentState.validate()) {
                        formKey.currentState.save();
                        //check if user exist
                        String createStatus = await createUser(_usernameInput, _pwInput);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return  AlertDialog(
                              title:  Text(createStatus)
                            );}
                        );
                      }
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
       )
    );
  }
}