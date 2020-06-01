import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
//import 'package:path/path.dart' as path;
//import 'dart:convert';
import 'package:location/location.dart';
import 'package:math_go/models/updateUserAfterBattle.dart';
//import 'package:intl/intl.dart';
import '../models/beastieMathAuth.dart';
import '../widgets/mainMap.dart';
import '../models/getBeasties.dart';

class BeastieMathProb extends StatefulWidget{
  final String loggedInUser;
  final beastieInfo beastie;
  //TO DO: set beastie math constructor to take in beastie object and user log in
  const BeastieMathProb({Key key, this.loggedInUser, this.beastie}) : super(key: key);


  @override
  _BeastieMathProbState createState() => _BeastieMathProbState();
}

class _BeastieMathProbState extends State<BeastieMathProb> {
  final formKey = GlobalKey<FormState>();
  File image;
  var entryCount = 0;
  var answer;
  var _beastieAnswer;
  var _userAnswer;
  var problem = '';

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
              MaterialPageRoute(builder: (context) => MathGo(widget.loggedInUser)),
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
              Text(widget.beastie.name),
              Image.asset(
                'assets/'+widget.beastie.imageUrl,
                height: 100,
                width: 100,
              ),
              Text(widget.beastie.question),
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
                  if(formKey.currentState.validate()) {
                    formKey.currentState.save();
                  }
                  _beastieAnswer = widget.beastie.answer;
                  _userAnswer = answer;
                  print('Beastie Answer: ${_beastieAnswer}\n');
                  print("user answer: ${_userAnswer}\n");
                  if(_beastieAnswer == _userAnswer){
                    await updateUserAfterBattle(widget.loggedInUser, true, widget.beastie);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return  AlertDialog(
                          title:  Text('Answer Correct.  Beastie Captured.')
                        );
                      }
                      ).then((val) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MathGo(widget.loggedInUser))
                        );                       
                    });
                  }
                  else{
                    await updateUserAfterBattle(widget.loggedInUser, false, widget.beastie);
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return  AlertDialog(
                          title:  Text('Answer Incorrect.  Beastie Got Away.')
                        );}
                    ).then((val) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MathGo(widget.loggedInUser))
                      );                       
                    });
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
