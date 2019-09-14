import 'package:bloc_pattern/bloc_pattern.dart';
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
      body: Center(),
    );
  }
}