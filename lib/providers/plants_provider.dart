import 'package:chat/global/environment.dart';
import 'package:chat/models/plant.dart';
import 'package:chat/models/plants_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class PlantsApiProvider {
  final String _endpoint = '${Environment.apiUrl}/plant/plants/room/';

  final _storage = new FlutterSecureStorage();

  Future<PlantsResponse> getPlants(String roomId) async {
    final urlFinal = _endpoint + '$roomId';

    final token = await this._storage.read(key: 'token');

    try {
      final resp = await http.get(urlFinal,
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final plantsResponse = plantsResponseFromJson(resp.body);
      return plantsResponse;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return PlantsResponse.withError("$error");
    }
  }

  Future<List<Plant>> getPlantsRoom(String roomId) async {
    final urlFinal = _endpoint + '$roomId';

    final token = await this._storage.read(key: 'token');

    try {
      final resp = await http.get(urlFinal,
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final plantsResponse = plantsResponseFromJson(resp.body);
      return plantsResponse.plants;
    } catch (e) {
      return [];
    }
  }
}
