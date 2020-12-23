import 'dart:async';
import 'package:chat/bloc/validators.dart';
import 'package:rxdart/rxdart.dart';

class RoomBloc with Validators {
  final _nameController = BehaviorSubject<String>();
  final _descriptionController = BehaviorSubject<String>();

  // Recuperar los datos del Stream
  Stream<String> get nameStream =>
      _nameController.stream.transform(validationNameRoom);
  Stream<String> get descriptionStream =>
      _descriptionController.stream.transform(validationNameRoom);

  Stream<bool> get formValidStream =>
      Observable.combineLatest2(nameStream, descriptionStream, (e, p) => true);

  // Insertar valores al Stream
  Function(String) get changeName => _nameController.sink.add;

  // Obtener el último valor ingresado a los streams

  String get name => _nameController.value;
  String get description => _descriptionController.value;

  dispose() {
    _nameController?.close();
    _descriptionController?.close();
  }
}
