import 'package:chat/models/products_response.dart';
import 'package:chat/providers/products_provider.dart';

class ProductsRepository {
  ProductsApiProvider _apiProvider = ProductsApiProvider();

  Future<ProductsResponse> getProducts(String userId) {
    return _apiProvider.getProducts(userId);
  }
}
