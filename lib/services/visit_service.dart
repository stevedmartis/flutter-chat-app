import 'package:chat/models/message_error.dart';

import 'package:chat/models/visit.dart';
import 'package:chat/models/visit_response.dart';
import 'package:chat/models/visits_response.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:chat/global/environment.dart';
import 'package:flutter/material.dart';

class VisitService with ChangeNotifier {
  Visit _visit;
  Visit get visit => this._visit;

  set visit(Visit valor) {
    this._visit = valor;
    notifyListeners();
  }

  final _storage = new FlutterSecureStorage();

  Future createVisit(Visit visit) async {
    // this.authenticated = true;

    final token = await this._storage.read(key: 'token');

    final urlFinal = Uri.https('${Environment.apiUrl}', 'api/visit/new');

    final resp = await http.post(urlFinal,
        body: jsonEncode(visit),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      // final roomResponse = roomsResponseFromJson(resp.body);
      final visitResponse = visitResponseFromJson(resp.body);
      // this.rooms = roomResponse.rooms;

      return visitResponse;
    } else {
      final respBody = errorMessageResponseFromJson(resp.body);

      return respBody;
    }
  }

  Future editVisit(Visit visit) async {
    // this.authenticated = true;

    final token = await this._storage.read(key: 'token');

    final urlFinal =
        Uri.https('${Environment.apiUrl}', 'api/visit/update/visit');

    final resp = await http.post(urlFinal,
        body: jsonEncode(visit),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      // final roomResponse = roomsResponseFromJson(resp.body);
      final visitResponse = visitResponseFromJson(resp.body);
      // this.rooms = roomResponse.rooms;
      return visitResponse;
    } else {
      final respBody = errorMessageResponseFromJson(resp.body);

      return respBody;
    }
  }

  Future deleteVisit(String visitId) async {
    final token = await this._storage.read(key: 'token');

    final urlFinal =
        Uri.https('${Environment.apiUrl}', 'api/visit/delete/$visitId');

    try {
      await http.delete(urlFinal,
          headers: {'Content-Type': 'application/json', 'x-token': token});

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Visit>> getLastVisitsByUser(String userId) async {
    final urlFinal =
        Uri.https('${Environment.apiUrl}', 'api/visit/visits/user/$userId');

    try {
      final token = await this._storage.read(key: 'token');

      final resp = await http.get(urlFinal,
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final visitsResponse = visitsResponseFromJson(resp.body);

      return visitsResponse.visits;
    } catch (e) {
      return [];
    }
  }
}
