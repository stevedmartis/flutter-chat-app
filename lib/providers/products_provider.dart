import 'package:chat/global/environment.dart';
import 'package:chat/models/products_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ProductsApiProvider {
  final String _endpoint = '${Environment.apiUrl}/product/products/user/';

  final _storage = new FlutterSecureStorage();

  Future<ProductsResponse> getProducts(String userId) async {
    final urlFinal = _endpoint + '$userId';

    final token = await this._storage.read(key: 'token');

    try {
      final resp = await http.get(urlFinal,
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final productsResponse = productsResponseFromJson(resp.body);
      return productsResponse;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return ProductsResponse.withError("$error");
    }
  }
}
