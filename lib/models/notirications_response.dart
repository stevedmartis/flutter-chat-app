// To parse this JSON data, do
//
//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat/models/mensajes_response.dart';
import 'package:chat/models/subscribe.dart';

NotificationsResponse notificationsResponseFromJson(String str) =>
    NotificationsResponse.fromJson(json.decode(str));

String notificationsResponseToJson(NotificationsResponse data) =>
    json.encode(data.toJson());

class NotificationsResponse {
  NotificationsResponse(
      {this.ok, this.subscriptionsNotifi, this.messagesNotifi});

  bool ok;
  List<Subscription> subscriptionsNotifi;
  List<Message> messagesNotifi;

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) =>
      NotificationsResponse(
        ok: json["ok"],
        subscriptionsNotifi: List<Subscription>.from(
            json["subscriptionsNotifi"].map((x) => Subscription.fromJson(x))),
        messagesNotifi: List<Message>.from(
            json["messagesNotifi"].map((x) => Message.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "subscriptionsNotifi":
            List<dynamic>.from(subscriptionsNotifi.map((x) => x.toJson())),
        "messagesNotifi":
            List<dynamic>.from(messagesNotifi.map((x) => x.toJson())),
      };

  NotificationsResponse.withError(String errorValue);
}
