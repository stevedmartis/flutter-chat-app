import 'dart:convert';

import 'package:flutter/material.dart';

import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:chat/global/environment.dart';

import 'package:mime_type/mime_type.dart';

class AwsService with ChangeNotifier {
  String _image;

  bool _isUpload = false;

  // static String redirectUri = 'https://api.gettymarket.com/api/aws/';

  final _storage = new FlutterSecureStorage();

  bool get isUpload => this._isUpload;
  set isUpload(bool valor) {
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

  Future<String> uploadImageAvatar(
      String uid, String fileName, String fileType, File image) async {
    final url = Uri.parse('${Environment.apiUrl}/aws/upload/avatar');

    final mimeType = mime(image.path).split('/'); //image/jpeg

    final token = await this._storage.read(key: 'token');

    Map<String, String> headers = {"x-token": token, 'uid': uid};

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('file', image.path,
        contentType: MediaType(mimeType[0], mimeType[1]));

    imageUploadRequest.files.add(file);

    imageUploadRequest.headers.addAll(headers);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Algo salio mal');
      print(resp.body);
      return null;
    }

    final respBody = jsonDecode(resp.body);

    //final respData = imageResponseToJson(resp.body);

    final respUrl = respBody['url'];

    return respUrl;
  }

  Future<String> uploadImageHeader(
      String uid, String fileName, String fileType, File image) async {
    final url = Uri.parse('${Environment.apiUrl}/aws/upload/header');

    final mimeType = mime(image.path).split('/'); //image/jpeg

    final token = await this._storage.read(key: 'token');

    Map<String, String> headers = {"x-token": token, 'uid': uid};

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('file', image.path,
        contentType: MediaType(mimeType[0], mimeType[1]));

    imageUploadRequest.files.add(file);

    imageUploadRequest.headers.addAll(headers);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Algo salio mal');
      print(resp.body);
      return null;
    }

    final respBody = jsonDecode(resp.body);

    //final respData = imageResponseToJson(resp.body);
    isUpload = true;

    final respUrl = respBody['url'];
    this.image = respUrl.toString();
    return respUrl;
  }
}
