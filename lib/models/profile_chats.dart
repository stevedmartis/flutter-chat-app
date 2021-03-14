// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

import 'package:chat/models/usuario.dart';

ProfilesChat profileschatFromJson(String str) =>
    ProfilesChat.fromJson(json.decode(str));

String profileschatToJson(ProfilesChat data) => json.encode(data.toJson());

class ProfilesChat {
  ProfilesChat(
      {this.id,
      this.name,
      this.lastName,
      this.createdAt,
      this.updatedAt,
      this.imageHeader,
      this.imageAvatar,
      this.user,
      this.message = "",
      this.messageDate,
      this.about = ""});

  String id;
  String name;
  String lastName;
  DateTime createdAt;
  DateTime updatedAt;
  String imageHeader;
  String about;
  String imageAvatar;
  User user;
  String message;
  DateTime messageDate;
  factory ProfilesChat.fromJson(Map<String, dynamic> json) => ProfilesChat(
        id: json["id"],
        name: json["name"],
        lastName: json["lastName"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        imageAvatar: json["imageAvatar"],
        about: json["about"],
        message: json["message"],
        messageDate: DateTime.parse(json["messageDate"]),
        imageHeader: json["imageHeader"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "lastName": lastName,
        "dateCreate": createdAt,
        "dateUpdate": updatedAt,
        "messageDate": messageDate,
        "about": about,
        "message": message,
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
