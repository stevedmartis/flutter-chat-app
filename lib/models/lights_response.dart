// To parse this JSON data, do
//
//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat/models/light.dart';

LightsResponse lightsResponseFromJson(String str) =>
    LightsResponse.fromJson(json.decode(str));

String lightsResponseToJson(LightsResponse data) => json.encode(data.toJson());

class LightsResponse {
  LightsResponse({this.ok, this.lights});

  bool ok;
  List<Light> lights;

  factory LightsResponse.fromJson(Map<String, dynamic> json) => LightsResponse(
        ok: json["ok"],
        lights: List<Light>.from(json["lights"].map((x) => Light.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "lights": List<dynamic>.from(lights.map((x) => x.toJson())),
      };

  LightsResponse.withError(String errorValue);
}
