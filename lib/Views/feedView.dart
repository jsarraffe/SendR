import 'package:first/services/crud.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:first/Views/PostToFeed.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class FeedView extends StatefulWidget {
  @override
  _FeedviewState createState() => _FeedviewState();
}

class _FeedviewState extends State<FeedView> {
  CrudMethods crudMethods = new CrudMethods();


  Stream feedStream;

  Widget feedList() {
    return Container(
      child: feedStream != null
          ? Column(
        children: <Widget>[
          StreamBuilder(
            stream: feedStream,
            builder: (context, snapshot) {
              return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return FeedTile(
                      author: snapshot.data.docs[index].data()["authorName"],
                      title: snapshot.data.docs[index].data()["title"],
                      description: snapshot.data.docs[index].data()['description'],
                      imageUrl: snapshot.data.docs[index].data()['imgUrl'],
                    );
                  });
            },
          )
        ],
      )
          : Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  void initState() {
    crudMethods.getData().then((result) {
      setState(() {
        feedStream = result;
      });
    });
    super.initState();
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
          Text("Feed", style: TextStyle(fontSize: 22, color: Colors.blue),)
        ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: feedList(),
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          FloatingActionButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => CreateFeed()));
            },
            child: Icon(Icons.add),
          )
        ]),
      ),
    );
  }
}

class FeedTile extends StatelessWidget {
  String imageUrl, title, description, author;
  FeedTile({@required this.imageUrl,
    @required this.title,
    @required this.description,
    @required this.author});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      height: 150,
      child:  Stack(children: <Widget>[
        ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
        )),
        Container(
          height: 150,
          decoration: BoxDecoration(
            color: Colors.black45.withOpacity(.3),
            borderRadius: BorderRadius.circular(6)
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
          Text(
            title,
            style: TextStyle(fontSize: 22,fontWeight: FontWeight.w500),
          ),
              SizedBox(height: 4,),
              Text(description, style: TextStyle(fontSize: 22,fontWeight: FontWeight.w500)),
          SizedBox(height: 4,),
          Text(author, style: TextStyle(fontSize: 22,fontWeight: FontWeight.w500))

        ],
        ),
        )
      ],
      ),
    );
  }
}

