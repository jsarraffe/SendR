import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first/Views/conversation_screen.dart';
import 'package:first/helper/helperfunctions.dart';
import 'package:flutter/material.dart';
import 'package:first/Widgets/widget.dart';
import 'package:first/services/database.dart';
import 'package:first/helper/constants.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

String _myName;

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingController = new
  TextEditingController();

  QuerySnapshot searchSnapshot;

  Widget searchList(){
    return  searchSnapshot != null ? ListView.builder(
        itemCount: searchSnapshot.docs.length,
        shrinkWrap: true,
        itemBuilder: (context, index){
          return SearchTitle(
            userName: searchSnapshot.docs[index].data()["username"],
            userEmail: searchSnapshot.docs[index].data()["email"],

          );
        }) : Container();
  }

  initiateSearch(){

    databaseMethods.getUserByUserName(searchTextEditingController.text)
        .then((val){
     setState(() {
       searchSnapshot = val;
     });
    });
  }

  createChatroomAndStartConvo({String userName}){
    print("${Constants.myName}");
    if(userName != Constants.myName){
      String chatRoomId = getChatRoomId(userName, Constants.myName);

      List<String> users = [userName, Constants.myName ];
      Map<String, dynamic> chatRoomMap = {
        "users" : users,
        "chatroomId": chatRoomId
      };
      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => ConversationScreen(
            chatRoomId

          )
      ));
    }else{
      print("you ccannot send message to yourself");
    }
  }
  Widget SearchTitle({String userName,
String userEmail}){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName, style: mediumTextStyle(),),
              Text(userEmail, style: simpleTextStyle(),)
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
              createChatroomAndStartConvo(
                userName: userName
              );
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(30)
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              child: Text("message", style: mediumTextStyle(),),
            ),
          )
        ],
      ),
    );

  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Container(
          child: Column(
            children: [
              Container(
                color: Color(0x54FFFFFF),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                          controller: searchTextEditingController,
                          style: TextStyle(
                    color: Colors.white
                ),
                      decoration: InputDecoration(
                          hintText: "search username",
                          hintStyle: TextStyle(color: Colors.white)),
                    )),
                    GestureDetector(
                      onTap: (){
                        initiateSearch();
                      },
                      child: Container(
                           child: Image.asset("assets/images/toolbar_find.png")),
                    )
                  ],
                ),
              ),
              searchList()
            ],
          ),
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}