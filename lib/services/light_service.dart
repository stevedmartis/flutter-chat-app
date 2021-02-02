import 'package:chat/models/light.dart';
import 'package:chat/models/light_response.dart';
import 'package:chat/models/message_error.dart';

import 'package:chat/models/room.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:chat/global/environment.dart';
import 'package:flutter/material.dart';

class LightService with ChangeNotifier {
  Light _light;
  Light get light => this._light;

  set light(Light valor) {
    this._light = valor;
    notifyListeners();
  }

  final _storage = new FlutterSecureStorage();

  Future createLight(Light light) async {
    // this.authenticated = true;

    final token = await this._storage.read(key: 'token');

    final resp = await http.post('${Environment.apiUrl}/light/new',
        body: jsonEncode(light),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      // final roomResponse = roomsResponseFromJson(resp.body);
      final lightResponse = lightResponseFromJson(resp.body);
      // this.rooms = roomResponse.rooms;

      return lightResponse;
    } else {
      final respBody = errorMessageResponseFromJson(resp.body);

      return respBody;
    }
  }

  Future editLight(Light light) async {
    // this.authenticated = true;

    final token = await this._storage.read(key: 'token');

    final resp = await http.post('${Environment.apiUrl}/light/update/light',
        body: jsonEncode(light),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      // final roomResponse = roomsResponseFromJson(resp.body);
      final lightResponse = lightResponseFromJson(resp.body);
      // this.rooms = roomResponse.rooms;

      return lightResponse;
    } else {
      final respBody = errorMessageResponseFromJson(resp.body);

      return respBody;
    }
  }

  Future deletePlant(String plantId) async {
    final token = await this._storage.read(key: 'token');

    try {
      await http.delete('${Environment.apiUrl}/room/delete/$plantId',
          headers: {'Content-Type': 'application/json', 'x-token': token});

      return true;
    } catch (e) {
      return false;
    }
  }

  Future updatePositionRoom(
      List<Room> rooms, int position, String userId) async {
    // this.authenticated = true;

    final token = await this._storage.read(key: 'token');

    //final data = {'name': name, 'email': description, 'uid': uid};
    final data = {'rooms': rooms, 'userId': userId};

    final resp = await http.post('${Environment.apiUrl}/room/update/position',
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
