import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_poc_firebase/auth.dart';

class ValueBloc extends BlocBase {
  
  String uid = null;
  String mensagemError = null;


  login(Auth auth, String _email, String _password) async {

    // setState(() {
    //   _isLoading = true;
    // });
  
    uid = "";
    mensagemError = "";

    try {
      uid = await auth.signIn(_email, _password);
      
      if (uid.length > 0) {
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
    }
  }

}