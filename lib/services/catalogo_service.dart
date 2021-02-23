import 'package:chat/models/catalogo.dart';
import 'package:chat/models/catalogo_response.dart';
import 'package:chat/models/message_error.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:chat/global/environment.dart';
import 'package:flutter/material.dart';

class CatalogoService with ChangeNotifier {
  Catalogo _air;
  Catalogo get air => this._air;

  set air(Catalogo valor) {
    this._air = valor;
    notifyListeners();
  }

  final _storage = new FlutterSecureStorage();

  Future createCatalogo(Catalogo air) async {
    // this.authenticated = true;

    final token = await this._storage.read(key: 'token');

    final resp = await http.post('${Environment.apiUrl}/catalogo/new',
        body: jsonEncode(air),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      // final roomResponse = roomsResponseFromJson(resp.body);
      final catalogoResponse = catalogoResponseFromJson(resp.body);
      // this.rooms = roomResponse.rooms;

      return catalogoResponse;
    } else {
      final respBody = errorMessageResponseFromJson(resp.body);

      return respBody;
    }
  }

  Future editCatalogo(Catalogo plant) async {
    // this.authenticated = true;

    final token = await this._storage.read(key: 'token');

    final resp = await http.post(
        '${Environment.apiUrl}/catalogo/update/catalogo',
        body: jsonEncode(plant),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      // final roomResponse = roomsResponseFromJson(resp.body);
      final catalogoResponse = catalogoResponseFromJson(resp.body);
      // this.rooms = roomResponse.rooms;

      return catalogoResponse;
    } else {
      final respBody = errorMessageResponseFromJson(resp.body);

      return respBody;
    }
  }

  Future deleteCatalogo(String catalogoId) async {
    final token = await this._storage.read(key: 'token');

    try {
      await http.delete('${Environment.apiUrl}/catalogo/delete/$catalogoId',
          headers: {'Content-Type': 'application/json', 'x-token': token});

      return true;
    } catch (e) {
      return false;
    }
  }

  Future updatePositionCatalogo(
      List<Catalogo> catalogos, int position, String userId) async {
    // this.authenticated = true;

    final token = await this._storage.read(key: 'token');

    //final data = {'name': name, 'email': description, 'uid': uid};
    final data = {'catalogos': catalogos, 'userId': userId};

    final resp = await http.post(
        '${Environment.apiUrl}/catalogo/update/position',
        body: json.encode(data),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      // final roomResponse = roomsResponseFromJson(resp.body);

      // this.rooms = roomResponse.rooms;

      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }
}
