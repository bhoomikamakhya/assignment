import 'dart:async';
import 'package:rxdart/rxdart.dart';

class LoginBloc{
  final _loginUsername=BehaviorSubject<String>();
  final _loginPassword=BehaviorSubject<String>();

  Stream<String> get loginUsername=>_loginUsername.stream;
  Stream<String> get loginPassword=>_loginPassword.stream;

  Function(String) get changeLoginUsername => _loginUsername.sink.add;
  Function(String) get changeLoginPassword => _loginPassword.sink.add;

  void dispose(){
    _loginUsername.close();
    _loginPassword.close();
}

}