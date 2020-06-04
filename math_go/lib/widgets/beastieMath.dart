import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:math_go/models/updateUserAfterBattle.dart';
import '../widgets/mainMap.dart';
import '../models/getBeasties.dart';

class BeastieMathProb extends StatefulWidget{
  final String loggedInUser;
  final beastieInfo beastie;
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
        title: Text('Beastie Battle!'),
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
              //Display beastie name
              Text(widget.beastie.name),
              //show beastie image
              Image.asset(
                'assets/'+widget.beastie.imageUrl,
                height: 100,
                width: 100,
              ),
              //display beastie question
              Text(widget.beastie.question),
              //user form to fill in answer
              TextFormField(
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Enter Answer', border: OutlineInputBorder()
                ),
                onSaved: (value) {
                  //store value in some object
                  answer = double.parse(value);
                },
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                //validate user input answer
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
              //raised button to validate and save answer
              RaisedButton(
                onPressed: () async {
                  if(formKey.currentState.validate()) {
                    formKey.currentState.save();
                  }
                  //if answer is correct capture beastie and reroute to map
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
                  //if answer is wrong then beastie runs away and user is rerouted to map
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
