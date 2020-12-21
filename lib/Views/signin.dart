import 'package:first/Views/home.dart';
import 'package:first/Views/singup.dart';
import 'package:first/Widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:first/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first/services/database.dart';
import 'package:first/Views/chatRoomsScreen.dart';
import 'package:provider/provider.dart';
import 'package:first/helper/helperfunctions.dart';


class SignIn extends StatefulWidget{
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  HelperFunctions helperFunctions = new HelperFunctions();

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  AuthMethods authMethods = new AuthMethods();
  bool isLoading = false;

  QuerySnapshot snapshotUserInfo;

  signIn() async {
    if (formKey.currentState.validate()) {

      HelperFunctions.saveUserEmailSharedPrefrence(emailEditingController.text);
      databaseMethods.getUserByUserEmail(emailEditingController.text)
          .then((val){
        snapshotUserInfo = val;
        HelperFunctions.saveUserNameSharedPreference(snapshotUserInfo
            .docs[0].data()["username"]);
        print("${snapshotUserInfo
            .docs[0].data()["username"]} this is not good ");
      });

      setState(() {
        isLoading = true;
      });
      authMethods.signInWithEmailAndPassword(emailEditingController.text,
          passwordEditingController.text)
      .then((val) {
        if (val != null) {
          HelperFunctions.saveUserLoggedInSharedPrefrence(true);
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => Home()));
        }
      });
      await authMethods.signInWithEmailAndPassword(emailEditingController.text, passwordEditingController.text).then((result) async {
        if (result != null)  {
          QuerySnapshot userInfoSnapshot = await DatabaseMethods().getUserInfo(emailEditingController.text);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home()));
        } else {
          setState(() {
            isLoading = false;
            //show snackbar
          });
        }
      });
    }
  }

  @override
  void initState()
  {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    authMethods = Provider.of<AuthMethods>(context);
    return Scaffold(
      appBar: appBarMain(context),

       body: SingleChildScrollView(
         child: Container(
           height: MediaQuery.of(context).size.height-50,
           alignment: Alignment.bottomCenter,
           child: Container(

             padding: EdgeInsets.symmetric(horizontal: 24),
             child: Column(
               mainAxisSize:MainAxisSize.min,
               children: [
                 Form(
                   key: formKey,
                   child: Column(
                     children: [
                       TextFormField(
                         validator: (val){
                           return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9"
                           r".!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                               .hasMatch(val) ? null : "Enter valid email";
                         },
                         controller:  emailEditingController,
                         style: simpleTextStyle(),
                         decoration: textFieldInputDecoration('Email Address'),
                         ),
                       TextFormField(
                         validator: (val){
                           return val.length > 6 ? null : "Please provide 6+ "
                               "character password";
                         },
                         controller: passwordEditingController,
                         style: simpleTextStyle(),
                         obscureText: true,
                         decoration: textFieldInputDecoration('password'),
                       ),
                       SizedBox(height: 8,),
                       Container(
                         alignment:  Alignment.centerRight,
                         child: Container(
                           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                           child: Text("Forgot Password?", style: simpleTextStyle(),),
                         ),
                       ),
                       SizedBox(height: 8,),
                       GestureDetector(
                         onTap: (){
                           signIn();
                         },
                         child: Container(
                           alignment: Alignment.center,
                           width: MediaQuery.of(context).size.width,
                           padding: EdgeInsets.symmetric(vertical: 20),
                           decoration: BoxDecoration(
                             gradient: LinearGradient(
                                 colors: [
                                   const Color(0xff007EF4),
                                   const Color(0xff2A75BC),
                                 ]
                             ),
                             borderRadius: BorderRadius.circular(30),
                           ),
                           child: Text("Sign In", style: mediumTextStyle(),),
                         ),
                       ),
                       SizedBox(height: 16,),
                       Container(
                         alignment: Alignment.center,
                         width: MediaQuery.of(context).size.width,
                         padding: EdgeInsets.symmetric(vertical: 20),
                         decoration: BoxDecoration(
                           color: Colors.white,
                           borderRadius: BorderRadius.circular(30),
                         ),
                         child: Text("Sign In with Google", style: TextStyle(
                             color: Colors.black,
                             fontSize: 17
                         ),),
                       ),
                       SizedBox(height: 16,),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Text("Don't have account?", style: mediumTextStyle(),),
                           ElevatedButton(
                               child: FlatButton(
                                 onPressed: () {
                                   Navigator.pushReplacement(context,
                                   MaterialPageRoute(builder: (context) => SignUp()));

                                   // Navigate back to first route when tapped.
                                 },
                                 child: Text('Register Now',style: TextStyle(
                                     color: Colors.white,
                                     fontSize: 17,
                                     decoration: TextDecoration.underline

                                 ),),
                           ),

                           ),
                         ]
                       ),
                       SizedBox(height: 50, ),
                     ],
                   ),
                 ),
               ],
             ),
           ),
         ),
       ),
    );
  }
}