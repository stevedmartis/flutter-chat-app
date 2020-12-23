// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

import 'package:chat/models/usuario.dart';

Profiles profilesFromJson(String str) => Profiles.fromJson(json.decode(str));

String profilesToJson(Profiles data) => json.encode(data.toJson());

class Profiles {
  Profiles({
    this.id,
    this.name,
    this.lastName,
    this.createdAt,
    this.updatedAt,
    this.imageHeader,
    this.imageAvatar,
    this.user,
  });

  String id;
  String name;
  String lastName;
  DateTime createdAt;
  DateTime updatedAt;
  String imageHeader;
  String imageAvatar;
  User user;

  factory Profiles.fromJson(Map<String, dynamic> json) => Profiles(
        id: json["id"],
        name: json["name"],
        lastName: json["lastName"],
        //rooms: List<Room>.from(json["rooms"].map((x) => x)),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        imageAvatar: json["imageAvatar"],
        imageHeader: json["imageHeader"],

        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "lastName": lastName,
        "dateCreate": createdAt,
        "dateUpdate": updatedAt,
        "imageAvatar:": imageAvatar,
        "imageHeader": imageHeader,
        "user": user.toJson(),
      };

  getAvatarImg() {
    if (imageAvatar == "") {
      return null;
    } else {
      return imageAvatar;
    }
  }

  getHeaderImg() {
    if (imageHeader == "") {
      return null;
    } else {
      return imageHeader;
    }
  }
}
