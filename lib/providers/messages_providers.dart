import 'package:chat/global/environment.dart';
import 'package:chat/models/profiles_response.dart';
import 'package:chat/services/auth_service.dart';
import 'package:http/http.dart' as http;

import 'dart:async';

class MessagesProvider {
  Future<ProfilesResponse> getProfilesChatByUser(String userId) async {
    try {
      final resp = await http.get(
        '${Environment.apiUrl}/messages/profiles/$userId',
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
