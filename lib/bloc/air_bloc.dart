import 'dart:async';
import 'package:chat/bloc/validators.dart';
import 'package:chat/models/air.dart';
import 'package:chat/models/aires_response.dart';
import 'package:chat/repository/aires_repository.dart';
import 'package:rxdart/rxdart.dart';

class AirBloc with Validators {
  final _nameController = BehaviorSubject<String>();

  final _descriptionController = BehaviorSubject<String>();

  final _airesController = BehaviorSubject<List<Air>>();
  final AirRepository _repository = AirRepository();

  final BehaviorSubject<AiresResponse> _aires =
      BehaviorSubject<AiresResponse>();

  final BehaviorSubject<Air> _airSelect = BehaviorSubject<Air>();

  getAires(String roomId) async {
    AiresResponse response = await _repository.getAires(roomId);

    _aires.sink.add(response);
  }

  getAir(Air room) async {
    Air response = await _repository.getAir(room.id);
    _airSelect.sink.add(response);
  }

  BehaviorSubject<Air> get airSelect => _airSelect;

  BehaviorSubject<AiresResponse> get subject => _aires;

  // Recuperar los datos del Stream
  Stream<String> get nameStream =>
      _nameController.stream.transform(validationNameRequired);
  Stream<String> get descriptionStream => _descriptionController.stream;

  Stream<bool> get formValidStream => Observable.combineLatest2(
      nameStream,
      descriptionStream,
      //timeOnStream,
      //timeOffStream,
      (a, b) => true);

  Function(String) get changeName => _nameController.sink.add;
  Function(String) get changeDescription => _descriptionController.sink.add;

  // Obtener el último valor ingresado a los streams
  String get name => _nameController.value;
  String get description => _descriptionController.value;

  dispose() {
    _aires.close();
    _airSelect.close();
    _nameController?.close();

    _descriptionController?.close();

    //  _roomsController?.close();
  }

  disposeRoom() {
    // _roomSelect?.close();
  }

  disposeRooms() {
    _airesController?.close();
    _aires.close();
  }
}

final airBloc = AirBloc();
