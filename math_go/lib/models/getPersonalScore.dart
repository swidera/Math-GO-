import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> getPersonalScore (String username) async{
  final Firestore _mathGoStore = Firestore.instance;
  
  String lifetimeScore="Data Retrieval Failure";

  DocumentReference docRef = _mathGoStore.collection("users").document(username);
  await docRef.get().then((DocumentSnapshot datasnapshot) {
            if (datasnapshot.exists) {
              String attempt = datasnapshot.data['questionAttempt'].toString();
              String correct = datasnapshot.data['questionCorrect'].toString();
              lifetimeScore = correct+"/"+attempt;
            }
  });

  return lifetimeScore;
}