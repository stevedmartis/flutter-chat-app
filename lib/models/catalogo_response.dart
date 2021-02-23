// To parse this JSON data, do
//
//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';

import 'catalogo.dart';

CatalogoResponse catalogoResponseFromJson(String str) =>
    CatalogoResponse.fromJson(json.decode(str));

String airResponseToJson(CatalogoResponse data) => json.encode(data.toJson());

class CatalogoResponse {
  CatalogoResponse({this.ok, this.catalogo});

  bool ok;
  Catalogo catalogo;

  factory CatalogoResponse.fromJson(Map<String, dynamic> json) =>
      CatalogoResponse(
          ok: json["ok"], catalogo: Catalogo.fromJson(json["catalogo"]));

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "catalogo": catalogo.toJson(),
      };

  CatalogoResponse.withError(String errorValue);
}
