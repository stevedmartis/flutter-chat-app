import 'dart:convert';

import 'dart:io';

import 'package:chat/models/profiles.dart';
import 'package:chat/models/room.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:chat/global/environment.dart';

import 'package:chat/models/login_response.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService with ChangeNotifier {
  Profiles _profile;
  List<Room> rooms;
  bool _authenticated = false;

  static String clientId = 'com.davidstevemars.signinservice';
  static String redirectUri =
      'https://api.gettymarket.com/api/apple/callbacks/sign_in_with_apple';

  static GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );

  appleSignIn() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          webAuthenticationOptions: WebAuthenticationOptions(
              clientId: clientId, redirectUri: Uri.parse(redirectUri)));

      print(credential);
      print(credential.authorizationCode);

      final useBundleId = Platform.isIOS ? true : false;

      final res = await this.siginWithApple(
          credential.authorizationCode,
          credential.email,
          credential.givenName,
          useBundleId,
          credential.state);

      return res;
    } catch (e) {
      print(e);
    }
  }

  final _storage = new FlutterSecureStorage();

  bool get authenticated => this._authenticated;
  set authenticated(bool valor) {
    this._authenticated = valor;
    notifyListeners();
  }

  Profiles get profile => this._profile;

  set profile(Profiles valor) {
    this._profile = valor;
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
    signOut();
  }

  Future<bool> login(String email, String password) async {
    this.authenticated = true;

    final data = {'email': email, 'password': password};

    final resp = await http.post('${Environment.apiUrl}/profile/login',
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    this.authenticated = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.profile = loginResponse.profile;

      await this._guardarToken(loginResponse.token);

      // await getProfileByUserId(this.profile.user.uid);

      return true;
    } else {
      return false;
    }
  }

  Future siginWithGoogleBack(token) async {
    final resp = await http.post('${Environment.apiUrl}/google/sign-in',
        body: jsonEncode({'token': token}),
        headers: {'Content-Type': 'application/json'});

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.profile = loginResponse.profile;

      print(this.profile);
      await this._guardarToken(loginResponse.token);
      // this.authenticated = true;

      // await getProfileByUserId(this.profile.user.uid);

      return true;
    } else {
      return false;
    }

    // await getProfileByUserId(this.profile.user.uid);
  }

  Future signInWitchGoogle() async {
    try {
      final account = await _googleSignIn.signIn();

      print(account);

      final googleKey = await account.authentication;

      print(googleKey.idToken);
      final authBack = await siginWithGoogleBack(googleKey.idToken);
      print(authBack);

      return authBack;
    } catch (e) {
      print('error signin google');
      print(e);
    }
  }

  Future siginWithApple(String code, String email, String firstName,
      bool useBundleId, String state) async {
    final data = {
      'code': code,
      'email': email,
      'firstName': firstName,
      'useBundleId': useBundleId,
      if (state != null) 'state': state
    };
    final resp = await http.post(
        '${Environment.apiUrl}/apple/sign_in_with_apple',
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'});

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.profile = loginResponse.profile;

      print(this.profile);
      await this._guardarToken(loginResponse.token);
      // this.authenticated = true;

      // await getProfileByUserId(this.profile.user.uid);

      return true;
    } else {
      return false;
    }

    // await getProfileByUserId(this.profile.user.uid);
  }

  static Future signOut() async {
    await _googleSignIn.signOut();
  }

  Future register(String username, String email, String password) async {
    // this.authenticated = true;

    final data = {'username': username, 'email': email, 'password': password};

    final resp = await http.post('${Environment.apiUrl}/login/new',
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    this.authenticated = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);

      this.profile = loginResponse.profile;

      //this.profile = loginResponse.profile;
      await this._guardarToken(loginResponse.token);

      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future editProfile(String uid, String username, String about, String name,
      String email, String password) async {
    // this.authenticated = true;

    final data = {
      'uid': uid,
      'username': username,
      'name': name,
      'about': about,
      'email': email,
      'password': password,
    };

    final token = await this._storage.read(key: 'token');

    final resp = await http.post('${Environment.apiUrl}/profile/edit',
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);

      this.profile = loginResponse.profile;

      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await this._storage.read(key: 'token');
    //this.logout();
    final resp = await http.get('${Environment.apiUrl}/login/renew',
        headers: {'Content-Type': 'application/json', 'x-token': token});
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.profile = loginResponse.profile;
      // this.profile = loginResponse.profile;
      await this._guardarToken(loginResponse.token);
      // await getProfileByUserId(this.user.uid);
      // this.logout();a
      this.authenticated = false;

      return true;
    } else {
      this.logout();
      return false;
    }
  }

  Future _guardarToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    await _storage.delete(key: 'token');
    signOut();
  }
}
