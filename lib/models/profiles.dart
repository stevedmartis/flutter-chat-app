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
    // "https://onlyvectorbackgrounds.com/wp-content/uploads/2018/09/3d-Title-Space-Banner-Background-Red.jpg
//      "https://png.pngtree.com/thumb_back/fh260/background/20190223/ourmid/pngtree-minimalistic-coral-red-banner-background-template-redsimplebanner-backgroundgeneral-backgroundgeometricbox-image_86813.jpg";

    if (imageHeader == "") {
      return "https://wallpapercave.com/wp/wp2869931.jpg";
    } else {
      return imageHeader;
    }
  }
}
