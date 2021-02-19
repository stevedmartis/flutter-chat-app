import 'package:chat/models/visits_response.dart';

import 'package:chat/providers/visit_provider.dart';

class VisitRepository {
  VisitApiProvider _apiProvider = VisitApiProvider();

  Future<VisitsResponse> getVisits(String userId) {
    return _apiProvider.getLastVisitsByUser(userId);
  }
}
