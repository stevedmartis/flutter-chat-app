// To parse this JSON data, do
//
//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat/models/light.dart';

LightResponse lightResponseFromJson(String str) =>
    LightResponse.fromJson(json.decode(str));

String lightResponseToJson(LightResponse data) => json.encode(data.toJson());

class LightResponse {
  LightResponse({this.ok, this.light});

  bool ok;
  Light light;

  factory LightResponse.fromJson(Map<String, dynamic> json) =>
      LightResponse(ok: json["ok"], light: Light.fromJson(json["light"]));

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "light": light.toJson(),
      };

  LightResponse.withError(String errorValue);
}
