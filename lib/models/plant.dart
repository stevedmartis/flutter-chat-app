import 'dart:convert';

Plant plantFromJson(String str) => Plant.fromJson(json.decode(str));

String plantToJson(Plant data) => json.encode(data.toJson());

class Plant {
  Plant(
      {this.id,
      this.user,
      this.name = "",
      this.description = "",
      this.quantity = "",
      this.sexo = "0",
      this.genotype = "",
      this.germinated = "",
      this.flowering = "",
      this.pot = "",
      this.room,
      this.cbd = "",
      this.thc = "",
      this.createdAt,
      this.updatedAt,
      isRoute,
      init()});

  String id;
  String name;
  String description;
  String quantity;

  String sexo;
  String genotype;
  String cbd;
  String thc;
  String user;
  String room;
  String germinated;
  String flowering;
  String pot;

  DateTime createdAt;
  DateTime updatedAt;

  factory Plant.fromJson(Map<String, dynamic> json) => new Plant(
        id: json["id"],
        user: json['user'],
        room: json['room'],
        name: json["name"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        description: json["description"],
        quantity: json["quantity"],
        sexo: json["sexo"],
        genotype: json["genotype"],
        germinated: json["germinated"],
        flowering: json["flowering"],
        pot: json["pot"],
        cbd: json["cbd"],
        thc: json["thc"],
        //images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "room": room,
        "name": name,
        "description": description,
        "quantity": quantity,
        "sexo": sexo,
        "genotype": genotype,
        "germinated": germinated,
        "flowering": flowering,
        "pot": pot,
        "cbd": cbd,
        "thc": thc,
        // "images": List<Image>.from(images.map((x) => x)),
      };
}
