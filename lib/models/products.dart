// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  Product({
    this.userId,
    this.name,
    this.description,
    this.dateCreate,
    //this.products,
    this.dateUpdate,
    this.totalProducts,
    //this.products
  });

  bool userId;
  String name;
  String description;
  // List<Product> products;
  String dateCreate;
  String dateUpdate;
  int totalProducts;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
      userId: json["userId"],
      name: json["name"],
      description: json["description"],
      //products: List<Room>.from(json["products"].map((x) => x)),
      dateCreate: json["dateCreate"],
      dateUpdate: json["dateUpdate"],
      totalProducts: json["totalProducts"]);

  Map<String, dynamic> toJson() => {
        "userId": userId,
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
