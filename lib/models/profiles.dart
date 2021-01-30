// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

import 'package:chat/models/usuario.dart';

Profiles profilesFromJson(String str) => Profiles.fromJson(json.decode(str));

String profilesToJson(Profiles data) => json.encode(data.toJson());

class Profiles {
  Profiles(
      {this.id,
      this.name,
      this.lastName,
      this.createdAt,
      this.updatedAt,
      this.imageHeader,
      this.imageAvatar,
      this.user,
      this.about});

  String id;
  String name;
  String lastName;
  DateTime createdAt;
  DateTime updatedAt;
  String imageHeader;
  String about;
  String imageAvatar;
  User user;

  factory Profiles.fromJson(Map<String, dynamic> json) => Profiles(
        id: json["id"],
        name: json["name"],
        lastName: json["lastName"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        imageAvatar: json["imageAvatar"],
        about: json["about"],
        imageHeader: json["imageHeader"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "lastName": lastName,
        "dateCreate": createdAt,
        "dateUpdate": updatedAt,
        "about": about,
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
      var imageDefault =
          "https://images-cdn-br.s3-sa-east-1.amazonaws.com/default_banner.jpeg";

      return imageDefault;
    } else {
      return imageHeader;
    }
  }
}
