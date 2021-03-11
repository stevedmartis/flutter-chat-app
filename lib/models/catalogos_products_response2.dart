// To parse this JSON data, do
//
//     final catalogoProducts = catalogoProductsFromJson(jsonString);

import 'dart:convert';

import 'package:chat/models/products.dart';

CatalogoProducts catalogoProductsFromJson(String str) =>
    CatalogoProducts.fromJson(json.decode(str));

String catalogoProductsToJson(CatalogoProducts data) =>
    json.encode(data.toJson());

class CatalogoProducts {
  CatalogoProducts({
    this.id,
    this.name,
    this.description,
    this.user,
    this.position,
    this.privacity,
    this.createdAt,
    this.updatedAt,
    this.products,
  });

  String id;
  String name;
  String description;
  String user;
  int position;
  String privacity;
  String createdAt;
  String updatedAt;
  List<Product> products;

  factory CatalogoProducts.fromJson(Map<String, dynamic> json) =>
      CatalogoProducts(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        user: json["user"],
        position: json["position"],
        privacity: json["privacity"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "user": user,
        "position": position,
        "privacity": privacity,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}
