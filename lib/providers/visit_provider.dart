import 'package:chat/global/environment.dart';
import 'package:chat/models/plant.dart';
import 'package:chat/models/plant_response.dart';
import 'package:chat/models/visit.dart';
import 'package:chat/models/visits_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class VisitApiProvider {
  final String _endpoint = '${Environment.apiUrl}/visit/visits/plant/';

  final _storage = new FlutterSecureStorage();

  Future<VisitsResponse> getVisit(String plantId) async {
    final urlFinal = _endpoint + '$plantId';

    final token = await this._storage.read(key: 'token');

    try {
      final resp = await http.get(urlFinal,
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final visitResponse = visitsResponseFromJson(resp.body);
      return visitResponse;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return VisitsResponse.withError("$error");
    }
  }

  Future<List<Visit>> getVisitPlant(String plantId) async {
    final urlFinal = _endpoint + '$plantId';

    final token = await this._storage.read(key: 'token');

    try {
      final resp = await http.get(urlFinal,
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final visitResponse = visitsResponseFromJson(resp.body);
      return visitResponse.visits;
    } catch (e) {
      return [];
    }
  }

  final String _endpointRoom = '${Environment.apiUrl}/plant/plant/';

  Future<Plant> getPlant(String roomId) async {
    final urlFinal = _endpointRoom + '$roomId';

    final token = await this._storage.read(key: 'token');

    try {
      final resp = await http.get(urlFinal,
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final plantResponse = plantResponseFromJson(resp.body);
      return plantResponse.plant;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return new Plant(id: '0');
    }
  }

  Future deletePlant(String plantId) async {
    final token = await this._storage.read(key: 'token');

    try {
      await http.delete('${Environment.apiUrl}/plant/delete/$plantId',
          headers: {'Content-Type': 'application/json', 'x-token': token});

      return true;
    } catch (e) {
      return false;
    }
  }
}
