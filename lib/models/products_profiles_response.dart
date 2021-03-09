// To parse this JSON data, do
//
//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat/models/product_principal.dart';

ProductsProfilesResponse productsProfilesResponseFromJson(String str) =>
    ProductsProfilesResponse.fromJson(json.decode(str));

String productsResponseToJson(ProductsProfilesResponse data) =>
    json.encode(data.toJson());

class ProductsProfilesResponse {
  ProductsProfilesResponse({this.ok, this.productsProfiles});

  bool ok;
  List<ProductProfile> productsProfiles;

  factory ProductsProfilesResponse.fromJson(Map<String, dynamic> json) =>
      ProductsProfilesResponse(
        ok: json["ok"],
        productsProfiles: List<ProductProfile>.from(
            json["productsProfiles"].map((x) => ProductProfile.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "productsProfiles":
            List<dynamic>.from(productsProfiles.map((x) => x.toJson())),
      };

  ProductsProfilesResponse.withError(String errorValue);
}
