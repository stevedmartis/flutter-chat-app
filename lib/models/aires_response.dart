// To parse this JSON data, do
//
//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat/models/air.dart';

AiresResponse airesResponseFromJson(String str) =>
    AiresResponse.fromJson(json.decode(str));

String airesResponseToJson(AiresResponse data) => json.encode(data.toJson());

class AiresResponse {
  AiresResponse({this.ok, this.aires});

  bool ok;
  List<Air> aires;

  factory AiresResponse.fromJson(Map<String, dynamic> json) => AiresResponse(
        ok: json["ok"],
        aires: List<Air>.from(json["plants"].map((x) => Air.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "aires": List<dynamic>.from(aires.map((x) => x.toJson())),
      };

  AiresResponse.withError(String errorValue);
}
