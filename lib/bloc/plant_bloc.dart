import 'dart:async';
import 'package:chat/bloc/validators.dart';
import 'package:chat/models/plant.dart';
import 'package:chat/models/plants_response.dart';
import 'package:chat/models/fromPlant.dart';
import 'package:chat/repository/plants_repository.dart';
import 'package:rxdart/rxdart.dart';

class PlantBloc with Validators {
  final _nameController = BehaviorSubject<String>();
  final _descriptionController = BehaviorSubject<String>();

  final _quantityController = BehaviorSubject<String>();
  final _sexoController = BehaviorSubject<String>();

  final _germinatedController = BehaviorSubject<String>();
  final _floweringController = BehaviorSubject<String>();
  final _potController = BehaviorSubject<String>();
  final _cbdController = BehaviorSubject<String>();
  final _thcController = BehaviorSubject<String>();
  final _imageUpdateCtrl = BehaviorSubject<bool>();
  final _plantEdit = BehaviorSubject<bool>();

  final _ventilationController = BehaviorSubject<List<Ventilation>>();

  final _plantsController = BehaviorSubject<List<Plant>>();
  final PlantsRepository _repository = PlantsRepository();

  final BehaviorSubject<PlantsResponse> _subject =
      BehaviorSubject<PlantsResponse>();

  final BehaviorSubject<PlantsResponse> _plantsUser =
      BehaviorSubject<PlantsResponse>();

  final BehaviorSubject<Plant> _plantSelect = BehaviorSubject<Plant>();

  getPlants(String rooomId) async {
    PlantsResponse response = await _repository.getPlants(rooomId);

    if (!_subject.isClosed) _subject.sink.add(response);
  }

  getPlantsByUser(String uid) async {
    PlantsResponse response = await _repository.getPlantsUser(uid);

    if (!_plantsUser.isClosed) _plantsUser.sink.add(response);
  }

  getPlant(Plant plant) async {
    Plant response = await _repository.getPlant(plant.id);
    _plantSelect.sink.add(response);
  }

  BehaviorSubject<bool> get imageUpdate => _imageUpdateCtrl;
  BehaviorSubject<bool> get planEdit => _plantEdit;

  BehaviorSubject<Plant> get plantSelect => _plantSelect;

  BehaviorSubject<PlantsResponse> get subject => _subject;

  BehaviorSubject<PlantsResponse> get plantsUser => _plantsUser;

  // Recuperar los datos del Stream
  Stream<String> get nameStream =>
      _nameController.stream.transform(validationNameRequired);

  Stream<String> get descriptionStream => _descriptionController.stream;

  Stream<String> get quantityStream =>
      _quantityController.stream.transform(validationQuantityRequired);
  Stream<String> get sexoStream => _sexoController.stream;

  Stream<String> get germinatedStream => _germinatedController.stream;

  Stream<String> get floweringStream => _floweringController.stream;
  Stream<String> get potStream => _potController.stream;
  Stream<String> get cbdStream => _cbdController.stream;
  Stream<String> get tchStream => _thcController.stream;

  Stream<bool> get formValidStream =>
      Rx.combineLatest2(nameStream, quantityStream, (a, b) => true);

  Stream<List<Plant>> get plants => _plantsController.stream;
  // Insertar valores al Stream
  Function(List<Plant>) get addRoom => _plantsController.sink.add;
  Function(String) get changeName => _nameController.sink.add;
  Function(String) get changeDescription => _descriptionController.sink.add;
  Function(String) get changeQuantity => _quantityController.sink.add;

  Function(String) get changeThc => _thcController.sink.add;

  Function(String) get changeCbd => _cbdController.sink.add;

  Function(String) get changePot => _potController.sink.add;
  Function(String) get changeFlowering => _floweringController.sink.add;
  Function(List<Ventilation>) get changeVentilation =>
      _ventilationController.sink.add;

  // Obtener el último valor ingresado a los streams
  String get name => _nameController.value;
  String get description => _descriptionController.value;

  String get quantity => _quantityController.value;
  String get sexo => _sexoController.value;
  String get germinated => _germinatedController.value;
  String get flowering => _floweringController.value;
  String get pot => _potController.value;
  String get cbd => _cbdController.value;
  String get thc => _thcController.value;

  dispose() {
    _imageUpdateCtrl.close();
    _plantEdit.close();
    _plantsUser.close();
    _subject.close();
    _plantSelect.close();
    _nameController?.close();
    _ventilationController?.close();
    _descriptionController?.close();
    _quantityController?.close();
    _sexoController?.close();
    _germinatedController?.close();
    _floweringController?.close();
    _potController?.close();
    _cbdController?.close();
    _thcController?.close();

    //  _roomsController?.close();
  }

  disposePlants() {
    _plantsController?.close();
  }

  disposePlant() {
    _plantSelect?.close();
  }
}

final plantBloc = PlantBloc();
