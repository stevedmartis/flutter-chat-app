// To parse this JSON data, do
//
//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat/models/profile.dart';
import 'package:chat/models/room.dart';

ProfileResponse profileResponseFromJson(String str) =>
    ProfileResponse.fromJson(json.decode(str));

String profileResponseToJson(ProfileResponse data) =>
    json.encode(data.toJson());

class ProfileResponse {
  ProfileResponse({this.ok, this.rooms, this.profile});

  bool ok;
  List<Room> rooms;
  Profile profile;

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      ProfileResponse(
        ok: json["ok"],
        profile: Profile.fromJson(json["profile"]),
        rooms: List<Room>.from(json["rooms"].map((x) => Room.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "profile": profile.toJson(),
        "rooms": List<dynamic>.from(rooms.map((x) => x.toJson())),
      };
}
