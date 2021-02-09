// To parse this JSON data, do
//
//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat/models/visit.dart';

VisitResponse visitResponseFromJson(String str) =>
    VisitResponse.fromJson(json.decode(str));

String visitResponseToJson(VisitResponse data) => json.encode(data.toJson());

class VisitResponse {
  VisitResponse({this.ok, this.visit});

  bool ok;
  Visit visit;

  factory VisitResponse.fromJson(Map<String, dynamic> json) =>
      VisitResponse(ok: json["ok"], visit: Visit.fromJson(json["visit"]));

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "visit": visit.toJson(),
      };

  VisitResponse.withError(String errorValue);
}
