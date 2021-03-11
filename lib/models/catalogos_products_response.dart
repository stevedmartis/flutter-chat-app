// To parse this JSON data, do
//
//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat/models/catalogos_products_response2.dart';

CatalogosProductsResponse catalogosProductsResponseFromJson(String str) =>
    CatalogosProductsResponse.fromJson(json.decode(str));

String catalogosProductsResponseToJson(CatalogosProductsResponse data) =>
    json.encode(data.toJson());

class CatalogosProductsResponse {
  CatalogosProductsResponse({
    this.ok,
    this.catalogosProducts,
  });

  bool ok;

  List<CatalogoProducts> catalogosProducts;

  factory CatalogosProductsResponse.fromJson(Map<String, dynamic> json) =>
      CatalogosProductsResponse(
        ok: json["ok"],
        catalogosProducts: List<CatalogoProducts>.from(
            json["catalogosProducts"].map((x) => CatalogoProducts.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "catalogosProducts":
            List<dynamic>.from(catalogosProducts.map((x) => x.toJson())),
      };

  CatalogosProductsResponse.withError(String errorValue);
}
