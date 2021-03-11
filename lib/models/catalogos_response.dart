// To parse this JSON data, do
//
//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat/models/catalogo.dart';
import 'package:chat/models/products.dart';

CatalogosResponse catalogosResponseFromJson(String str) =>
    CatalogosResponse.fromJson(json.decode(str));

String roomsResponseToJson(CatalogosResponse data) =>
    json.encode(data.toJson());

class CatalogosResponse {
  CatalogosResponse({this.ok, this.catalogos, this.products});

  bool ok;
  List<Catalogo> catalogos;

  List<Product> products;

  factory CatalogosResponse.fromJson(Map<String, dynamic> json) =>
      CatalogosResponse(
        ok: json["ok"],
        catalogos: List<Catalogo>.from(
            json["catalogos"].map((x) => Catalogo.fromJson(x))),
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "catalogos": List<dynamic>.from(catalogos.map((x) => x.toJson())),
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };

  CatalogosResponse.withError(String errorValue);
}
