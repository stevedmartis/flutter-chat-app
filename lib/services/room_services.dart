import 'package:chat/models/message_error.dart';
import 'package:chat/models/room.dart';
import 'package:chat/models/room_response.dart';
import 'package:chat/models/rooms_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:chat/global/environment.dart';
import 'package:flutter/material.dart';

class RoomService with ChangeNotifier {
  Room roomModel;

  final _storage = new FlutterSecureStorage();

  Future<List<Room>> getRoomsUser(String userId) async {
    final token = await this._storage.read(key: 'token');

    final urlFinal =
        Uri.https('${Environment.apiUrl}', '/api/room/rooms/user/$userId');

    try {
      final resp = await http.get(urlFinal,
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final roomsResponse = roomsResponseFromJson(resp.body);

      // roomModel.rooms = rooms;
      //roomModel.rooms;
      // this.rooms = rooms;

      //  print('$roomModel.rooms');

      return roomsResponse.rooms;
    } catch (e) {
      return [];
    }
  }

  Future createRoom(Room room) async {
    // this.authenticated = true;

    final token = await this._storage.read(key: 'token');
    final urlFinal = Uri.https('${Environment.apiUrl}', '/api/room/new');

    final resp = await http.post(urlFinal,
        body: jsonEncode(room),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      // final roomResponse = roomsResponseFromJson(resp.body);
      final roomResponse = roomResponseFromJson(resp.body);
      // this.rooms = roomResponse.rooms;

      return roomResponse;
    } else {
      final respBody = errorMessageResponseFromJson(resp.body);

      return respBody;
    }
  }

  Future editRoom(Room room) async {
    // this.authenticated = true;

    final token = await this._storage.read(key: 'token');
    final urlFinal =
        Uri.https('${Environment.apiUrl}', '/api/room/update/room');

    final resp = await http.post(urlFinal,
        body: jsonEncode(room),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      // final roomResponse = roomsResponseFromJson(resp.body);
      final roomResponse = roomResponseFromJson(resp.body);
      // this.rooms = roomResponse.rooms;

      return roomResponse;
    } else {
      final respBody = errorMessageResponseFromJson(resp.body);

      return respBody;
    }
  }

  Future deleteRoom(String roomId) async {
    final token = await this._storage.read(key: 'token');
    final urlFinal =
        Uri.https('${Environment.apiUrl}', '/api/room/delete/$roomId');

    try {
      await http.delete(urlFinal,
          headers: {'Content-Type': 'application/json', 'x-token': token});

      return true;
    } catch (e) {
      return false;
    }
  }

  Future updatePositionRoom(
      List<Room> rooms, int position, String userId) async {
    // this.authenticated = true;
    final urlFinal =
        Uri.https('${Environment.apiUrl}', '/api/room/update/position');

    final token = await this._storage.read(key: 'token');

    //final data = {'name': name, 'email': description, 'uid': uid};
    final data = {'rooms': rooms, 'userId': userId};

    final resp = await http.post(urlFinal,
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
