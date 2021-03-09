//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat/models/products.dart';
import 'package:chat/models/profiles.dart';

ProductProfile profilesResponseFromJson(String str) =>
    ProductProfile.fromJson(json.decode(str));

String profileResponseToJson(ProductProfile data) => json.encode(data.toJson());

class ProductProfile {
  ProductProfile({this.ok, this.product, this.profile});

  bool ok;
  Profiles profile;
  Product product;

  factory ProductProfile.fromJson(Map<String, dynamic> json) => ProductProfile(
        product: Product.fromJson(json["product"]),
        profile: Profiles.fromJson(json["profile"]),
      );

  Map<String, dynamic> toJson() => {
        "product": product.toJson(),
        "profile": profile.toJson(),
      };

  ProductProfile.withError(String errorValue);
}
