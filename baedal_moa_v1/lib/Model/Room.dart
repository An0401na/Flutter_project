// To parse this JSON data, do
//
//     final room = roomFromJson(jsonString);

import 'dart:convert';

import 'package:baedal_moa/Pages/App.dart';

import 'AppUser.dart';

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
    required this.roomMemberMenus,
    required this.roomUserNickname,
    required this.roomUser,
    required this.res,
  });

  int roomId;
  String roomName;
  int resId;
  String hostUserId;
  int roomMaxPeople;
  DateTime roomStartTime;
  DateTime roomExpireTime;
  String roomLocationX;
  String roomLocationY;
  int roomOrderPrice;
  int roomDelFee;
  int roomIsActive;
  List<RoomMemberMenu> roomMemberMenus;
  List<String> roomUserNickname;
  List<int> roomUser;

  RoomRes res;

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
        roomMemberMenus: List<RoomMemberMenu>.from(
            json["room_member_menus"].map((x) => RoomMemberMenu.fromJson(x))),
        roomUserNickname:
            List<String>.from(json["room_user_nickname"].map((x) => x)),
        roomUser: List<int>.from(json["room_user"].map((x) => x)),
        res: RoomRes.fromJson(json["res"]),
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
        "room_member_menus":
            List<dynamic>.from(roomMemberMenus.map((x) => x.toJson())),
        "room_user_nickname":
            List<dynamic>.from(roomUserNickname.map((x) => x)),
        "room_user": List<dynamic>.from(roomUser.map((x) => x)),
        "res": res.toJson(),
      };
}

class RoomRes {
  RoomRes({
    required this.resName,
    required this.resLocation,
    required this.resMinOrderPrice,
  });

  String resName;
  String resLocation;
  int resMinOrderPrice;

  factory RoomRes.fromJson(Map<String, dynamic> json) => RoomRes(
        resName: json["res_name"],
        resLocation: json["res_location"],
        resMinOrderPrice: json["res_min_order_price"],
      );

  Map<String, dynamic> toJson() => {
        "res_name": resName,
        "res_location": resLocation,
        "res_min_order_price": resMinOrderPrice,
      };
}

class RoomMemberMenu {
  RoomMemberMenu(
      {required this.menuId,
      required this.userId,
      required this.menuPrice,
      required this.menuCnt});

  int menuId;
  int userId;
  int menuPrice;
  int menuCnt;

  factory RoomMemberMenu.fromJson(Map<String, dynamic> json) => RoomMemberMenu(
      menuId: json["menu_id"],
      userId: json["user_id"],
      menuPrice: json["menu_price"],
      menuCnt: json["menu_count"]);

  Map<String, dynamic> toJson() => {
        "menu_id": menuId,
        "user_id": userId,
        "menu_price": menuPrice,
        "menu_count": menuCnt
      };
}
