import 'package:chat/models/catalogos_response.dart';
import 'package:chat/models/room.dart';
import 'package:chat/providers/catalogos_provider.dart';

class CatalogosRepository {
  CatalogosApiProvider _apiProvider = CatalogosApiProvider();

  Future<CatalogosResponse> getCtalogos(String userId) {
    return _apiProvider.getCatalogos(userId);
  }

  Future<Room> getRoom(String roomId) {
    return _apiProvider.getRoom(roomId);
  }
}
