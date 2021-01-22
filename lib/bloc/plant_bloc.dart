import 'dart:async';
import 'package:chat/bloc/validators.dart';
import 'package:chat/models/plant.dart';
import 'package:chat/models/plant_response.dart';
import 'package:chat/models/ventilation.dart';
import 'package:chat/repository/plants_repository.dart';
import 'package:rxdart/rxdart.dart';

class PlantBloc with Validators {
  final _nameController = BehaviorSubject<String>();
  final _descriptionController = BehaviorSubject<String>();
  final _co2Controller = BehaviorSubject<bool>();
  final _co2ControlController = BehaviorSubject<bool>();
  final _ventilationController = BehaviorSubject<List<Ventilation>>();
  final _kelvinController = BehaviorSubject<String>();
  final _wattsController = BehaviorSubject<String>();
  final _typeLightController = BehaviorSubject<String>();
  final _wideController = BehaviorSubject<String>();
  final _longController = BehaviorSubject<String>();
  final _tallController = BehaviorSubject<String>();

  final _timeOnController = BehaviorSubject<String>();
  final _timeOffController = BehaviorSubject<String>();

  final _plantsController = BehaviorSubject<List<Plant>>();
  final PlantsRepository _repository = PlantsRepository();

  final BehaviorSubject<PlantsResponse> _subject =
      BehaviorSubject<PlantsResponse>();

  final BehaviorSubject<Plant> _plantSelect = BehaviorSubject<Plant>();

  getPlants(String rooomId) async {
    print(rooomId);
    PlantsResponse response = await _repository.getPlants(rooomId);
    _subject.sink.add(response);
  }

  getPlant(Plant plant) async {
    print(plant);
    //RoomsResponse response = await _repository.getRooms(userId);
    _plantSelect.sink.add(plant);
  }

  BehaviorSubject<Plant> get plantSelect => _plantSelect;

  BehaviorSubject<PlantsResponse> get subject => _subject;

  // Recuperar los datos del Stream
  Stream<String> get nameStream =>
      _nameController.stream.transform(validationNameRequired);
  Stream<String> get descriptionStream => _descriptionController.stream;
  Stream<String> get typeLightStream =>
      _typeLightController.stream.transform(validationUserNameRequired);
  Stream<bool> get co2CompleteStream => _co2ControlController.stream;
  Stream<bool> get co2Stream => _co2Controller.stream;
  Stream<List<Ventilation>> get ventilationStream =>
      _ventilationController.stream;
  Stream<String> get kelvinStream => _kelvinController.stream;
  Stream<String> get wattsStream => _wattsController.stream;
  Stream<String> get wideStream =>
      _wideController.stream.transform(validationWideRequired);
  Stream<String> get longStream =>
      _longController.stream.transform(validationLongRequired);
  Stream<String> get tallStream =>
      _tallController.stream.transform(validationTallRequired);

  Stream<String> get timeOnStream =>
      _timeOnController.stream.transform(validationTimeOnRequired);

  Stream<String> get timeOffStream =>
      _timeOffController.stream.transform(validationTimeOffRequired);

  Stream<bool> get formValidStream => Observable.combineLatest4(
      nameStream,
      wideStream,
      longStream,
      tallStream,
      //timeOnStream,
      //timeOffStream,
      (a, b, c, d) => true);

  Stream<List<Plant>> get plants => _plantsController.stream;
  // Insertar valores al Stream
  Function(List<Plant>) get addRoom => _plantsController.sink.add;
  Function(String) get changeName => _nameController.sink.add;
  Function(String) get changeDescription => _descriptionController.sink.add;
  Function(List<Ventilation>) get changeVentilation =>
      _ventilationController.sink.add;
  Function(bool) get changeCo2 => _co2Controller.sink.add;
  Function(bool) get changeCo2Control => _co2ControlController.sink.add;
  Function(String) get changeKelvin => _kelvinController.sink.add;
  Function(String) get changeWatts => _wattsController.sink.add;
  Function(String) get changeTypeLight => _typeLightController.sink.add;
  Function(String) get changeWide => _wideController.sink.add;
  Function(String) get changeLong => _longController.sink.add;
  Function(String) get changeTall => _tallController.sink.add;

  Function(String) get changeTimeOn => _timeOnController.sink.add;
  Function(String) get changeTimeOff => _timeOffController.sink.add;

  // Obtener el último valor ingresado a los streams
  String get name => _nameController.value;
  String get description => _descriptionController.value;

  String get wide => _wideController.value;
  String get long => _longController.value;
  String get tall => _tallController.value;

  bool get co2 => _co2Controller.value;
  bool get co2Control => _co2ControlController.value;

  String get timeOn => _timeOnController.value;

  String get timeOff => _timeOffController.value;

  dispose() {
    _subject.close();
    _plantSelect.close();
    _nameController?.close();
    _ventilationController?.close();
    _co2Controller?.close();

    _co2ControlController?.close();
    _descriptionController?.close();
    _kelvinController?.close();
    _wattsController?.close();
    _typeLightController?.close();
    _wideController?.close();
    _longController?.close();
    _tallController?.close();
    _timeOnController?.close();
    _timeOffController?.close();

    //  _roomsController?.close();
  }

  disposeRooms() {
    _plantsController?.close();
    _co2Controller?.close();
    _co2ControlController?.close();
    _descriptionController?.close();
    _nameController?.close();
    _wideController?.close();
    _longController?.close();
    _tallController?.close();
    _timeOnController?.close();
    _timeOffController?.close();
  }
}

final plantBloc = PlantBloc();
