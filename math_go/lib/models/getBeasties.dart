import 'package:cloud_firestore/cloud_firestore.dart';

class beastieInfo {
  final String name;
  final String difficulty;
  final String question;
  final double answer;

  beastieInfo(this.name,this.difficulty,this.question,this.answer);
}

Future<List<beastieInfo>> getUsersBeasties (String username) async{
  
  List<beastieInfo> myBeasties = new List<beastieInfo>();
  List<String> beastieIds = new List<String>();
  final Firestore _mathGoStore = Firestore.instance;

  CollectionReference collRef = _mathGoStore.collection("users").document(username).collection("myBeasties");
  await collRef.getDocuments().then((QuerySnapshot datasnapshot) {
              for(int i=0; i<datasnapshot.documents.length; i++){
                beastieIds.add(datasnapshot.documents[i].documentID.toString());
              }
  });

  for(int j=0; j<beastieIds.length; j++){
    DocumentReference docRef = _mathGoStore.collection("beasties").document(beastieIds[j]);
    await docRef.get().then((DocumentSnapshot datasnapshot) {
              if (datasnapshot.exists) {
                myBeasties.add(new beastieInfo(datasnapshot.data['name'], datasnapshot.data['category'], datasnapshot.data['question'], datasnapshot.data['answer'].toDouble()));
              }
    });

  }
  
  return myBeasties;
}
