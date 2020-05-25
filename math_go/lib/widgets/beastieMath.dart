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

class BeastieMathProb extends StatefulWidget{
  final String title;
  final String beastieID;
  const BeastieMathProb({Key key, this.title, this.beastieID}) : super(key: key);


  @override
  _BeastieMathProbState createState() => _BeastieMathProbState();
}

class _BeastieMathProbState extends State<BeastieMathProb> {
  final formKey = GlobalKey<FormState>();
  File image;
  var entryCount = 0;
  var answer = 0;
  var _beastieID = '';
  var _userAnswer = 0;
  var problem = '';

  // final Firestore _mathGoStore = Firestore.instance;
  
  // DocumentReference docRef = _mathGoStore.collection("beasties").document(widget.beastieID);
  // await docRef.get().then((DocumentSnapshot datasnapshot) {
  //   if (datasnapshot.exists) {
  //       problem = datasnapshot.data['question'].toString()
  //   }
  // });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Math Problem')),
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
                  answer = int.parse(value);
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
                  _beastieID = widget.beastieID;
                  _userAnswer = answer;
                  if(await authenticateMathProb(_beastieID, _userAnswer)){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MathGo(title: 'Map Screen'))
                    );
                  }
                  else{
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return  AlertDialog(
                          title:  Text('Answer Incorrect.  Please Try Again.')
                        );}
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
