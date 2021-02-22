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
      isRoute,
      init()});

  String id;
  String name;
  String description;
  String user;

  DateTime createdAt;
  DateTime updatedAt;

  factory Catalogo.fromJson(Map<String, dynamic> json) => new Catalogo(
        id: json["id"],
        user: json['user'],

        name: json["name"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        description: json["description"],

        //images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "name": name,
        "description": description,
      };
}
