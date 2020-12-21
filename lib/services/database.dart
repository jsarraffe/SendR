import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/modal/user.dart';

class DatabaseMethods {

  getUserByUserName(String username) async{
   return await FirebaseFirestore.instance.collection("users")
        .where("username",isEqualTo: username)
        .get();
  }

  getUserByUserEmail(String userEmail) async{
    return await FirebaseFirestore.instance.collection("users")
        .where("email",isEqualTo: userEmail)
        .get();
  }

  Future<void> addUserInfo(userData) async {
    FirebaseFirestore.instance.collection("users").add(userData).catchError(
            (e) {
          print(e.toString());
        });
  }

  createChatRoom(String chatRoomId, chatRoomMap){
    FirebaseFirestore.instance.collection("ChatRoom")
        .doc(chatRoomId).set(chatRoomMap).catchError((e){
          print(e.toString());
    });
  }

  getUserInfo(String email) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("userEmail", isEqualTo: email)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }


  addConversationMessages(String chatRoomId, messageMap){
    FirebaseFirestore.instance.collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap).catchError((e){print(e.toString());});
  }

  getConversationMessages(String chatRoomId) async {
    return await FirebaseFirestore.instance.collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
    .orderBy("time", descending : false)
        .snapshots();
  }


  getChatRooms(String userName) async{
    return await FirebaseFirestore.instance
        .collection("ChatRoom")
        .where("users", arrayContains: userName)
        .snapshots();
  }
  
  addPostToFeed(messageMap){
    FirebaseFirestore.instance.collection("FeedPosts").add(messageMap);
  }

}