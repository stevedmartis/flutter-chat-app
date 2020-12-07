// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

import 'package:chat/models/products.dart';

Room roomFromJson(String str) => Room.fromJson(json.decode(str));

String roomToJson(Room data) => json.encode(data.toJson());

class Room {
  Room({
    this.userId,
    this.name,
    this.description,
    this.dateCreate,
    this.products,
    this.dateUpdate,
    this.totalProducts,
  });

  bool userId;
  String name;
  String description;
  List<Product> products;
  String dateCreate;
  String dateUpdate;
  int totalProducts;

  factory Room.fromJson(Map<String, dynamic> json) => Room(
      userId: json["userId"],
      name: json["name"],
      description: json["description"],
      products: List<Product>.from(json["products"].map((x) => x)),
      dateCreate: json["dateCreate"],
      dateUpdate: json["dateUpdate"],
      totalProducts: json["totalProducts"]);

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "name": name,
        "description": description,
        "dateCreate": dateCreate,
        "dateUpdate": dateUpdate,
        "totalProducts": totalProducts,
        "products": List<dynamic>.from(products.map((x) => x)),
      };

/*   getPosterImg() {
    if (avatar == "") {
      return "";
    } else {
      return avatar;
    }
  } */
}
