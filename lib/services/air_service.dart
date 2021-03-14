import 'package:chat/models/air.dart';
import 'package:chat/models/air_response.dart';
import 'package:chat/models/message_error.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:chat/global/environment.dart';
import 'package:flutter/material.dart';

class AirService with ChangeNotifier {
  Air _air;
  Air get air => this._air;

  set air(Air valor) {
    this._air = valor;
    notifyListeners();
  }

  final _storage = new FlutterSecureStorage();

  Future createAir(Air air) async {
    // this.authenticated = true;

    final urlFinal = Uri.https('${Environment.apiUrl}', '/api/air/new');

    final token = await this._storage.read(key: 'token');

    final resp = await http.post(urlFinal,
        body: jsonEncode(air),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      // final roomResponse = roomsResponseFromJson(resp.body);
      final airResponse = airResponseFromJson(resp.body);
      // this.rooms = roomResponse.rooms;

      return airResponse;
    } else {
      final respBody = errorMessageResponseFromJson(resp.body);

      return respBody;
    }
  }

  Future editAir(Air plant) async {
    // this.authenticated = true;

    final token = await this._storage.read(key: 'token');

    final urlFinal = Uri.https('${Environment.apiUrl}', '/api/air/update/air');

    final resp = await http.post(urlFinal,
        body: jsonEncode(plant),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      // final roomResponse = roomsResponseFromJson(resp.body);
      final airResponse = airResponseFromJson(resp.body);
      // this.rooms = roomResponse.rooms;

      return airResponse;
    } else {
      final respBody = errorMessageResponseFromJson(resp.body);

      return respBody;
    }
  }
}
