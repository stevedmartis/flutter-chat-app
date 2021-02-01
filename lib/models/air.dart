import 'dart:convert';

Air airFromJson(String str) => Air.fromJson(json.decode(str));

String airToJson(Air data) => json.encode(data.toJson());

class Air {
  Air(
      {this.id,
      this.user,
      this.name = "",
      this.description = "",
      this.createdAt,
      this.updatedAt,
      this.room,
      isRoute,
      this.watts,
      init()});

  String id;
  String name;
  String description;
  String user;
  String room;
  String watts;

  DateTime createdAt;
  DateTime updatedAt;

  factory Air.fromJson(Map<String, dynamic> json) => new Air(
        id: json["id"],
        user: json['user'],
        room: json['room'],
        name: json["name"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        description: json["description"],
        watts: json["watts"],

        //images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "room": room,
        "name": name,
        "description": description,
        "watts": watts
      };
}
