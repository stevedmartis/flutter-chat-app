import 'dart:convert';

import 'package:chat/models/plant.dart';
import 'package:chat/models/room.dart';
import 'package:chat/models/usuario.dart';

Image imageFromJson(String str) => Image.fromJson(json.decode(str));

String imageToJson(Image data) => json.encode(data.toJson());

class Image {
  Image(
      {this.id,
      this.user,
      this.url = "",
      this.createdAt,
      this.updatedAt,
      this.room,
      init()});

  String id;
  String url;
  User user;
  Room room;
  Plant plant;
  DateTime createdAt;
  DateTime updatedAt;

  factory Image.fromJson(Map<String, dynamic> json) => new Image(
      id: json["id"],
      user: json["user"],
      url: json["url"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
      room: json["room"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "url": url,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "room": room
      };
}
