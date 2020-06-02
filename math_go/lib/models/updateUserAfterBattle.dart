import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/getBeasties.dart';

Future<bool> updateUserAfterBattle (String username, bool captured, beastieInfo currentBeastie) async{
  
  bool updateSuccessful = false;
  final Firestore _mathGoStore = Firestore.instance;

  DocumentReference docRef = _mathGoStore.collection("users").document(username);
    await docRef.get().then((DocumentSnapshot datasnapshot) {
              if (datasnapshot.exists) {
                if(captured==false){
                    _mathGoStore.collection("users")
                      .document(username)
                      .updateData({
                        'questionAttempt': (datasnapshot.data['questionAttempt']+1)
                      });
                }
                else if(captured==true){
                    _mathGoStore.collection("users")
                      .document(username).updateData({
                        'questionAttempt': (datasnapshot.data['questionAttempt']+1),
                        'questionCorrect': (datasnapshot.data['questionCorrect']+1)
                      });

                   _mathGoStore.collection("users")
                      .document(username).collection("myBeasties").add({
                        'name': currentBeastie.name,
                        'imageUrl':currentBeastie.imageUrl
                      });
                }
                updateSuccessful=true;
              }
              else{
                updateSuccessful=false;
              }
    });
    

  return updateSuccessful;
}

