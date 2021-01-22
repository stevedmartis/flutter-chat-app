// To parse this JSON data, do
//
//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat/models/plant.dart';

PlantsResponse plantsResponseFromJson(String str) =>
    PlantsResponse.fromJson(json.decode(str));

String plantsResponseToJson(PlantsResponse data) => json.encode(data.toJson());

class PlantsResponse {
  PlantsResponse({this.ok, this.plants});

  bool ok;
  List<Plant> plants;

  factory PlantsResponse.fromJson(Map<String, dynamic> json) => PlantsResponse(
        ok: json["ok"],
        plants: List<Plant>.from(json["plants"].map((x) => Plant.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "plants": List<dynamic>.from(plants.map((x) => x.toJson())),
      };

  PlantsResponse.withError(String errorValue);
}
