import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/getBeasties.dart';

void populateRandomBeasties (List<beastieInfo> randomBeasties) async{
  
  final Firestore _mathGoStore = Firestore.instance;
  Random randGenerator = new Random();
  int beastieCount = randGenerator.nextInt(2);
  beastieCount++;
  int chosenBeastie;
  
  CollectionReference collRef = _mathGoStore.collection("beasties");
  await collRef.getDocuments().then((QuerySnapshot datasnapshot) {
            for(int i=0; i<beastieCount; i++){
              chosenBeastie = randGenerator.nextInt(datasnapshot.documents.length-1);
              randomBeasties.add(new beastieInfo(
               datasnapshot.documents[chosenBeastie].data['name'],
               datasnapshot.documents[chosenBeastie].data['difficulty'], 
               datasnapshot.documents[chosenBeastie].data['question'], 
               datasnapshot.documents[chosenBeastie].data['answer'],
               datasnapshot.documents[chosenBeastie].data['imageUrl']));
            }
  });
}
