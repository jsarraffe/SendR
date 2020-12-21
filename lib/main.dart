import 'package:firebase_core/firebase_core.dart';
import 'package:first/Views/signin.dart';
import 'package:first/Views/singup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:first/Views/home.dart';
import 'package:first/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:first/helper/helperfunctions.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn = false;

  @override
  void initState(){
    getLoggedInState();
    super.initState();
  }
  getLoggedInState() async{
    await HelperFunctions.getUserLoggedInSharedPrefrence().then((value){
      userIsLoggedIn = value;
    });
  }


  @override
  Widget build(BuildContext context) {

    return Provider<AuthMethods>(
      create:(context)=> AuthMethods(),
      child:MaterialApp(
          theme: ThemeData.dark(),
          home:  userIsLoggedIn ? Home() :
          SignIn(),
      )
      );
  }
}


