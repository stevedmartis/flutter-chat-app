// To parse this JSON data, do
//
//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';

ImageResponse imageResponseFromJson(String str) =>
    ImageResponse.fromJson(json.decode(str));

String imageResponseToJson(ImageResponse data) => json.encode(data.toJson());

class ImageResponse {
  ImageResponse({this.ok, this.image});

  bool ok;
  String image;

  factory ImageResponse.fromJson(Map<String, dynamic> json) => ImageResponse(
        ok: json["ok"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "image": image,
      };

  ImageResponse.withError(String errorValue);
}
