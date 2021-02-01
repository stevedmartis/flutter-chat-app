import 'package:chat/models/air.dart';
import 'package:chat/models/air_response.dart';
import 'package:chat/models/aires_response.dart';

import 'package:chat/providers/air_provider.dart';

class AirRepository {
  AiresApiProvider _apiProvider = AiresApiProvider();

  Future<AiresResponse> getAires(String roomId) {
    return _apiProvider.getAires(roomId);
  }

  Future<Air> getAir(String roomId) {
    return _apiProvider.getAir(roomId);
  }
}
