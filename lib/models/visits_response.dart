import 'dart:convert';

import 'package:chat/models/plant.dart';
import 'package:chat/models/visit.dart';

VisitsResponse visitsResponseFromJson(String str) =>
    VisitsResponse.fromJson(json.decode(str));

String visitsResponseToJson(VisitsResponse data) => json.encode(data.toJson());

class VisitsResponse {
  VisitsResponse({this.ok, this.visits});

  bool ok;
  List<Visit> visits;

  factory VisitsResponse.fromJson(Map<String, dynamic> json) => VisitsResponse(
        ok: json["ok"],
        visits: List<Visit>.from(json["visits"].map((x) => Visit.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "visits": List<dynamic>.from(visits.map((x) => x.toJson())),
      };

  VisitsResponse.withError(String errorValue);
}
