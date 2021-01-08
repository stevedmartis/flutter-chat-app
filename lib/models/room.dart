// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

import 'package:chat/services/auth_service.dart';
import 'package:chat/services/room_services.dart';
import 'package:flutter/material.dart';

Room roomFromJson(String str) => Room.fromJson(json.decode(str));

String roomToJson(Room data) => json.encode(data.toJson());

class Room with ChangeNotifier {
  final roomService = RoomService();
  final authService = AuthService();

  bool _isRoute = false;

  bool get isRoute => this._isRoute;

  set isRoute(bool value) {
    this._isRoute = value;
    // notifyListeners();
  }

  List<Room> _rooms = [];

  List<Room> get rooms => this._rooms;

/*   set rooms(List<Room> rooms) {
    this._rooms = rooms;
    notifyListeners();
  } */

  init() async {
    // initial sample data here.
    await getRooms();
  }

  Future getRooms() async {
    _rooms = await roomService.getRoomsUser(authService.profile.user.uid);
    notifyListeners();
  }

  Room(
      {this.id,
      this.user,
      this.name,
      this.description,
      this.position,
      this.totalItems,
      this.createdAt,
      this.updatedAt,
      isRoute,
      init()});

  String user;
  String id;
  String name;
  int position;
  String description;

  int totalItems;
  DateTime createdAt;
  DateTime updatedAt;

  factory Room.fromJson(Map<String, dynamic> json) => new Room(
      id: json["id"],
      user: json["user"],
      name: json["name"],
      position: json['position'],
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      description: json["description"],
      //products: List<Product>.from(json["products"].map((x) => x)),
      totalItems: json["totalItems"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "name": name,
        "position": position,
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
