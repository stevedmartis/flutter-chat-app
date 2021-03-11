// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  Product({
    this.id,
    this.user,
    this.name = "",
    this.description = "",
    this.createdAt,
    //this.products,
    this.updatedAt,
    this.price = 0,
    this.coverImage = "",
    this.catalogo,
    this.ratingInit,
    this.cbd = "",
    this.thc = "",
    //this.products
  });
  String id;
  String user;
  String name;
  String description;
  // List<Product> products;
  String createdAt;
  String updatedAt;
  String catalogo;
  String ratingInit;
  int price;

  String cbd;
  String thc;

  String coverImage;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
      id: json["id"],
      user: json["user"],
      name: json["name"],
      description: json["description"],
      //products: List<Room>.from(json["products"].map((x) => x)),
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
      coverImage: json["coverImage"],
      catalogo: json["catalogo"],
      ratingInit: json["ratingInit"],
      cbd: json["cbd"],
      thc: json["thc"],
      price: json["price"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "name": name,
        "description": description,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "coverImage": coverImage,
        "catalogo": catalogo,
        "ratingInit": ratingInit,
        "cbd": cbd,
        "thc": thc,
        "price": price

        // "products": List<dynamic>.from(products.map((x) => x)),
      };

  getCoverImg() {
    if (coverImage == "") {
      var imageDefault =
          "http://images-cdn-br.s3-sa-east-1.amazonaws.com/default_banner.jpeg";
      return imageDefault;
    } else {
      return coverImage;
    }
  }
}
