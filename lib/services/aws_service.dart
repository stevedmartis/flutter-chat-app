import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:chat/global/environment.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

class AwsService with ChangeNotifier {
  String _image;

  bool _isUpload = false;

  // static String redirectUri = 'https://api.gettymarket.com/api/aws/';

  final _storage = new FlutterSecureStorage();

  bool get isUpload => this._isUpload;
  set authenticated(bool valor) {
    this._isUpload = valor;
    notifyListeners();
  }

  String get image => this._image;

  set image(String valor) {
    this._image = valor;
    notifyListeners();
  }

  // Getters del token de forma estática
  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  Future uploadAvatar(
    String uid,
    String fileName,
    String fileType,
    File image,
  ) async {
    // this.authenticated = true;

    // final x = image.readAsBytesSync();

    print(path.basename(image.path));
    final data = {
      'uid': uid,
      'fileName': path.basename(image.path),
      'fileType': fileType,
      'image': image.readAsBytesSync()
    };

    final token = await this._storage.read(key: 'token');

    final resp = await http.post('${Environment.apiUrl}/aws/upload/avatar',
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json' + fileType,
          'x-token': token
        });

    if (resp.statusCode == 200) {
      // final loginResponse = loginResponseFromJson(resp.body);

      // this.image= loginResponse.profile;

      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }
}
