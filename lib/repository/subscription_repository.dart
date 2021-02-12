import 'package:chat/models/subscribe.dart';

import 'package:chat/providers/subscription_provider.dart';

class SubscriptionRepository {
  SubscriptionApiProvider _apiProvider = SubscriptionApiProvider();

  Future<Subscription> getSubscription(String subId, String clubId) {
    return _apiProvider.getSubscription(subId, clubId);
  }
}
