// To parse this JSON data, do
//
//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat/models/room.dart';

RoomsResponse roomsResponseFromJson(String str) =>
    RoomsResponse.fromJson(json.decode(str));

String roomsResponseToJson(RoomsResponse data) => json.encode(data.toJson());

class RoomsResponse {
  RoomsResponse({this.ok, this.rooms});

  bool ok;
  List<Room> rooms;

  factory RoomsResponse.fromJson(Map<String, dynamic> json) => RoomsResponse(
        ok: json["ok"],
        rooms: List<Room>.from(json["rooms"].map((x) => Room.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "rooms": List<dynamic>.from(rooms.map((x) => x.toJson())),
      };

  RoomsResponse.withError(String errorValue);
}
