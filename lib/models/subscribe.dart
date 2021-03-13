import 'dart:convert';

Subscription subscribeFromJson(String str) =>
    Subscription.fromJson(json.decode(str));

String subscribeToJson(Subscription data) => json.encode(data.toJson());

class Subscription {
  Subscription(
      {this.id = "",
      this.subscriptor = "",
      this.club = "",
      this.createdAt,
      this.updatedAt,
      this.imageRecipe = "",
      this.isUpload = false,
      this.subscribeActive = false,
      this.subscribeApproved = false,
      this.isClubNotifi = false,
      this.isUserNotifi = false,
      isRoute,
      init()});

  String id;

  String subscriptor;
  String club;
  String imageRecipe;
  bool isUpload;
  bool subscribeActive;
  bool subscribeApproved;

  bool isClubNotifi;
  bool isUserNotifi;

  DateTime createdAt;
  DateTime updatedAt;

  factory Subscription.fromJson(Map<String, dynamic> json) => new Subscription(
        id: json["id"],
        club: json["club"],
        subscriptor: json["subscriptor"],
        imageRecipe: json["imageRecipe"],
        subscribeActive: json["subscribeActive"],
        subscribeApproved: json["subscribeApproved"],
        isClubNotifi: json["isClubNotifi"],
        isUserNotifi: json["isUserNotifi"],

        isUpload: json["isUpload"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),

        //images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "club": club,
        "subscribeActive": subscribeActive,
        "subscribeApproved": subscribeApproved,
        "subscriptor": subscriptor,
        "imageRecipe": imageRecipe,
        "isUpload": isUpload,
        "isClubNotifi": isClubNotifi,
        "isUserNotifi": isUserNotifi
      };
}
