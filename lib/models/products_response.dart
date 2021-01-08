// To parse this JSON data, do
//
//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat/models/products.dart';

ProductsResponse productsResponseFromJson(String str) =>
    ProductsResponse.fromJson(json.decode(str));

String productsResponseToJson(ProductsResponse data) =>
    json.encode(data.toJson());

class ProductsResponse {
  ProductsResponse({this.ok, this.products});

  bool ok;
  List<Product> products;

  factory ProductsResponse.fromJson(Map<String, dynamic> json) =>
      ProductsResponse(
        ok: json["ok"],
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };

  ProductsResponse.withError(String errorValue);
}
