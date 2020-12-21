import 'package:first/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:first/services/auth.dart';
import 'package:provider/provider.dart';

import '../Widgets/widget.dart';
import '../Widgets/widget.dart';
import 'editProfile.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  AuthMethods auth;

  @override
  void initState(){
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthMethods>(context);
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            FutureBuilder(
              future: auth.getCurrentUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if(snapshot.hasData)
                    return displayUserInformation(context, snapshot);
                  else
                    return Center(child: Text('Something Wrong'));
                } else {
                  return CircularProgressIndicator();
                }
              },
            )
          ],
        ),
      ),

    );
  }
  Widget displayUserInformation(context, snapshot){
    return Center(
      child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text("Display name: ${snapshot.data["Display name"]}",style: simpleTextStyle(),),
            ),
            Divider(
              thickness: 2,
              color: Colors.black,
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text("Username: ${snapshot.data["username"]}",style:
              simpleTextStyle(),),
            ),
            Divider(
              thickness: 2,
              color: Colors.black,
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text("Bio: ${snapshot.data["bio"]}",style: simpleTextStyle(),),
            ),
            Divider(
              thickness: 2,
              color: Colors.black,
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text("Email: ${snapshot.data["email"]}",style:
              simpleTextStyle(),),
            ),
            Divider(
              thickness: 2,
              color: Colors.black,
            ),
            RaisedButton(
              child: Text('Edit Profile'),
              splashColor: Colors.purple,
              onPressed: () {Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => EditProfile()));},
            ),

            new Container(
                width: 190.0,
                height: 190.0,
                decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                        fit: BoxFit.fill,
                      image: ExactAssetImage('assets/images/GoodLuckBrian.jpeg'),
                    )
                )),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text("Tap To Edit Profile Picture",style: simpleTextStyle
                (),),
            ),



          ]
      ),
    );
    return Text(snapshot.data["Display name"]);

  }
}