import 'package:chat/global/environment.dart';
import 'package:chat/models/catalogo.dart';
import 'package:chat/models/catalogo_response.dart';
import 'package:chat/models/catalogos_response.dart';
import 'package:chat/models/room.dart';
import 'package:chat/models/room_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class CatalogosApiProvider {
  final String _endpoint = '${Environment.apiUrl}/catalogo/catalogos/user/';

  final _storage = new FlutterSecureStorage();

  Future<CatalogosResponse> getCatalogos(
      String userId, String userAuthId) async {
    final urlFinal = _endpoint + '$userId' + '/userAuth/$userAuthId';

    final token = await this._storage.read(key: 'token');

    try {
      final resp = await http.get(urlFinal,
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final catalogosResponse = catalogosResponseFromJson(resp.body);
      return catalogosResponse;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return CatalogosResponse.withError("$error");
    }
  }

  Future<CatalogosResponse> getMyCatalogos(String userId) async {
    final urlFinal = _endpoint + '$userId';

    final token = await this._storage.read(key: 'token');

    try {
      final resp = await http.get(urlFinal,
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final catalogosResponse = catalogosResponseFromJson(resp.body);
      return catalogosResponse;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return CatalogosResponse.withError("$error");
    }
  }

  final String _endpointRoom = '${Environment.apiUrl}/catalogo/catalogo/';

  Future<Catalogo> getCatalogo(String catalogoId) async {
    final urlFinal = _endpointRoom + '$catalogoId';

    final token = await this._storage.read(key: 'token');

    try {
      final resp = await http.get(urlFinal,
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final catalogoResponse = catalogoResponseFromJson(resp.body);
      return catalogoResponse.catalogo;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return new Catalogo(id: '0');
    }
  }
}
