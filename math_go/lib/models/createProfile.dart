import 'package:flutter/material.dart';
import '../screens/newProfileScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> createUser (String username, String pw) async{
  final Firestore _mathGoStore = Firestore.instance;
  
  String createStatus="Failure";
  DocumentReference docRef = _mathGoStore.collection("users").document(username);

    await docRef.get().then((DocumentSnapshot datasnapshot) {
              if (datasnapshot.exists) {
                createStatus = "Username already exists";
              }
              else{
                _mathGoStore.collection("users")
                  .document(username)
                  .setData({
                    'username': username,
                    'password': pw,
                    'questionAttempt': 0,
                    'questionCorrect': 0
                  });
                _mathGoStore.collection("users").document(username).collection("myBeasties")
                .document('De2lxEUNbVbgYmjjHsbp')
                .setData({
                 'name': 'Eagle',
                 'imageUrl': 'eagle-emblem.png'
                });
                createStatus="The user has been created. Please enjoy a free Eagle Beastie as an appreciation for playing Math Go!";
              }
  });

  return createStatus;
}