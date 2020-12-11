import 'dart:async';
import 'package:chat/bloc/validators.dart';
import 'package:rxdart/rxdart.dart';

class RegisterBloc with Validators {
  final _emailController = BehaviorSubject<String>();
  final _nameController = BehaviorSubject<String>();
  final _lastNameController = BehaviorSubject<String>();

  // Recuperar los datos del Stream
  Stream<String> get emailStream =>
      _emailController.stream.transform(validarEmail);
  Stream<String> get nameStream =>
      _nameController.stream.transform(validarEmail);
  Stream<String> get lastNameStream =>
      _lastNameController.stream.transform(validarEmail);

  Stream<bool> get formValidStream => Observable.combineLatest3(
      emailStream, _nameController, _lastNameController, (e, p, c) => true);

  // Insertar valores al Stream
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _nameController.sink.add;

  // Obtener el último valor ingresado a los streams
  String get email => _emailController.value;
  String get name => _nameController.value;

  dispose() {
    _emailController?.close();
    _nameController?.close();
    _lastNameController?.close();
  }
}
