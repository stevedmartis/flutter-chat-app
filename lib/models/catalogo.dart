import 'dart:convert';

Catalogo catalogoFromJson(String str) => Catalogo.fromJson(json.decode(str));

String catalogoToJson(Catalogo data) => json.encode(data.toJson());

class Catalogo {
  Catalogo(
      {this.id,
      this.user,
      this.name = "",
      this.description = "",
      this.createdAt,
      this.updatedAt,
      this.position,
      this.privacity,
      isRoute,
      init()});

  String id;
  String name;
  String description;
  String user;
  int position;
  String privacity;

  DateTime createdAt;
  DateTime updatedAt;

  factory Catalogo.fromJson(Map<String, dynamic> json) => new Catalogo(
      id: json["id"],
      user: json['user'],
      position: json['position'],
      name: json["name"],
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      description: json["description"],
      privacity: json["privacity"]

      //images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "position": position,
        "user": user,
        "name": name,
        "description": description,
        "privacity": privacity
      };
}
