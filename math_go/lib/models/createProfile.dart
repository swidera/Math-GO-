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
                    'password': pw
                  });
                createStatus="The user has been created";
              }
  });

  return createStatus;
}