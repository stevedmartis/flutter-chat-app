// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

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
    this.imageAvatar,
  });

  String userId;
  String name;
  String lastName;
  //List<Room> rooms;
  DateTime createdAt;
  DateTime updatedAt;
  String avatar;
  String imageAvatar;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
      userId: json["userId"],
      name: json["name"],
      lastName: json["lastName"],
      //rooms: List<Room>.from(json["rooms"].map((x) => x)),
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      imageAvatar: json["imageAvatar"]);

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "name": name,
        "lastName": lastName,
        "dateCreate": createdAt,
        "dateUpdate": updatedAt,
        "imageAvatar:": imageAvatar,
        //   "rooms": List<dynamic>.from(rooms.map((x) => x)),
      };

  getPosterImg() {
    if (imageAvatar == "") {
      return "";
    } else {
      return imageAvatar;
    }
  }
}
