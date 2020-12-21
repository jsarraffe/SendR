import 'package:first/Views/conversation_screen.dart';
import 'package:first/Widgets/widget.dart';
import 'package:first/helper/constants.dart';
import 'package:first/services/database.dart';
import 'package:flutter/material.dart';
import 'package:first/services/auth.dart';
import 'package:first/Views/search.dart';
import 'package:first/helper/helperfunctions.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream chatRoomsStream;

  Widget chatRoomList(){
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index){
                return ChatRoomsTitle(
                  snapshot.data.documents[index].data()["chatroomId"]
                      .toString().replaceAll("_", "")
                      .replaceAll(Constants.myName, ""),
                    snapshot.data.documents[index].data()["chatroomId"]
                );
            }) : Container();
      },
    );
  }

  void initState(){
    getUserInfo();

    super.initState();
  }
  
  getUserInfo() async{
    Constants.myName = await HelperFunctions.getUserNameInSharedPrefrence();
    databaseMethods.getChatRooms(Constants.myName).then((value){
      setState(() {
        chatRoomsStream = value;
      });
    });
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "SendR",
              style: TextStyle(
                  fontSize: 22
              ),
            ),
            Text("Messages", style: TextStyle(fontSize: 22, color: Colors.blue),)
          ],
        ),
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => SearchScreen()
          ));
        },
      ),
    );
  }
}
class ChatRoomsTitle extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomsTitle(this.userName, this.chatRoomId);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ConversationScreen(chatRoomId)
        ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 23, vertical : 15),
        child : Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius : BorderRadius.circular(40)

            ),
              child: Text("${userName.substring(0,1).toUpperCase()}"),
            ),
            SizedBox(width: 8,),
            Text(userName, style: mediumTextStyle(),)
          ],
        ),
      ),
    );
  }
}



