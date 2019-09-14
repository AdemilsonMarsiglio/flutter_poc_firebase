import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_poc_firebase/repository/auth.dart';

class SessionBloc extends BlocBase {

  SessionBloc({this.auth});

  Auth auth;
  
  String uid;
  String mensagemError;

  login(String _email, String _password) async {
    uid = null;
    mensagemError = null;

    try {
      uid = await auth.signIn(_email, _password);
      
      if (uid.length > 0) {
        print("Usuario autenticado!");
        notifyListeners();
      }
    } catch (e) {

      if ("ERROR_USER_NOT_FOUND" == e.code) 
        return mensagemError = ("Usuário não encontrado.");
      
      if ("ERROR_INVALID_EMAIL" == e.code) 
        return mensagemError = ("E-mail inválido.");

      if ("ERROR_WRONG_PASSWORD" == e.code) 
        return mensagemError = ("Senha incorreta ou usuário não encontrado.");
        
      if ("ERROR_TOO_MANY_REQUESTS" == e.code) 
        return mensagemError = ("Ops! Percebemos um comportamento estranho, recebemos muitas requisições inválidas de seu dispositivo. Tente novamente mais tarde.");

      mensagemError = (e.message);
      print('Error: $e');
    }
  }

  logout() async {
    await auth.signOut();
    uid = null;
    notifyListeners();
  }
}