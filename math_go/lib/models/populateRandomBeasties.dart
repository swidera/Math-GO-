import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/getBeasties.dart';

Future<List<beastieInfo>> populateRandomBeasties () async{
  
  List<beastieInfo> randomBeasties = new List<beastieInfo>();
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
               datasnapshot.documents[chosenBeastie].data['category'], 
               datasnapshot.documents[chosenBeastie].data['question'], 
               double.parse(datasnapshot.documents[chosenBeastie].data['answer'].toString()),
               datasnapshot.documents[chosenBeastie].data['pic name']));
            }
  });

  return randomBeasties;
}
