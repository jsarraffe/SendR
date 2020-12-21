import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/modal/user.dart';
import 'package:flutter/material.dart';
class AuthMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;

  Stream<String> get authStateChanges => _auth.authStateChanges().map(
            (User user) => user?.uid,
      );

  String getCurrentUID() {
    return _auth.currentUser.uid;
  }
  Future getCurrentUser() async {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    return firestoreInstance.collection("users").doc(getCurrentUID()).get();
    ;
  }

  Future updateUserInfo(String DisplayName, String username, String Email,
      String Bio, String UID) async{
    var firebaseUser =  FirebaseAuth.instance.currentUser;
    print(firebaseUser.uid);
    firestoreInstance.collection("users").doc(firebaseUser.uid).update({
      "Display name": DisplayName,
      "bio": Bio,
      "email": Email,
      "username": username,
      "uid": UID,
    });
  }

  Future newUserInfo(String DisplayName, String username, String Email, String Bio, String UID) async{
    return  firestoreInstance.collection("users").doc(UID).set({
      "Display name": DisplayName,
      "bio": Bio,
      "email": Email,
      "username": username,
      "uid": UID,
    });

  }

  CustomUser _userFromFireBaseUser(User user){
    return user != null ? CustomUser(userId: user.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = result.user;
      return _userFromFireBaseUser(firebaseUser);
    }catch(e){
      print(e.toString());
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword
        (email: email, password: password);
      User firebaseUser = result.user;
      return _userFromFireBaseUser(firebaseUser);

    }catch(e){
      print(e.toString());
    }
  }

  Future resetPass(String email) async{
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    }catch(e){
      print(e.toString());
    }
  }

  Future signOut() async{
    try{
      return await _auth.signOut();
    }catch(e){
    }
  }
}