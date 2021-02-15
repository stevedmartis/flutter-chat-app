import 'package:chat/models/profiles_response.dart';
import 'package:chat/models/subscribe.dart';

import 'package:chat/providers/subscription_provider.dart';

class SubscriptionRepository {
  SubscriptionApiProvider _apiProvider = SubscriptionApiProvider();

  Future<Subscription> getSubscription(String subId, String clubId) {
    return _apiProvider.getSubscription(subId, clubId);
  }

  Future<ProfilesResponse> getProfilesSubsciptionsPending(String userId) {
    return _apiProvider.getProfilesSubscriptionsByUser(userId);
  }

  Future<ProfilesResponse> getProfilesSubsciptionsApprove(String userId) {
    return _apiProvider.getProfilesSubsciptionsApproveBySubId(userId);
  }
}
