import 'package:chat/bloc/validators.dart';
import 'package:chat/models/subscribe.dart';
import 'package:chat/repository/subscription_repository.dart';

import 'package:rxdart/rxdart.dart';

class SubscribeBloc with Validators {
  final BehaviorSubject<Subscription> _subscriptionCtrl =
      BehaviorSubject<Subscription>();

  final SubscriptionRepository _repository = SubscriptionRepository();

  getSubscription(subscriptorId, clubid) async {
    Subscription response =
        await _repository.getSubscription(subscriptorId, clubid);
    _subscriptionCtrl.sink.add(response);
  }

  BehaviorSubject<Subscription> get subscription => _subscriptionCtrl;

  Function(Subscription) get changeSubscription => _subscriptionCtrl.sink.add;

  // Obtener el último valor ingresado a los streams
  Subscription get recipeUpload => _subscriptionCtrl.value;

  dispose() {
    _subscriptionCtrl?.close();
  }
}

final subscriptionBloc = SubscribeBloc();
