import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:first/services/crud.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';


class CreateFeed extends StatefulWidget {
  @override
  _CreateFeedState createState() => _CreateFeedState();
}

class _CreateFeedState extends State<CreateFeed> {
  String name, title, description;
  CrudMethods curdMethods = new CrudMethods();

  File selectedImage;
  bool _isLoading = false;
  final picker = ImagePicker();
  Future getImage() async {
    var pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        selectedImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  uploadFeed() async {
    if(selectedImage != null){
      setState(() {
        _isLoading = true;
      });
      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child("feedImages")
          .child("${randomAlphaNumeric(9)}.jpg");
      final UploadTask task = firebaseStorageRef.putFile(selectedImage);

      var downloadUrl = await (await task.whenComplete(() => null)).ref.getDownloadURL();
      print("This is the download url $downloadUrl");
      Map<String,String> feedMap = {
        "imgUrl": downloadUrl,
        "authorName": name,
        "title": title,
        "description": description,
      };
      curdMethods.addData(feedMap).then((result){
        Navigator.pop(context);
      });

    }else{
      print('No image selected!');
    }
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
            Text(" Post to Feed", style: TextStyle(fontSize: 22, color: Colors.blue),)
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          GestureDetector(
            onTap: (){
              uploadFeed();
            },
            child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(Icons.file_upload)),
          )
        ]
      ),
      body: _isLoading ? Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ) : Container(child: Column(children: <Widget>[
        SizedBox(height: 10,),
        GestureDetector(
          onTap: (){
            getImage();
          },
          child: selectedImage != null ? Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.file(
                  selectedImage,
                  fit: BoxFit.cover,
                ),
            ),
          )
              : Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6)
            ),
            width: MediaQuery.of(context).size.width,
          child: Icon(
            Icons.add_a_photo,
            color: Colors.black45,
          ),
          ),
        ),
        SizedBox(height: 8,),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: <Widget>[
            TextField(
            decoration: InputDecoration(hintText: "Title"),
              onChanged: (val){
              title = val;
              },
            ),
              TextField(
                decoration: InputDecoration(hintText: "Display Name"),
                onChanged: (val){
                  name = val;
                },
              ),
              TextField(
                decoration: InputDecoration(hintText: "Description"),
                onChanged: (val){
                  description = val;
                },
              )
         ],
        ),
        ),
      ],
        ),
      ),
    );
  }
}
