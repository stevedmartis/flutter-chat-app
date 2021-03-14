import 'package:chat/models/notirications_response.dart';
import 'package:chat/models/profiles.dart';
import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:chat/global/environment.dart';

class NotificationService with ChangeNotifier {
  Profiles userFor;

  Future<NotificationsResponse> getNotificationByUser(String userID) async {
    final urlFinal = Uri.https('${Environment.apiUrl}',
        '/api/notification/notifications/user/$userID');

    final resp = await http.get(urlFinal, headers: {
      'Content-Type': 'application/json',
      'x-token': await AuthService.getToken()
    });

    final messageResponse = notificationsResponseFromJson(resp.body);

    return messageResponse;
  }
}
