import 'package:chat/models/products.dart';
import 'package:chat/models/products_response.dart';
import 'package:chat/providers/products_provider.dart';

class ProductsRepository {
  ProductsApiProvider _apiProvider = ProductsApiProvider();

  Future<ProductsResponse> getProducts() {
    return _apiProvider.getProducts();
  }

  Future<Product> getProduct(String productId) {
    return _apiProvider.getProduct(productId);
  }
}
