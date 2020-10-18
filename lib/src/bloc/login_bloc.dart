

import 'dart:async';

import 'package:formvalidation/src/bloc/validators.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class LoginBloc with Validators {

  // Los StreamControllers no existen para rxDart
  /*final _emailController = StreamController<String>.broadcast();
  final _passwordController = StreamController<String>.broadcast();*/

  // Cuando se usa rxDart se debe implementar lo siguiente
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  // Recuperar los datos del stream
  Stream<String> get emailStream => _emailController.stream.transform(validarEmail);
  Stream<String> get passwordStream => _passwordController.stream.transform( validarPassword );

  Stream<bool> get formValidStream => 
    Rx.combineLatest2(emailStream, passwordStream, (a, b) => true);

  // insertar valores al Stream
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  // Obtener el ultimo valor del stream
  String get email => _emailController.value;
  String get password => _passwordController.value;

  dispose() {
    _emailController?.close();
    _passwordController?.close();
  }
}