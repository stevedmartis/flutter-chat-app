// To parse this JSON data, do
//
//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat/models/plant.dart';

PlantResponse plantResponseFromJson(String str) =>
    PlantResponse.fromJson(json.decode(str));

String plantResponseToJson(PlantResponse data) => json.encode(data.toJson());

class PlantResponse {
  PlantResponse({this.ok, this.plant});

  bool ok;
  Plant plant;

  factory PlantResponse.fromJson(Map<String, dynamic> json) =>
      PlantResponse(ok: json["ok"], plant: Plant.fromJson(json["plant"]));

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "plant": plant.toJson(),
      };

  PlantResponse.withError(String errorValue);
}
