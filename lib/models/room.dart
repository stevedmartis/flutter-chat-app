// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

Room roomFromJson(String str) => Room.fromJson(json.decode(str));

String roomToJson(Room data) => json.encode(data.toJson());

class Room with ChangeNotifier {
  bool _isRoute = false;

  bool get isRoute => this._isRoute;

  set isRoute(bool value) {
    this._isRoute = value;
    // notifyListeners();
  }

  List<Room> _rooms = [];

  List<Room> get rooms => this._rooms;

  set rooms(List<Room> rooms) {
    this._rooms = rooms;
    notifyListeners();
  }

  Room(
      {this.id,
      this.user,
      this.name,
      this.description,
      this.totalItems,
      this.createdAt,
      this.updatedAt,
      isRoute});

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
