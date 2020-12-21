import 'package:first/Views/feedView.dart';
import 'package:first/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:first/Views/chatRoomsScreen.dart';
import 'package:first/Views/profileView.dart';
import "package:first/Views/editProfile.dart";

import 'signin.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    ChatRoom(),
    FeedView(),
    ProfileView(),


  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              AuthMethods().signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => SignIn()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),


      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.history),
            title: new Text("Messages")
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.list),
            title: new Text("feed")
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text("Profile")
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index){
    setState(() {
      _currentIndex = index;
    });
  }
}


