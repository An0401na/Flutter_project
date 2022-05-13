// To parse this JSON data, do
//
//     final users = usersFromJson(jsonString);

import 'dart:convert';

List<User> usersFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String usersToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  User({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
