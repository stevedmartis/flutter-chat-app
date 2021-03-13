// To parse this JSON data, do
//
//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat/models/subscribe.dart';

NotificationsResponse notificationsResponseFromJson(String str) =>
    NotificationsResponse.fromJson(json.decode(str));

String notificationsResponseToJson(NotificationsResponse data) =>
    json.encode(data.toJson());

class NotificationsResponse {
  NotificationsResponse({this.ok, this.subscriptionsNotifi});

  bool ok;
  List<Subscription> subscriptionsNotifi;

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) =>
      NotificationsResponse(
        ok: json["ok"],
        subscriptionsNotifi: List<Subscription>.from(
            json["subscriptionsNotifi"].map((x) => Subscription.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "subscriptionsNotifi":
            List<dynamic>.from(subscriptionsNotifi.map((x) => x.toJson())),
      };

  NotificationsResponse.withError(String errorValue);
}
