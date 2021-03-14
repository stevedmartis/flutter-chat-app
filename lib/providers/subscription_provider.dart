import 'dart:convert';

import 'package:chat/global/environment.dart';

import 'package:chat/models/message_error.dart';
import 'package:chat/models/profiles_response.dart';
import 'package:chat/models/subscribe.dart';
import 'package:chat/models/subscription_response.dart';
import 'package:chat/services/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class SubscriptionApiProvider {
  final _storage = new FlutterSecureStorage();

  Future<Subscription> getSubscription(String userAuth, String userId) async {
    final urlFinal = Uri.https('${Environment.apiUrl}',
        '/api/subscription/subscription/$userAuth/$userId');

    final token = await this._storage.read(key: 'token');

    try {
      final resp = await http.get(urlFinal,
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final subscriptionResponse = subscriptionResponseFromJson(resp.body);

      return subscriptionResponse.subscription;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return new Subscription(id: '0');
    }
  }

  Future disapproveSubscription(String subId) async {
    // this.authenticated = true;

    final token = await this._storage.read(key: 'token');
    final data = {'id': subId};

    final urlFinal =
        Uri.https('${Environment.apiUrl}', '/api/subscription/disapprove');

    final resp = await http.post(urlFinal,
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      // final roomResponse = roomsResponseFromJson(resp.body);
      final subscriptionResponse = subscriptionResponseFromJson(resp.body);
      // this.rooms = roomResponse.rooms;

      return subscriptionResponse.ok;
    } else {
      final respBody = errorMessageResponseFromJson(resp.body);

      return respBody;
    }
  }

  Future approveSubscription(String subId) async {
    // this.authenticated = true;

    final token = await this._storage.read(key: 'token');
    final data = {'id': subId};
    final urlFinal =
        Uri.https('${Environment.apiUrl}', '/api/subscription/approve');

    final resp = await http.post(urlFinal,
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      // final roomResponse = roomsResponseFromJson(resp.body);
      final subscriptionResponse = subscriptionResponseFromJson(resp.body);
      // this.rooms = roomResponse.rooms;

      return subscriptionResponse.ok;
    } else {
      final respBody = errorMessageResponseFromJson(resp.body);

      return respBody;
    }
  }

  Future<ProfilesResponse> getProfilesSubscriptionsByUser(String userId) async {
    try {
      final urlFinal = Uri.https('${Environment.apiUrl}',
          '/api/notification/profiles/subscriptions/pending/$userId');

      final resp = await http.get(
        urlFinal,
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken(),
        },
      );

      final profilesResponse = profilesResponseFromJson(resp.body);

      return profilesResponse;
    } catch (error) {
      return ProfilesResponse.withError("$error");
    }
  }

  Future<ProfilesResponse> getProfilesSubsciptionsApprove(String subId) async {
    try {
      final urlFinal = Uri.https('${Environment.apiUrl}',
          '/api/notification/profiles/subscriptions/approve/user/$subId');

      final resp = await http.get(
        urlFinal,
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken(),
        },
      );

      final profilesResponse = profilesResponseFromJson(resp.body);

      return profilesResponse;
    } catch (error) {
      return ProfilesResponse.withError("$error");
    }
  }

  Future<ProfilesResponse> getProfilesSubsciptionsApproveNotifi(
      String subId) async {
    try {
      final urlFinal = Uri.https('${Environment.apiUrl}',
          '/api/notification/profiles/subscriptions/notifi/user/$subId');

      final resp = await http.get(
        urlFinal,
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken(),
        },
      );

      final profilesResponse = profilesResponseFromJson(resp.body);

      return profilesResponse;
    } catch (error) {
      return ProfilesResponse.withError("$error");
    }
  }
}
