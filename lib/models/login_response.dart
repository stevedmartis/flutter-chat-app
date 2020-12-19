// To parse this JSON data, do
//
//  final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';
import 'package:chat/models/profiles.dart';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({
    this.ok,
    this.profile,
    this.token,
  });

  bool ok;
  Profiles profile;
  String token;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        ok: json["ok"],
        profile: Profiles.fromJson(json["profile"]),
        token: json["token"],
        //json['profile'].cast<String>()

//        Profile.fromJson(json["profile"]),
      );

  Map<String, dynamic> toJson() => {"ok": ok, "profile": profile.toJson()};
}
