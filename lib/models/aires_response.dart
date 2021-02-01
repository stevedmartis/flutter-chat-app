// To parse this JSON data, do
//
//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat/models/air.dart';

AiresResponse airesResponseFromJson(String str) =>
    AiresResponse.fromJson(json.decode(str));

String airesResponseToJson(AiresResponse data) => json.encode(data.toJson());

class AiresResponse {
  AiresResponse({this.ok, this.airs});

  bool ok;
  List<Air> airs;

  factory AiresResponse.fromJson(Map<String, dynamic> json) => AiresResponse(
        ok: json["ok"],
        airs: List<Air>.from(json["airs"].map((x) => Air.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "airs": List<dynamic>.from(airs.map((x) => x.toJson())),
      };

  AiresResponse.withError(String errorValue);
}
