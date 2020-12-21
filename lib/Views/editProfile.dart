import 'package:flutter/material.dart';
import 'package:first/Widgets/widget.dart';
import 'package:first/services/auth.dart';
import '../Widgets/widget.dart';
import 'home.dart';

class EditProfile extends StatefulWidget {
  @override
  _editProfileState createState() => _editProfileState();
}

class _editProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  AuthMethods authMethods = new AuthMethods();
  TextEditingController usernameEditingController = new TextEditingController();
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController bioEditingController = new TextEditingController();
  TextEditingController displayEditingController = new TextEditingController();

  UpdateInfo() {
    authMethods.newUserInfo(displayEditingController.text, usernameEditingController.text,
        emailEditingController.text, bioEditingController.text, AuthMethods()
            .getCurrentUID());
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) => Home(),
    ));

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.brown,
            elevation: 1,
            leading: IconButton(
              icon: Icon(
                Icons.save,
                color: Colors.white,
              ),
              onPressed: ()
              {
                UpdateInfo();
              },
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                onPressed: () {

                },
              ),
            ]
        ),
        body: Container(
          padding: EdgeInsets.only(left: 16, top: 25, right: 16),
          child: GestureDetector(
            onTap: (){
              FocusScope.of(context).unfocus();
            },
            child: ListView(
              children: [
                Text(
                  "Edit Profile",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width:130,
                        height:130,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 4,
                                color: Theme.of(context).scaffoldBackgroundColor
                            ),
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 2, blurRadius: 10,
                                  color: Colors.white.withOpacity(0.1),
                                  offset: Offset(0,10)
                              )
                            ],
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage("https://moonvillageassociation.org/wp-content/uploads/2018/06/default-profile-picture1.jpg")
                            )
                        ),
                      ),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 4,
                                color: Theme
                                    .of(context)
                                    .scaffoldBackgroundColor,
                              ),
                              color: Colors.white,
                            ),
                            child: Icon(
                              Icons.edit,
                              color: Colors.black,
                            ),
                          )),
                    ],
                  ),
                ),


                SizedBox(
                  height: 50,
                ),
                TextField(
                  controller: usernameEditingController,
                  style: simpleTextStyle(),
                  decoration: textFieldInputDecoration("username"),
                ),
                TextField(
                  controller: emailEditingController,
                  style: simpleTextStyle(),
                  decoration: textFieldInputDecoration('email'),
                ),
                  TextField(
                    controller: bioEditingController,
                    style: simpleTextStyle(),
                    decoration: textFieldInputDecoration('Bio'),
                  ),
                  TextField(
                    controller: displayEditingController,
                    style: simpleTextStyle(),
                    decoration: textFieldInputDecoration("Display name"),

                )
              ],
            ),
          ),
        )
    );
  }


  Widget buildTextField( String labelText, String placeholder, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.all(35.0),
      child: TextField(
        obscureText: isPasswordTextField, //checks bool in buildtext
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold,
              color: Colors.white,
            )
        ),
      ),
    );
  }
}
