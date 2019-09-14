import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_poc_firebase/repository/auth.dart';
import 'package:flutter_poc_firebase/bloc/session.dart';
import 'package:flutter_poc_firebase/view/home.dart';
import 'package:flutter_poc_firebase/view/login.dart';



void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return BlocProvider(
       child: MaterialApp(
        title: 'Login Firebase',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Consumer<SessionBloc>(
          builder: (BuildContext context, SessionBloc sessionBloc) {
            print("sessionBloc.uid ---> ${sessionBloc.uid}");
            
            if (sessionBloc.uid == null) {
              return LoginPage();
            }
            
            return HomePage();
          },
        ),
      ),
      blocs: [
        Bloc((i) => SessionBloc(Auth())),
      ],
    );
  }
}




