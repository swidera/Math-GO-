import 'package:flutter/material.dart';
import '../models/authenticate.dart';
import '../widgets/mainMap.dart';

class loginInput extends StatefulWidget {
  @override
  _loginInput createState() => _loginInput();
}

class _loginInput extends State<loginInput> {
  final formKey = GlobalKey<FormState>();
  String _usernameInput = "";
  String _pwInput = "";
  // final userNameController = TextEditingController();
  // final pwController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Form( 
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Username',
              hintText: 'Enter Username',
              border: UnderlineInputBorder(),
            ),
            onSaved: (value) {
              _usernameInput = value;
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
            onPressed: ()async{
              if(formKey.currentState.validate()) {
                formKey.currentState.save();
                if(await authenticateUser(_usernameInput, _pwInput)){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MathGo(_usernameInput))
                  );
                }
                else{
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return  AlertDialog(
                        title:  Text('Access Denied')
                      );}
                  );
                }
              }
            },
            color: Colors.deepOrangeAccent,
            child: Text(
              'Submit'
            ),
          )
          ],
      ));
  }
}