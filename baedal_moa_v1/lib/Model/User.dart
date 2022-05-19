// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

List<User> userFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  User({
    required this.userId,
    required this.userNickname,
    required this.userLocationX,
    required this.userLocationY,
    required this.userCash,
  });

  int userId;
  String userNickname;
  String userLocationX;
  String userLocationY;
  int userCash;

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["user_id"],
        userNickname: json["user_nickname"],
        userLocationX: json["user_location_x"],
        userLocationY: json["user_location_y"],
        userCash: json["user_cash"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user_nickname": userNickname,
        "user_location_x": userLocationX,
        "user_location_y": userLocationY,
        "user_cash": userCash,
      };
}
