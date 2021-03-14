import 'package:chat/global/environment.dart';
import 'package:chat/models/air.dart';
import 'package:chat/models/air_response.dart';
import 'package:chat/models/aires_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AiresApiProvider {
  final _storage = new FlutterSecureStorage();

  Future<AiresResponse> getAires(String roomId) async {
    final urlFinal =
        Uri.https('${Environment.apiUrl}', '/api/air/airs/room/$roomId');

    final token = await this._storage.read(key: 'token');

    try {
      final resp = await http.get(urlFinal,
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final airesResponse = airesResponseFromJson(resp.body);
      return airesResponse;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return AiresResponse.withError("$error");
    }
  }

  Future<Air> getAir(String roomId) async {
    final urlFinal =
        Uri.https('${Environment.apiUrl}', '/api/plant/plant/$roomId');

    final token = await this._storage.read(key: 'token');

    try {
      final resp = await http.get(urlFinal,
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final airResponse = airResponseFromJson(resp.body);
      return airResponse.air;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return new Air(id: '0');
    }
  }

  Future<List<Air>> getAiresRoom(String roomId) async {
    final urlFinal =
        Uri.https('${Environment.apiUrl}', '/api/air/airs/room/$roomId');

    final token = await this._storage.read(key: 'token');

    try {
      final resp = await http.get(urlFinal,
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final airesResponse = airesResponseFromJson(resp.body);
      return airesResponse.airs;
    } catch (e) {
      return [];
    }
  }

  Future deleteAir(String airId) async {
    final token = await this._storage.read(key: 'token');

    final urlFinal =
        Uri.https('${Environment.apiUrl}', '/api/air/delete/$airId');

    try {
      await http.delete(urlFinal,
          headers: {'Content-Type': 'application/json', 'x-token': token});

      return true;
    } catch (e) {
      return false;
    }
  }
}
