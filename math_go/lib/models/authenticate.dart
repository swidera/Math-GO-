import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';



Future<bool> authenticateUser (String user, String password) async{
  
  bool authenticated = false;
  final Firestore _mathGoStore = Firestore.instance;
  
  DocumentReference docRef = _mathGoStore.collection("users").document(user);
    await docRef.get().then((DocumentSnapshot datasnapshot) {
              if (datasnapshot.exists) {
                if(datasnapshot.data['password'].toString()==password){
                  authenticated = true;
                }
              }
  });

  return authenticated;
}

