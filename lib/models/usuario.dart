// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

User usuarioFromJson(String str) => User.fromJson(json.decode(str));

String usuarioToJson(User data) => json.encode(data.toJson());

class User {
  User({this.online, this.name, this.email, this.uid, this.image});

  bool online;
  String name;
  String email;
  String uid;
  String image;

  factory User.fromJson(Map<String, dynamic> json) => User(
      online: json["online"],
      name: json["name"],
      email: json["email"],
      uid: json["uid"],
      image: json["image"]);

  Map<String, dynamic> toJson() => {
        "online": online,
        "name": name,
        "email": email,
        "uid": uid,
        "image": image
      };

  getPosterImg() {
    if (image == "") {
      return "";
    } else {
      return image;
    }
  }
}
