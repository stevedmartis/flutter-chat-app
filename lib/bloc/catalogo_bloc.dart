import 'dart:async';
import 'package:chat/bloc/validators.dart';
import 'package:chat/models/catalogos_response.dart';
import 'package:chat/models/room.dart';
import 'package:chat/models/rooms_response.dart';
import 'package:chat/repository/catalogos_repository.dart';
import 'package:rxdart/rxdart.dart';

class CatalogoBloc with Validators {
  final _nameController = BehaviorSubject<String>();

  final _descriptionController = BehaviorSubject<String>();

  final _privacityController = BehaviorSubject<String>();

  final _roomsController = BehaviorSubject<List<Room>>();
  final CatalogosRepository _repository = CatalogosRepository();

  final BehaviorSubject<CatalogosResponse> _myCatalogos =
      BehaviorSubject<CatalogosResponse>();

  final BehaviorSubject<CatalogosResponse> _userCatalogos =
      BehaviorSubject<CatalogosResponse>();

  final BehaviorSubject<RoomsResponse> _roomsProfile =
      BehaviorSubject<RoomsResponse>();

  final BehaviorSubject<Room> _roomSelect = BehaviorSubject<Room>();

  getCatalogosUser(String userId, String userAuthId) async {
    CatalogosResponse response =
        await _repository.getCtalogos(userId, userAuthId);

    _userCatalogos.sink.add(response);
  }

  getMyCatalogos(String userId) async {
    CatalogosResponse response = await _repository.getMyCatalogos(userId);

    _myCatalogos.sink.add(response);
  }

/*   getRoomsProfile(String userId) async {
    RoomsResponse response = await _repository.g(userId);

    _roomsProfile.sink.add(response);
  } */

  getRoom(Room room) async {
    Room response = await _repository.getRoom(room.id);
    _roomSelect.sink.add(response);
  }

  BehaviorSubject<Room> get roomSelect => _roomSelect;

  BehaviorSubject<CatalogosResponse> get myCatalogos => _myCatalogos;

  BehaviorSubject<CatalogosResponse> get userCatalogos => _userCatalogos;

  BehaviorSubject<RoomsResponse> get roomsProfile => _roomsProfile;

  // Recuperar los datos del Stream
  Stream<String> get nameStream =>
      _nameController.stream.transform(validationNameRequired);
  Stream<String> get descriptionStream => _descriptionController.stream;

  Stream<List<Room>> get rooms => _roomsController.stream;
  // Insertar valores al Stream
  Function(List<Room>) get addRoom => _roomsController.sink.add;
  Function(String) get changeName => _nameController.sink.add;
  Function(String) get changeDescription => _descriptionController.sink.add;

  Stream<String> get privacityStream => _privacityController.stream;

  // Obtener el último valor ingresado a los streams
  String get name => _nameController.value;
  String get description => _descriptionController.value;
  String get privacity => _privacityController.value;

  dispose() {
    _roomsProfile.close();
    _myCatalogos.close();
    _userCatalogos.close();
    _roomSelect.close();
    _privacityController?.close();

    _nameController?.close();

    _descriptionController?.close();

    //  _roomsController?.close();
  }

  disposeRoom() {
    // _roomSelect?.close();
  }

  disposeRooms() {
    _roomsController?.close();
    _myCatalogos.close();
  }
}

final catalogoBloc = CatalogoBloc();
