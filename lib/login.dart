import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_poc_firebase/auth.dart';

class LoginPage extends StatefulWidget {
  
  LoginPage({Key key, this.auth}) : super(key: key);

  final BaseAuth auth;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _passFocusNode = FocusNode();
  final globalKey = GlobalKey<ScaffoldState>();

  bool _isLoading;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      body: Center(
        child: ListView(
          children: <Widget>[
            _widgetBoasVindas(),
            _widgetEmail(),
            _widgetPassword(),
            _widgetButton(),
            _showCircularProgress()
          ],
        ),
      )
    );
  }

  Widget _showCircularProgress(){
    if (_isLoading) 
      return Center(child: CircularProgressIndicator());
    
    return Container(height: 0.0, width: 0.0,);
  }

  _widgetBoasVindas() {
    return Padding(
      padding: EdgeInsets.only(top: 100),
      child: Column(
        children: <Widget>[
          Text("Bem Vindo", style: TextStyle(fontSize: 30)),
          Divider(endIndent: 50, indent: 50,),
          Text("Informe suas credenciais", style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }

  _widgetEmail() {
    return Padding(
      padding: EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        elevation: 10,
        child: TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (text) {
            FocusScope.of(context).requestFocus(_passFocusNode);
          },
          decoration: InputDecoration(
            icon: Padding(
              padding: EdgeInsets.only(left: 20),
              child: Icon(Icons.person),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              borderSide: BorderSide.none,
            ),
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 15
            ),
            hintText: 'digite seu e-mail'
          ),
        ),
      ),
    );
  }

  _widgetPassword() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        elevation: 10,
        child: TextFormField(
          obscureText: true,
          focusNode: _passFocusNode,
          controller: _passController,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (text) {
            _login();
          },
          decoration: InputDecoration(
            icon: Padding(
              padding: EdgeInsets.only(left: 20),
              child: Icon(Icons.lock),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              borderSide: BorderSide.none,
            ),
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 15
            ),
            hintText: 'digite sua senha'
          ),
        ),
      ),
    );
  }

  _widgetButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(20),
          child: Material(
            color: _isLoading ? Colors.lightBlueAccent: Colors.blue,
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            elevation: 10,
            child: InkWell(
              onTap: _isLoading ? null :  _login,
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),  
                child: Text("Entrar", style: TextStyle(fontSize: 15, color: Colors.white),),
              ),
            ),
          ),
        )
      ],
    );
  }

  _login() async {
    String _email = _emailController.text;
    String _password = _passController.text;

    setState(() {
      _isLoading = true;
    });
  
    String userId = "";

    try {
      userId = await widget.auth.signIn(_email, _password);
      print('Signed in: $userId');

      if (userId.length > 0 && userId != null) {
        _snackInfo("Usuario autenticado!");
      }
    } catch (e) {

      if ("ERROR_USER_NOT_FOUND" == e.code) 
        return _snackWarn("Usuário não encontrado.");
      
      if ("ERROR_INVALID_EMAIL" == e.code) 
        return _snackWarn("E-mail inválido.");

      if ("ERROR_WRONG_PASSWORD" == e.code) 
        return _snackWarn("Senha incorreta ou usuário não encontrado.");
        
      if ("ERROR_TOO_MANY_REQUESTS" == e.code) 
        return _snackWarn("Ops! Percebemos um comportamento estranho, recebemos muitas requisições inválidas de seu dispositivo. Tente novamente mais tarde.");



      _snackWarn(e.message);
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  _snackInfo(String text) {
    final snackbar = SnackBar(
      content: Text(text),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.green,
      duration: Duration(seconds: 1),
    );

    globalKey.currentState.removeCurrentSnackBar();
    globalKey.currentState.showSnackBar(snackbar);
  }

  _snackWarn(text) {
    final snackbar = SnackBar(
      content: Text(text),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.amber,
      duration: Duration(seconds: 1),
    );

    globalKey.currentState.removeCurrentSnackBar();
    globalKey.currentState.showSnackBar(snackbar);
  }
}
