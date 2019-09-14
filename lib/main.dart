import 'package:flutter/material.dart';
import 'package:flutter_poc_firebase/auth.dart';
import 'package:flutter_poc_firebase/login.dart';



void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Firebase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(auth: Auth(),),
    );
  }
}




