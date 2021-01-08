// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

import 'package:chat/models/usuario.dart';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  Product({
    this.id,
    this.user,
    this.name,
    this.description,
    this.dateCreate,
    //this.products,
    this.dateUpdate,
    this.totalProducts,
    //this.products
  });
  String id;
  User user;
  String name;
  String description;
  // List<Product> products;
  String dateCreate;
  String dateUpdate;
  int totalProducts;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
      id: json["id"],
      user: json["user"],
      name: json["name"],
      description: json["description"],
      //products: List<Room>.from(json["products"].map((x) => x)),
      dateCreate: json["dateCreate"],
      dateUpdate: json["dateUpdate"],
      totalProducts: json["totalProducts"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "name": name,
        "description": description,
        "dateCreate": dateCreate,
        "dateUpdate": dateUpdate,
        "totalProducts": totalProducts,
        // "products": List<dynamic>.from(products.map((x) => x)),
      };

/*   getPosterImg() {
    if (avatar == "") {
      return "";
    } else {
      return avatar;
    }
  } */
}
