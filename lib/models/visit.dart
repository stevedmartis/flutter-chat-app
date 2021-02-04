import 'dart:convert';

Visit plantFromJson(String str) => Visit.fromJson(json.decode(str));

String plantToJson(Visit data) => json.encode(data.toJson());

class Visit {
  Visit(
      {this.id,
      this.plant,
      this.user,
      this.description = "",
      this.createdAt,
      this.updatedAt,
      this.coverImage = "",
      this.clean,
      this.temperature,
      this.cut,
      this.electro,
      this.ph,
      this.ml,
      this.degrees,
      this.water,
      isRoute,
      init()});

  String id;
  String description;

  String user;
  String plant;
  String coverImage;

  bool clean;
  bool cut;
  bool temperature;
  String degrees;
  bool water;

  String electro;
  String ph;
  String ml;

  DateTime createdAt;
  DateTime updatedAt;

  factory Visit.fromJson(Map<String, dynamic> json) => new Visit(
      id: json["id"],
      user: json['user'],
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      description: json["description"],
      coverImage: json["coverImage"],
      clean: json["clean"],
      temperature: json["temperature"],
      cut: json["cut"],
      water: json["water"],
      degrees: json["degrees"],
      electro: json["electro"],
      ph: json["ph"],
      ml: json["ml"]

      //images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,

        "plant": plant,
        "coverImage": coverImage,

        "clean": clean,
        "temperature": temperature,
        "cut": cut,
        "water": water,
        "degrees": degrees,
        "electro": electro,
        "ph": ph,
        "ml": ml,
        "description": description,

        // "images": List<Image>.from(images.map((x) => x)),
      };

  getCoverImg() {
    if (coverImage == "") {
      var imageDefault =
          "http://images-cdn-br.s3-sa-east-1.amazonaws.com/default_banner.jpeg";
      return imageDefault;
    } else {
      return coverImage;
    }
  }
}
