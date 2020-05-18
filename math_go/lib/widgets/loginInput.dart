import 'package:flutter/material.dart';
import '../models/authenticate.dart';
import '../widgets/mainMap.dart';

class loginInput extends StatefulWidget {
  @override
  _loginInput createState() => _loginInput();
}

class _loginInput extends State<loginInput> {
  String _usernameInput = "";
  String _pwInput = "";
  final userNameController = TextEditingController();
  final pwController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        TextField(
          controller: userNameController
        ),
        Text(
          'Username'
        ),
        TextField(
          obscureText: true,
          controller: pwController
        ),
        Text(
          'Password'
        ),
        FlatButton(
          onPressed: ()async{
            _usernameInput = userNameController.text;
            _pwInput = pwController.text;
            if(await authenticateUser(_usernameInput, _pwInput)){
              Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MathGo())
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
            
          },
          color: Colors.deepOrangeAccent,
          child: Text(
            'Submit'
          ),
        )
        ],
    );
  }
}