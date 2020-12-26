import 'dart:async';
import 'package:chat/bloc/validators.dart';
import 'package:chat/models/room.dart';
import 'package:chat/models/rooms_response.dart';
import 'package:chat/repository/rooms_repository.dart';

import 'package:rxdart/rxdart.dart';

class RoomBloc with Validators {
  final _nameController = BehaviorSubject<String>();
  final _descriptionController = BehaviorSubject<String>();

  final _roomsController = BehaviorSubject<List<Room>>();

  final RoomsRepository _repository = RoomsRepository();

  final BehaviorSubject<RoomsResponse> _subject =
      BehaviorSubject<RoomsResponse>();

  getRooms(String userId) async {
    RoomsResponse response = await _repository.getRooms(userId);
    _subject.sink.add(response);
  }

  BehaviorSubject<RoomsResponse> get subject => _subject;
  // Recuperar los datos del Stream
  Stream<String> get nameStream =>
      _nameController.stream.transform(validationRequired);
  Stream<String> get descriptionStream =>
      _descriptionController.stream.transform(validationRequired);

  Stream<bool> get formValidStream =>
      Observable.combineLatest2(nameStream, descriptionStream, (e, p) => true);

  Stream<List<Room>> get products => _roomsController.stream;

  Function(List<Room>) get addRoom => _roomsController.sink.add;

  // Insertar valores al Stream
  Function(String) get changeName => _nameController.sink.add;
  Function(String) get changeDescription => _descriptionController.sink.add;

  // Obtener el último valor ingresado a los streams

  String get name => _nameController.value;
  String get description => _descriptionController.value;

  dispose() {
    _subject.close();

    _nameController?.close();
    _descriptionController?.close();
    _roomsController?.close();
  }
}

final roomBloc = RoomBloc();
