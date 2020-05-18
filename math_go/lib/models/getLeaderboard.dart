import 'package:cloud_firestore/cloud_firestore.dart';

class leaderInfo {
  final String username;
  final int amountCaptured;

  leaderInfo(this.username,this.amountCaptured);
}

Future<List<leaderInfo>> getLeaderboard () async{
  
  List<leaderInfo> leaders = new List<leaderInfo>();
  final Firestore _mathGoStore = Firestore.instance;
  
    await _mathGoStore.collection("users").getDocuments().then((QuerySnapshot datasnapshot) {
                  for(int i=0; i<datasnapshot.documents.length; i++){
                    leaders.add(new leaderInfo(datasnapshot.documents[i].documentID,datasnapshot.documents[i].data['questionCorrect']));
                  }
              });
 
  leaders.sort((b, a) => a.amountCaptured.compareTo(b.amountCaptured));
 
  if(leaders.length>5){
    leaders.removeRange(5, leaders.length);
  }
  

  return leaders;
}
