//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat/models/catalogo.dart';
import 'package:chat/models/products.dart';

CatalogoProducts catalogoProductsFromJson(String str) =>
    CatalogoProducts.fromJson(json.decode(str));

String catalogoProductsToJson(CatalogoProducts data) =>
    json.encode(data.toJson());

class CatalogoProducts {
  CatalogoProducts({this.ok, this.products, this.catalogo});

  bool ok;
  List<Product> products;
  Catalogo catalogo;

  factory CatalogoProducts.fromJson(Map<String, dynamic> json) =>
      CatalogoProducts(
        catalogo: Catalogo.fromJson(json["catalogo"]),
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "catalogo": catalogo.toJson(),
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };

  CatalogoProducts.withError(String errorValue);
}
