// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

import 'package:chat/models/room.dart';

Profile profileFromJson(String str) => Profile.fromJson(json.decode(str));

String profileToJson(Profile data) => json.encode(data.toJson());

class Profile {
  Profile({
    this.userId,
    this.name,
    this.lastName,
    this.createdAt,
    //  this.rooms,
    this.updatedAt,
    this.avatar,
  });

  String userId;
  String name;
  String lastName;
  //List<Room> rooms;
  DateTime createdAt;
  DateTime updatedAt;
  String avatar;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
      userId: json["userId"],
      name: json["name"],
      lastName: json["lastName"],
      //rooms: List<Room>.from(json["rooms"].map((x) => x)),
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      avatar: json["avatar"]);

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "name": name,
        "lastName": lastName,
        "dateCreate": createdAt,
        "dateUpdate": updatedAt,
        "avatar": avatar,
        //   "rooms": List<dynamic>.from(rooms.map((x) => x)),
      };

  getPosterImg() {
    if (avatar == "") {
      return "";
    } else {
      return avatar;
    }
  }
}
