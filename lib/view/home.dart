import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_poc_firebase/bloc/session.dart';

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
            return new Text('Error: ${snapshot.error}');

          switch (snapshot.connectionState) {
            case ConnectionState.waiting: 
              return new Text('Loading...');
            default:
              return new ListView(
                children: snapshot.data.documents.map((DocumentSnapshot document) {
                  return new ListTile(
                    onTap: () {
                      String subtitle = document['subtitle'];

                      if (subtitle == null) {
                        subtitle = "";
                      }
                      document.reference.updateData({
                        'subtitle':  subtitle + " edit"
                      });
                    },
                    leading: CircleAvatar(
                      child: document['image'] == null 
                              ? Text(document['title'].substring(0, 1))
                              : CachedNetworkImage(
                                  imageUrl: document['image'],
                                  placeholder: (context, url) => new CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => new Icon(Icons.error),
                              )
                              // Image.network(document['image'], fit: BoxFit.cover,),
                    ),
                    title: new Text(document['title']),
                    subtitle: new Text(document['subtitle'] == null ? "" : document['subtitle']),
                  );
                }).toList(),
              );
          }
        }
      ),
    );
  }
}