// To parse this JSON data, do
//
//     final mensajesResponse = mensajesResponseFromJson(jsonString);

import 'dart:convert';

MesaggesResponse messageResponseFromJson(String str) =>
    MesaggesResponse.fromJson(json.decode(str));

String messageResponseToJson(MesaggesResponse data) =>
    json.encode(data.toJson());

class MesaggesResponse {
  MesaggesResponse({
    this.ok,
    this.messages,
  });

  bool ok;
  List<Message> messages;

  factory MesaggesResponse.fromJson(Map<String, dynamic> json) =>
      MesaggesResponse(
        ok: json["ok"],
        messages: List<Message>.from(
            json["messages"].map((x) => Message.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "messages": List<dynamic>.from(messages.map((x) => x.toJson())),
      };
}

class Message {
  Message({
    this.by,
    this.forHim,
    this.message,
    this.createdAt,
    this.updatedAt,
  });

  String by;
  String forHim;
  String message;
  DateTime createdAt;
  DateTime updatedAt;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        by: json["by"],
        forHim: json["for"],
        message: json["message"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "by": by,
        "for": forHim,
        "message": message,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
