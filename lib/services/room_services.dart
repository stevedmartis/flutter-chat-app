import 'package:chat/models/room.dart';
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

    print(userId);
    try {
      final resp = await http.get(
          '${Environment.apiUrl}/room/rooms/user/$userId',
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

    //final data = {'name': name, 'email': description, 'uid': uid};

    final resp = await http.post('${Environment.apiUrl}/room/new',
        body: roomToJson(room),
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

  Future deleteRoom(String roomId) async {
    final token = await this._storage.read(key: 'token');

    try {
      final resp = await http.delete(
          '${Environment.apiUrl}/room/delete/$roomId',
          headers: {'Content-Type': 'application/json', 'x-token': token});

      print(resp);

      return true;
    } catch (e) {
      return false;
    }
  }
}
