// To parse this JSON data, do
//
//     final room = roomFromJson(jsonString);

import 'dart:convert';

List<Room> roomFromJson(String str) =>
    List<Room>.from(json.decode(str).map((x) => Room.fromJson(x)));

String roomToJson(List<Room> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Room {
  Room({
    required this.roomId,
    required this.roomName,
    required this.resId,
    required this.hostUserId,
    required this.roomMaxPeople,
    required this.roomStartTime,
    required this.roomExpireTime,
    required this.roomLocationX,
    required this.roomLocationY,
    required this.roomOrderPrice,
    required this.roomDelFee,
    required this.roomIsActive,
    required this.roomUser,
  });

  int roomId;
  String roomName;
  String resId;
  String hostUserId;
  int roomMaxPeople;
  DateTime roomStartTime;
  DateTime roomExpireTime;
  String roomLocationX;
  String roomLocationY;
  int roomOrderPrice;
  int roomDelFee;
  int roomIsActive;
  List<int> roomUser;

  factory Room.fromJson(Map<String, dynamic> json) => Room(
        roomId: json["room_id"],
        roomName: json["room_name"],
        resId: json["res_id"],
        hostUserId: json["host_user_id"],
        roomMaxPeople: json["room_max_people"],
        roomStartTime: DateTime.parse(json["room_start_time"]),
        roomExpireTime: DateTime.parse(json["room_expire_time"]),
        roomLocationX: json["room_location_x"],
        roomLocationY: json["room_location_y"],
        roomOrderPrice: json["room_order_price"],
        roomDelFee: json["room_del_fee"],
        roomIsActive: json["room_is_active"],
        roomUser: List<int>.from(json["room_user"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "room_id": roomId,
        "room_name": roomName,
        "res_id": resId,
        "host_user_id": hostUserId,
        "room_max_people": roomMaxPeople,
        "room_start_time": roomStartTime.toIso8601String(),
        "room_expire_time": roomExpireTime.toIso8601String(),
        "room_location_x": roomLocationX,
        "room_location_y": roomLocationY,
        "room_order_price": roomOrderPrice,
        "room_del_fee": roomDelFee,
        "room_is_active": roomIsActive,
        "room_user": List<dynamic>.from(roomUser.map((x) => x)),
      };
}
