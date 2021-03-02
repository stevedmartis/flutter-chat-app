import 'package:chat/models/product_response.dart';
import 'package:chat/models/products.dart';
import 'package:chat/models/products_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:chat/global/environment.dart';
import 'package:flutter/material.dart';

class ProductService with ChangeNotifier {
  Product productModel;

  Product _product;
  Product get product => this._product;

  set product(Product valor) {
    this._product = valor;
    notifyListeners();
  }

  final _storage = new FlutterSecureStorage();

  Future<List<Product>> geProductByRoom(String roomId) async {
    final token = await this._storage.read(key: 'token');

    try {
      final resp = await http.get(
          '${Environment.apiUrl}/product/products/room/$roomId',
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final productsResponse = productsResponseFromJson(resp.body);

      // roomModel.rooms = rooms;
      //roomModel.rooms;
      // this.rooms = rooms;

      //  print('$roomModel.rooms');

      return productsResponse.products;
    } catch (e) {
      return [];
    }
  }

  Future createProduct(Product product) async {
    // this.authenticated = true;

    final token = await this._storage.read(key: 'token');

    //final data = {'name': name, 'email': description, 'uid': uid};

    final resp = await http.post('${Environment.apiUrl}/product/new',
        body: productToJson(product),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      final productResponse = productResponseFromJson(resp.body);

      // this.rooms = roomResponse.rooms;

      return productResponse;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future editProduct(Product product) async {
    // this.authenticated = true;

    final token = await this._storage.read(key: 'token');

    //final data = {'name': name, 'email': description, 'uid': uid};

    final resp = await http.post('${Environment.apiUrl}/product/new',
        body: productToJson(product),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      final productResponse = productResponseFromJson(resp.body);

      // this.rooms = roomResponse.rooms;

      return productResponse;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future deleteRoom(String roomId) async {
    final token = await this._storage.read(key: 'token');

    try {
      await http.delete('${Environment.apiUrl}/room/delete/$roomId',
          headers: {'Content-Type': 'application/json', 'x-token': token});

      return true;
    } catch (e) {
      return false;
    }
  }
}
