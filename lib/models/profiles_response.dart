// To parse this JSON data, do
//
//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat/models/profiles.dart';

ProfilesResponse profilesResponseFromJson(String str) =>
    ProfilesResponse.fromJson(json.decode(str));

String profileResponseToJson(ProfilesResponse data) =>
    json.encode(data.toJson());

class ProfilesResponse {
  ProfilesResponse({this.ok, this.profiles});

  bool ok;
  List<Profiles> profiles;

  factory ProfilesResponse.fromJson(Map<String, dynamic> json) =>
      ProfilesResponse(
        ok: json["ok"],
        profiles: List<Profiles>.from(
            json["profiles"].map((x) => Profiles.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "profiles": List<dynamic>.from(profiles.map((x) => x.toJson())),
      };
}
