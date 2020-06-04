//Unused authentication file
//Future use for when user can upload questions to database

// import 'package:cloud_firestore/cloud_firestore.dart';

// Future<bool> authenticateMathProb(String beastieId, var answer) async{
  
//   bool authenticated = false;
//   final Firestore _mathGoStore = Firestore.instance;
  
//   DocumentReference docRef = _mathGoStore.collection("beasties").document(beastieId);
//     await docRef.get().then((DocumentSnapshot datasnapshot) {
//               if (datasnapshot.exists) {
//                 if(datasnapshot.data['answer']==answer){
//                   authenticated = true;
//                 }
//               }
//   });

//   return authenticated;
// }