import 'package:first/Views/chatRoomsScreen.dart';
import 'package:first/Views/signin.dart';
import 'package:first/Widgets/widget.dart';
import 'package:first/helper/helperfunctions.dart';
import 'package:first/services/auth.dart';
import 'package:first/services/database.dart';
import 'package:flutter/material.dart';
import 'package:first/Views/editProfile.dart';
import 'package:first/helper/helperfunctions.dart';

class SignUp extends StatefulWidget {
  @override

  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;

  HelperFunctions helperFunctions = new HelperFunctions();
  
  AuthMethods authMethods = new AuthMethods();

  DatabaseMethods databaseMethods = new DatabaseMethods();


  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController = new
  TextEditingController();
  TextEditingController emailTextEditingController = new
  TextEditingController();
  TextEditingController passwordTextEditingController = new
  TextEditingController();

  signMeUp(){
    if(formKey.currentState.validate()){

      // Map<String,String> userDataMap = {
      //   "userName" : userNameTextEditingController.text,
      //   "userEmail" : emailTextEditingController.text,
      // };
      HelperFunctions.saveUserEmailSharedPrefrence
        (emailTextEditingController.text);
      HelperFunctions.saveUserNameSharedPreference
        (userNameTextEditingController.text);


      //databaseMethods.addUserInfo(userDataMap);

      setState(() {
          isLoading = true;
      });
      authMethods.signUpWithEmailAndPassword(emailTextEditingController.text,
          passwordTextEditingController.text).then((val){
            print("$val.uid");
            authMethods.newUserInfo(null, userNameTextEditingController.text, emailTextEditingController.text, null,AuthMethods().getCurrentUID());
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => EditProfile(),
            ));

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading ? Container(
        child: Center(child: CircularProgressIndicator()),
      ) :SingleChildScrollView(
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
                          return val.isEmpty || val.length < 4 ? "Please "
                          "Provide  a valid Username" :null;
                        },
                        controller: userNameTextEditingController,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration('username'),
                      ),
                      TextFormField(
                        validator: (val){
                          return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9"
                          r".!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(val) ? null : "Enter valid email";
                        },
                        controller: emailTextEditingController,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration('email'),
                      ),
                      TextFormField(
                        validator: (val){
                          return val.length > 6 ? null : "Please provide 6+ "
                              "character password";
                        },
                        controller: passwordTextEditingController,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration('password'),
                        obscureText: true,
                      ),
                    ],
                  ),
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
                    signMeUp();
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
                    child: Text("Sign Up", style: mediumTextStyle(),),
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
                  child: Text("Sign Up with Google", style: TextStyle(
                      color: Colors.black,
                      fontSize: 17
                  ),),
                ),
                SizedBox(height: 16,),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have account?", style: mediumTextStyle(),),
                      ElevatedButton(
                        child: FlatButton(
                          onPressed: () {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) => SignIn()
                                  ));
                            // Navigate back to first route when tapped.
                          },
                          child: Text('Sign in now',style: TextStyle(
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
        ),
      ),
    );
  }
}

