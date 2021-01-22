import 'dart:convert';

import 'package:chat/models/image.dart';
import 'package:chat/models/room.dart';
import 'package:chat/models/usuario.dart';

Plant plantFromJson(String str) => Plant.fromJson(json.decode(str));

String plantToJson(Plant data) => json.encode(data.toJson());

class Plant {
  Plant(
      {this.id,
      this.user,
      this.name = "",
      this.description = "",
      this.quantity,
      this.sexo,
      this.genoType,
      this.germinated,
      this.flowering,
      this.pot,
      this.images,
      this.room,
      this.cbd,
      this.thc,
      init()});

  String id;
  String name;
  String description;
  int quantity;

  String sexo;
  String genoType;
  int cbd;
  int thc;
  User user;
  Room room;
  DateTime germinated;
  DateTime flowering;
  int pot;
  List<Image> images;
  DateTime createdAt;
  DateTime updatedAt;

  factory Plant.fromJson(Map<String, dynamic> json) => new Plant(
        id: json["id"],
        user: User.fromJson(json["user"]),
        room: Room.fromJson(json["user"]),
        name: json["name"],
        description: json["description"],
        quantity: json["quantity"],
        sexo: json["sexo"],
        genoType: json["genoType"],
        germinated: json["germinated"],
        flowering: json["flowering"],
        pot: json["pot"],
        cbd: json["cbd"],
        thc: json["thc"],
        images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user.toJson(),
        "room": room.toJson(),
        "name": name,
        "description": description,
        "quantity": quantity,
        "sexo": "sexo",
        "genoType": "genoType",
        "germinated": "germinated",
        "flowering": "flowering",
        "pot": "port",
        "cbd": "cbd",
        "thc": "thc",
        "images": List<Image>.from(images.map((x) => x)),
      };
}
