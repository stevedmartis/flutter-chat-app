import 'package:chat/models/message_error.dart';

import 'package:chat/models/subscribe.dart';
import 'package:chat/models/subscription_response.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:chat/global/environment.dart';
import 'package:flutter/material.dart';

class SubscriptionService with ChangeNotifier {
  final _storage = new FlutterSecureStorage();

  Future createSubscription(Subscription subscription) async {
    // this.authenticated = true;

    final token = await this._storage.read(key: 'token');

    final urlFinal =
        Uri.https('${Environment.apiUrl}', '/api/subscription/new');

    final resp = await http.post(urlFinal,
        body: jsonEncode(subscription),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      // final roomResponse = roomsResponseFromJson(resp.body);
      final subscriptionResponse = subscriptionResponseFromJson(resp.body);
      // this.rooms = roomResponse.rooms;

      return subscriptionResponse;
    } else {
      final respBody = errorMessageResponseFromJson(resp.body);

      return respBody;
    }
  }

  Future unSubscription(Subscription subscription) async {
    // this.authenticated = true;

    final token = await this._storage.read(key: 'token');
    final urlFinal =
        Uri.https('${Environment.apiUrl}', '/api/subscription/unsubscribe');

    final resp = await http.post(urlFinal,
        body: jsonEncode(subscription),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      // final roomResponse = roomsResponseFromJson(resp.body);
      final subscriptionResponse = subscriptionResponseFromJson(resp.body);
      // this.rooms = roomResponse.rooms;

      return subscriptionResponse;
    } else {
      final respBody = errorMessageResponseFromJson(resp.body);

      return respBody;
    }
  }
}
