import 'package:chat/global/environment.dart';
import 'package:chat/models/product_response.dart';
import 'package:chat/models/products.dart';
import 'package:chat/models/products_profiles_response.dart';
import 'package:chat/models/products_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ProductsApiProvider {
  final String _endpoint = '${Environment.apiUrl}/product/';

  final _storage = new FlutterSecureStorage();

  Future<ProductsProfilesResponse> getProductsProfiles(String uid) async {
    final urlFinal = _endpoint + 'principal/products/$uid';

    final token = await this._storage.read(key: 'token');

    try {
      final resp = await http.get(urlFinal,
          headers: {'Content-Type': 'application/json', 'x-token': token});

      print(resp);
      final productsResponse = productsProfilesResponseFromJson(resp.body);
      return productsResponse;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return ProductsProfilesResponse.withError("$error");
    }
  }

  Future<List<Product>> getProductCatalogo(String catalogoId) async {
    final urlFinal = _endpoint + 'products/catalogo/$catalogoId';

    final token = await this._storage.read(key: 'token');

    try {
      final resp = await http.get(urlFinal,
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final plantsResponse = productsResponseFromJson(resp.body);
      return plantsResponse.products;
    } catch (e) {
      return [];
    }
  }

  final String _endpointProduct = '${Environment.apiUrl}/product/product/';

  Future<Product> getProduct(String productId) async {
    final urlFinal = _endpointProduct + '$productId';

    final token = await this._storage.read(key: 'token');

    try {
      final resp = await http.get(urlFinal,
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final plantResponse = productResponseFromJson(resp.body);
      return plantResponse.product;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return new Product(id: '0');
    }
  }
}
