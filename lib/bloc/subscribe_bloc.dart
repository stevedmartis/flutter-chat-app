import 'package:chat/bloc/validators.dart';
import 'package:chat/models/profiles_response.dart';
import 'package:chat/models/subscribe.dart';
import 'package:chat/repository/subscription_repository.dart';

import 'package:rxdart/rxdart.dart';

class SubscribeBloc with Validators {
  final BehaviorSubject<Subscription> _subscriptionCtrl =
      BehaviorSubject<Subscription>();

  final BehaviorSubject<ProfilesResponse> _subscriptionsPending =
      BehaviorSubject<ProfilesResponse>();

  final BehaviorSubject<ProfilesResponse> _subscriptionsApprove =
      BehaviorSubject<ProfilesResponse>();

  final BehaviorSubject<ProfilesResponse> _subscriptionsApproveNotifi =
      BehaviorSubject<ProfilesResponse>();

  final BehaviorSubject<ProfilesResponse> _subscriptionsApproveBySubId =
      BehaviorSubject<ProfilesResponse>();
  final SubscriptionRepository _repository = SubscriptionRepository();

  getSubscription(userAuth, userId) async {
    Subscription response = await _repository.getSubscription(userAuth, userId);
    _subscriptionCtrl.sink.add(response);
  }

  getSubscriptionsPending(String userId) async {
    ProfilesResponse response =
        await _repository.getProfilesSubsciptionsPending(userId);

    _subscriptionsPending.sink.add(response);
  }

  getSubscriptionsClubsApprove(String subId) async {
    ProfilesResponse response =
        await _repository.getProfilesSubsciptionsApprove(subId);

    _subscriptionsApproveBySubId.sink.add(response);
  }

  getSubscriptionsNotifi(String subId) async {
    ProfilesResponse response =
        await _repository.getProfilesSubsciptionsApproveNotifi(subId);

    _subscriptionsApproveNotifi.sink.add(response);
  }

  getSubscriptionsApprove(String subId) async {
    ProfilesResponse response =
        await _repository.getProfilesSubsciptionsApprove(subId);

    _subscriptionsApprove.sink.add(response);
  }

  BehaviorSubject<Subscription> get subscription => _subscriptionCtrl;

  Function(Subscription) get changeSubscription => _subscriptionCtrl.sink.add;

  // Obtener el último valor ingresado a los streams
  Subscription get recipeUpload => _subscriptionCtrl.value;

  BehaviorSubject<ProfilesResponse> get subscriptionsPending =>
      _subscriptionsPending;

  BehaviorSubject<ProfilesResponse> get subscriptionsApproveBySubId =>
      _subscriptionsApproveBySubId;

  BehaviorSubject<ProfilesResponse> get subscriptionsApprove =>
      _subscriptionsApprove;

  BehaviorSubject<ProfilesResponse> get subscriptionsApproveNotifi =>
      _subscriptionsApproveNotifi;

  dispose() {
    _subscriptionsApproveNotifi?.close();
    _subscriptionsPending?.close();
    _subscriptionsApproveBySubId?.close();
    _subscriptionCtrl?.close();
    _subscriptionsApprove?.close();
  }
}

final subscriptionBloc = SubscribeBloc();
