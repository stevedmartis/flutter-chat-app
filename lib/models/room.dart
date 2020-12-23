// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

Room roomFromJson(String str) => Room.fromJson(json.decode(str));

String roomToJson(Room data) => json.encode(data.toJson());

class Room {
  Room(
      {this.id,
      this.user,
      this.name,
      this.description,
      this.totalItems,
      this.createdAt,
      this.updatedAt});

  String user;
  String id;
  String name;
  String description;

  int totalItems;
  DateTime createdAt;
  DateTime updatedAt;

  factory Room.fromJson(Map<String, dynamic> json) => new Room(
      id: json["id"],
      user: json["user"],
      name: json["name"],
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      description: json["description"],
      //products: List<Product>.from(json["products"].map((x) => x)),
      totalItems: json["totalItems"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "name": name,
        "description": description,
        "totalItems": totalItems,
        //"products": List<dynamic>.from(products.map((x) => x)),
      };

/*   getPosterImg() {
    if (avatar == "") {
      return "";
    } else {
      return avatar;
    }
  } */
}
