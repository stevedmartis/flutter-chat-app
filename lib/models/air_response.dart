// To parse this JSON data, do
//
//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat/models/air.dart';

AirResponse airResponseFromJson(String str) =>
    AirResponse.fromJson(json.decode(str));

String airResponseToJson(AirResponse data) => json.encode(data.toJson());

class AirResponse {
  AirResponse({this.ok, this.air});

  bool ok;
  Air air;

  factory AirResponse.fromJson(Map<String, dynamic> json) =>
      AirResponse(ok: json["ok"], air: Air.fromJson(json["air"]));

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "air": air.toJson(),
      };

  AirResponse.withError(String errorValue);
}
