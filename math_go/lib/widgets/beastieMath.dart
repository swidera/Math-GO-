import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
//import 'package:path/path.dart' as path;
//import 'dart:convert';
import 'package:location/location.dart';
//import 'package:intl/intl.dart';
import '../models/beastieMathAuth.dart';
import '../widgets/mainMap.dart';
import '../models/getBeasties.dart';

class BeastieMathProb extends StatefulWidget{
  final String title;
  final beastieInfo beastie;
  //TO DO: set beastie math constructor to take in beastie object and user log in
  const BeastieMathProb({Key key, this.title, this.beastie}) : super(key: key);


  @override
  _BeastieMathProbState createState() => _BeastieMathProbState();
}

class _BeastieMathProbState extends State<BeastieMathProb> {
  final formKey = GlobalKey<FormState>();
  File image;
  var entryCount = 0;
  var answer = 0.0;
  var _beastieAnswer = 0.0;
  var _userAnswer = 0.0;
  var problem = '';
  String loggedInUser = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Math Problem'),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MathGo(loggedInUser)),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextFormField(
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Enter Answer', border: OutlineInputBorder()
                ),
                onSaved: (value) {
                  //store value in some object
                  answer = double.parse(value);
                },
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
                validator: (value) {
                  if(value.isEmpty) {
                    return 'Please enter a Number';
                  }
                  else {
                    return null;
                  }
                }
              ),
              SizedBox(height: 10),
              RaisedButton(
                onPressed: () async {
                  _beastieAnswer = widget.beastie.answer;
                  _userAnswer = answer;
                  if(_beastieAnswer == _userAnswer){
                    //add upload beastie captured function
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return  AlertDialog(
                          title:  Text('Answer Correct.  Beastie Captured.')
                        );}
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MathGo(loggedInUser))
                    );
                  }
                  else{
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return  AlertDialog(
                          title:  Text('Answer Incorrect.  Beastie Got Away.')
                        );}
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MathGo(loggedInUser))
                    );
                  }
                },
                child: Text('Submit Answer')
              )
            ]),
          )
      )
    );
  }
}
