import 'dart:convert';
import 'package:chat/models/profiles.dart';

LoginResponse profileResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String profileResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({
    this.ok,
    this.profile,
  });

  bool ok;
  Profiles profile;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        ok: json["ok"],
        profile: Profiles.fromJson(json["profile"]),
      );

  Map<String, dynamic> toJson() => {"ok": ok, "profile": profile.toJson()};
}
