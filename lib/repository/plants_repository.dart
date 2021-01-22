import 'package:chat/models/plant_response.dart';
import 'package:chat/providers/plants_provider.dart';

class PlantsRepository {
  PlantsApiProvider _apiProvider = PlantsApiProvider();

  Future<PlantsResponse> getPlants(String roomId) {
    return _apiProvider.getPlants(roomId);
  }
}
