import 'package:chat/models/plant.dart';
import 'package:chat/models/plants_response.dart';
import 'package:chat/providers/plants_provider.dart';

class PlantsRepository {
  PlantsApiProvider _apiProvider = PlantsApiProvider();

  Future<PlantsResponse> getPlants(String roomId) {
    return _apiProvider.getPlants(roomId);
  }

  Future<PlantsResponse> getPlantsUser(String uid) {
    return _apiProvider.getLastPlantsByUser(uid);
  }

  Future<Plant> getPlant(String plantId) {
    return _apiProvider.getPlant(plantId);
  }
}
