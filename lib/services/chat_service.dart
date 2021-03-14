import 'package:chat/models/mensajes_response.dart';
import 'package:chat/models/profiles.dart';
import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:chat/global/environment.dart';

class ChatService with ChangeNotifier {
  Profiles userFor;

  Future<List<Message>> getChat(String userID) async {
    final urlFinal =
        Uri.https('${Environment.apiUrl}', '/api/messages/$userID');

    final resp = await http.get(urlFinal, headers: {
      'Content-Type': 'application/json',
      'x-token': await AuthService.getToken()
    });

    final messageResponse = messageResponseFromJson(resp.body);

    return messageResponse.messages;
  }
}
