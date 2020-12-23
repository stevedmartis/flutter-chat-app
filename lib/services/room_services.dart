import 'package:chat/models/room.dart';
import 'package:chat/models/rooms_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:chat/global/environment.dart';
import 'package:flutter/material.dart';

class RoomService with ChangeNotifier {
  List<Room> rooms = [];

  final _storage = new FlutterSecureStorage();

  Future<List<Room>> getRoomsUser() async {
    final token = await this._storage.read(key: 'token');

    try {
      final resp = await http.get('${Environment.apiUrl}/room/rooms/user',
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final roomsResponse = roomsResponseFromJson(resp.body);

      final List<Room> rooms = new List();

      roomsResponse.rooms.forEach((item) {
        print(item);

        rooms.add(item);
      });

      return rooms;
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
}
