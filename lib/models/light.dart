import 'dart:convert';

Light lightFromJson(String str) => Light.fromJson(json.decode(str));

String lightToJson(Light data) => json.encode(data.toJson());

class Light {
  Light(
      {this.id,
      this.user,
      this.name = "",
      this.description = "",
      this.createdAt,
      this.updatedAt,
      this.room,
      isRoute,
      this.watts,
      this.kelvin,
      init()});

  String id;
  String name;
  String description;
  String user;
  String room;
  String watts;
  String kelvin;

  DateTime createdAt;
  DateTime updatedAt;

  factory Light.fromJson(Map<String, dynamic> json) => new Light(
        id: json["id"],
        user: json['user'],
        room: json['room'],
        name: json["name"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        description: json["description"],
        watts: json["watts"],
        kelvin: json["kelvin"],

        //images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "room": room,
        "name": name,
        "description": description,
        "watts": watts,
        "kelvin": kelvin
      };
}
