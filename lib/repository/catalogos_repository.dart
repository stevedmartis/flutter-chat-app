import 'package:chat/models/catalogo.dart';
import 'package:chat/models/catalogos_products_response.dart';
import 'package:chat/models/catalogos_response.dart';
import 'package:chat/providers/catalogos_provider.dart';

class CatalogosRepository {
  CatalogosApiProvider _apiProvider = CatalogosApiProvider();

  Future<CatalogosProductsResponse> getCatalogosProductsUser(
      String userId, String userAuthId) {
    return _apiProvider.getCatalogosProductsUser(userId, userAuthId);
  }

  Future<CatalogosResponse> getMyCatalogos(String userId) {
    return _apiProvider.getMyCatalogos(userId);
  }

  Future<CatalogosProductsResponse> getMyCatalogosProducts(String userId) {
    return _apiProvider.getMyCatalogosProducts(userId);
  }

  Future<Catalogo> getCatalogo(String catalogoId) {
    return _apiProvider.getCatalogo(catalogoId);
  }
}
