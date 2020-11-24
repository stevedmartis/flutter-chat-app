import 'package:chat/models/mensajes_response.dart';
import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:chat/global/environment.dart';
import 'package:chat/models/usuario.dart';

class ChatService with ChangeNotifier {
  User userFor;

  Future<List<Message>> getChat(String userID) async {
    final resp = await http.get('${Environment.apiUrl}/messages/$userID',
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken()
        });

    final messageResponse = messageResponseFromJson(resp.body);

    return messageResponse.messages;
  }
}
