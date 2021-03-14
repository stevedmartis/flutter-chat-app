import 'package:chat/global/environment.dart';
import 'package:chat/models/plant.dart';
import 'package:chat/models/plant_response.dart';
import 'package:chat/models/visit.dart';
import 'package:chat/models/visits_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class VisitApiProvider {
  final _storage = new FlutterSecureStorage();

  Future<VisitsResponse> getVisit(String plantId) async {
    final urlFinal =
        Uri.https('${Environment.apiUrl}', '/api/visit/visits/plant/$plantId');

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
    final urlFinal =
        Uri.https('${Environment.apiUrl}', '/api/visit/visits/plant/$plantId');

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

  Future<VisitsResponse> getLastVisitsByUser(String userId) async {
    try {
      final token = await this._storage.read(key: 'token');

      final urlFinal =
          Uri.https('${Environment.apiUrl}', '/api/visit/visits/user/$userId');

      final resp = await http.get(urlFinal,
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final visitsResponse = visitsResponseFromJson(resp.body);

      return visitsResponse;
    } catch (error) {
      return VisitsResponse.withError("$error");
    }
  }

  Future<Plant> getPlant(String roomId) async {
    final urlFinal =
        Uri.https('${Environment.apiUrl}', '/api/plant/plant/$roomId');

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

    final urlFinal =
        Uri.https('${Environment.apiUrl}', '/api/plant/delete/$plantId');

    try {
      await http.delete(urlFinal,
          headers: {'Content-Type': 'application/json', 'x-token': token});

      return true;
    } catch (e) {
      return false;
    }
  }
}
