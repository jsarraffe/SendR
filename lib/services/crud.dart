import 'package:cloud_firestore/cloud_firestore.dart';

class CrudMethods{
  Future<void> addData(feedData) async{
    FirebaseFirestore.instance.collection("FeedPosts").add(feedData).catchError((e){
      print(e);
    });
  }
  
  getData() async {
    return await FirebaseFirestore.instance.collection("FeedPosts").snapshots();
  }
}