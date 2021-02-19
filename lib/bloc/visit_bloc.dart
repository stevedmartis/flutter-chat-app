import 'dart:async';
import 'package:chat/bloc/validators.dart';
import 'package:chat/models/aires_response.dart';
import 'package:chat/models/visit.dart';
import 'package:chat/models/visits_response.dart';
import 'package:chat/repository/aires_repository.dart';
import 'package:chat/repository/visits_repository.dart';
import 'package:rxdart/rxdart.dart';

class VisitBloc with Validators {
  final _degreesController = BehaviorSubject<String>();

  final _electroController = BehaviorSubject<String>();

  final _pHController = BehaviorSubject<String>();

  final _mLController = BehaviorSubject<String>();

  final _descriptionController = BehaviorSubject<String>();

  final _cutController = BehaviorSubject<bool>();

  final _cleanController = BehaviorSubject<bool>();

  final _temperatureController = BehaviorSubject<bool>();

  final _imageUpdateCtrl = BehaviorSubject<bool>();

  final _visitsController = BehaviorSubject<List<Visit>>();
  final AirRepository repository = AirRepository();

  final VisitRepository repositoryVisit = VisitRepository();

  final BehaviorSubject<VisitsResponse> _visitsUser =
      BehaviorSubject<VisitsResponse>();

  final BehaviorSubject<AiresResponse> _vist = BehaviorSubject<AiresResponse>();

  final BehaviorSubject<Visit> _visitSelect = BehaviorSubject<Visit>();

  BehaviorSubject<Visit> get visitSelect => _visitSelect;

  BehaviorSubject<AiresResponse> get vist => _vist;

  // Recuperar los datos del Stream
  Stream<String> get degreesStream =>
      _degreesController.stream.transform(validationNameRequired);
  Stream<String> get descriptionStream => _descriptionController.stream;
  Stream<bool> get cutStream => _cutController.stream;

  Stream<String> get phStream => _pHController.stream;

  Stream<String> get electroStream => _electroController.stream;

  Stream<String> get mlStream => _mLController.stream;
  BehaviorSubject<bool> get imageUpdate => _imageUpdateCtrl;

/*   Stream<bool> get formValidStream => Observable.combineLatest3(
      nameStream,
      wattsStream,
      kelvinStream,
      //timeOnStream,
      //timeOffStream,
      (a, b, c) => true); */

  getVisitsByUser(String uid) async {
    VisitsResponse response = await repositoryVisit.getVisits(uid);

    if (!_visitsUser.isClosed) _visitsUser.sink.add(response);
  }

  BehaviorSubject<VisitsResponse> get visitsUser => _visitsUser;

  Function(String) get changeDescription => _descriptionController.sink.add;
  Function(String) get changeDegrees => _degreesController.sink.add;

  Function(String) get changePh => _pHController.sink.add;

  Function(String) get changeElectro => _electroController.sink.add;

  Function(String) get changeMl => _mLController.sink.add;

  // Obtener el último valor ingresado a los streams
  bool get cut => _cutController.value;

  String get ml => _mLController.value;
  String get ph => _pHController.value;
  String get degrees => _degreesController.value;
  String get electro => _electroController.value;

  String get description => _descriptionController.value;

  dispose() {
    _visitsUser?.close();
    _imageUpdateCtrl?.close();
    _vist?.close();
    _visitSelect?.close();
    _descriptionController.close();
    _degreesController?.close();
    _electroController?.close();
    _pHController?.close();
    _mLController?.close();
    _cutController?.close();
    _cleanController?.close();
    _temperatureController?.close();
    _visitsController?.close();

    //  _roomsController?.close();
  }

  disposeRoom() {
    // _roomSelect?.close();
  }

  disposeRooms() {
    _visitSelect?.close();
    _vist.close();
  }
}

final visitBloc = VisitBloc();
