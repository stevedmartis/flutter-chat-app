import 'dart:convert';

import 'package:chat/models/profile.dart';
import 'package:chat/models/profile_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:chat/global/environment.dart';

import 'package:chat/models/login_response.dart';
import 'package:chat/models/usuario.dart';

class AuthService with ChangeNotifier {
  User user;
  Profile profile;
  bool _authenticated = false;

  final _storage = new FlutterSecureStorage();

  bool get authenticated => this._authenticated;
  set authenticated(bool valor) {
    this._authenticated = valor;
    notifyListeners();
  }

  // Getters del token de forma estática
  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    this.authenticated = true;

    final data = {'email': email, 'password': password};

    final resp = await http.post('${Environment.apiUrl}/login',
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    this.authenticated = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.user = loginResponse.user;

      await this._guardarToken(loginResponse.token);

      await getProfileByUserId(this.user.uid);

      return true;
    } else {
      return false;
    }
  }

  Future register(String username, String email, String password) async {
    this.authenticated = true;

    final data = {'username': username, 'email': email, 'password': password};

    final resp = await http.post('${Environment.apiUrl}/login/new',
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    this.authenticated = false;
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);

      this.user = loginResponse.user;

      //this.profile = loginResponse.profile;
      await this._guardarToken(loginResponse.token);

      final token = await this._storage.read(key: 'token');
      print(token);

      await getProfileByUserId(this.user.uid);

      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future<bool> getProfileByUserId(String id) async {
    final token = await this._storage.read(key: 'token');
    print(' ENTROAA::: ${id}');

    final resp = await http.get('${Environment.apiUrl}/login/profile/user/$id',
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      print('resp');

      final profileResponse = profileResponseFromJson(resp.body);
      this.profile = profileResponse.profile;
      print(' profile resss:::: ${profileResponse}');

      // this.profile = loginResponse.profile;
      // await this._guardarToken(loginResponse.token);

      return true;
    } else {
      print('que wea');
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await this._storage.read(key: 'token');

    final resp = await http.get('${Environment.apiUrl}/login/renew',
        headers: {'Content-Type': 'application/json', 'x-token': token});
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.user = loginResponse.user;

      // this.profile = loginResponse.profile;
      await this._guardarToken(loginResponse.token);
      await getProfileByUserId(this.user.uid);

      // this.logout();a

      return true;
    } else {
      print('nooo ');

      this.logout();
      return false;
    }
  }

  Future _guardarToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    await _storage.delete(key: 'token');
  }
}
