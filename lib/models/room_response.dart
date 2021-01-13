// To parse this JSON data, do
//
//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat/models/room.dart';

RoomResponse roomResponseFromJson(String str) =>
    RoomResponse.fromJson(json.decode(str));

String roomResponseToJson(RoomResponse data) => json.encode(data.toJson());

class RoomResponse {
  RoomResponse({this.ok, this.room});

  bool ok;
  Room room;

  factory RoomResponse.fromJson(Map<String, dynamic> json) =>
      RoomResponse(ok: json["ok"], room: Room.fromJson(json["room"]));

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "room": room.toJson(),
      };

  RoomResponse.withError(String errorValue);
}
