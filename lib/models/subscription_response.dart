// To parse this JSON data, do
//
//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat/models/subscribe.dart';

SubscriptionResponse subscriptionResponseFromJson(String str) =>
    SubscriptionResponse.fromJson(json.decode(str));

String subscriptionResponseToJson(SubscriptionResponse data) =>
    json.encode(data.toJson());

class SubscriptionResponse {
  SubscriptionResponse({this.ok, this.subscription});

  bool ok;
  Subscription subscription;

  factory SubscriptionResponse.fromJson(Map<String, dynamic> json) =>
      SubscriptionResponse(
          ok: json["ok"],
          subscription: Subscription.fromJson(json["subscription"]));

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "subscription": subscription.toJson(),
      };

  SubscriptionResponse.withError(String errorValue);
}
