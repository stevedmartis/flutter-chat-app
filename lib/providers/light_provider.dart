import 'package:chat/global/environment.dart';
import 'package:chat/models/light.dart';
import 'package:chat/models/lights_response.dart';
import 'package:chat/models/plant.dart';
import 'package:chat/models/plant_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class LightApiProvider {
  final _storage = new FlutterSecureStorage();

  Future<LightsResponse> getLight(String roomId) async {
    final urlFinal =
        Uri.https('${Environment.apiUrl}', '/api/light/lights/room/$roomId');

    final token = await this._storage.read(key: 'token');

    try {
      final resp = await http.get(urlFinal,
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final lightsResponse = lightsResponseFromJson(resp.body);
      return lightsResponse;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return LightsResponse.withError("$error");
    }
  }

  Future<List<Light>> getLightsRoom(String roomId) async {
    final urlFinal =
        Uri.https('${Environment.apiUrl}', '/api/light/lights/room/$roomId');

    final token = await this._storage.read(key: 'token');

    try {
      final resp = await http.get(urlFinal,
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final lightsResponse = lightsResponseFromJson(resp.body);
      return lightsResponse.lights;
    } catch (e) {
      return [];
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

  Future deleteLight(String lightId) async {
    final token = await this._storage.read(key: 'token');

    final urlFinal =
        Uri.https('${Environment.apiUrl}', '/api/light/delete/$lightId');

    try {
      await http.delete(urlFinal,
          headers: {'Content-Type': 'application/json', 'x-token': token});

      return true;
    } catch (e) {
      return false;
    }
  }
}
