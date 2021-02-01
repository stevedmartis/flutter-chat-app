import 'package:chat/global/environment.dart';
import 'package:chat/models/air.dart';
import 'package:chat/models/aires_response.dart';
import 'package:chat/models/plant.dart';
import 'package:chat/models/plant_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AiresApiProvider {
  final String _endpoint = '${Environment.apiUrl}/air/aires/room/';

  final _storage = new FlutterSecureStorage();

  Future<List<Air>> getAiresRoom(String roomId) async {
    final urlFinal = _endpoint + '$roomId';

    final token = await this._storage.read(key: 'token');

    try {
      final resp = await http.get(urlFinal,
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final airesResponse = airesResponseFromJson(resp.body);
      return airesResponse.aires;
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
}
