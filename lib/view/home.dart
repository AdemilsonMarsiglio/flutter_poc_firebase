import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_poc_firebase/bloc/session.dart';
import 'package:flutter_poc_firebase/view/form.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              final SessionBloc bloc = BlocProvider.getBloc<SessionBloc>();
              bloc.logout();
            },
            icon: Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('posts').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));

          switch (snapshot.connectionState) {
            case ConnectionState.waiting: 
              return Center(child: Text('Loading...'));
            default:
              return new ListView(
                padding: EdgeInsets.only(bottom: 100),
                children: snapshot.data.documents.map((DocumentSnapshot document) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    child: Material(
                      child: Card(
                        child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FormPage(document: document,)),
                          );
                        },
                        leading: CircleAvatar(
                          // child: Text(document['title'].substring(0, 1))
                          child: document['image'] == null || document['image'].toString().isEmpty
                                  ? Text(document['title'].substring(0, 1))
                                  : CachedNetworkImage(
                                      imageUrl: document['image'],
                                      imageBuilder: (context, imageProvider) => Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover
                                          ),
                                        ),
                                      ),
                                      placeholder: (context, url) => CircularProgressIndicator(),
                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                  )
                        ),
                        title: new Text(document['title']),
                        subtitle: new Text(document['subtitle'] == null ? "" : document['subtitle']),
                      ),
                      ),
                    ),
                  );
                }).toList(),
              );
          }
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FormPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}