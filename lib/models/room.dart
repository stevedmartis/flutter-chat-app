import 'dart:convert';

Room roomFromJson(String str) => Room.fromJson(json.decode(str));

String roomToJson(Room data) => json.encode(data.toJson());

class Room {
  Room(
      {this.id,
      this.user,
      this.name = "",
      this.description = "",
      this.position,
      this.totalItems,
      this.createdAt,
      this.updatedAt,
      this.wide = 0,
      this.long = 0,
      this.tall = 0,
      this.timeOn = "",
      this.timeOff = "",
      this.co2 = false,
      this.co2Control = false,
      isRoute,
      init()});

  String user;
  String id;
  String name;
  int position;
  String description;
  int wide;
  int long;
  int tall;
  String timeOn;
  String timeOff;
  bool co2;
  bool co2Control;

  int totalItems;
  DateTime createdAt;
  DateTime updatedAt;

  factory Room.fromJson(Map<String, dynamic> json) => new Room(
      id: json["id"],
      user: json["user"],
      name: json["name"],
      position: json['position'],
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      description: json["description"],
      //products: List<Product>.from(json["products"].map((x) => x)),
      totalItems: json["totalItems"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "name": name,
        "position": position,
        "description": description,
        "totalItems": totalItems,
        //"products": List<dynamic>.from(products.map((x) => x)),
      };

/*   getPosterImg() {
    if (avatar == "") {
      return "";
    } else {
      return avatar;
    }
  } */

}
