// To parse this JSON data, do
//
//     final room = roomFromJson(jsonString);

import 'dart:convert';

List<Room> roomFromJson(String str) =>
    List<Room>.from(json.decode(str).map((x) => Room.fromJson(x)));

String roomToJson(List<Room> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Room {
  Room(
      {required this.roomId,
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
      required this.roomMemberMenus,
      required this.res,
      required this.address});

  int roomId;
  String roomName;
  int resId;
  int hostUserId;
  int roomMaxPeople;
  DateTime roomStartTime;
  DateTime roomExpireTime;
  String roomLocationX;
  String roomLocationY;
  int roomOrderPrice;
  int roomDelFee;
  int roomIsActive;
  List<RoomUser> roomUser;
  List<List<RoomMemberMenu>> roomMemberMenus;
  RoomRes res;
  String address;

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
        roomUser: List<RoomUser>.from(
            json["room_user"].map((x) => RoomUser.fromJson(x))),
        roomMemberMenus: List<List<RoomMemberMenu>>.from(
            json["room_member_menus"].map((x) => List<RoomMemberMenu>.from(
                x.map((x) => RoomMemberMenu.fromJson(x))))),
        res: RoomRes.fromJson(json["res"]),
        address: json["address"],
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
        "room_user": List<dynamic>.from(roomUser.map((x) => x.toJson())),
        "room_member_menus": List<dynamic>.from(roomMemberMenus
            .map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
        "res": res.toJson(),
        "address": address,
      };
}

class RoomRes {
  RoomRes({
    required this.resId,
    required this.resName,
    required this.resLocation,
    required this.resMinOrderPrice,
  });

  int resId;
  String resName;
  String resLocation;
  int resMinOrderPrice;

  factory RoomRes.fromJson(Map<String, dynamic> json) => RoomRes(
        resId: json["res_id"],
        resName: json["res_name"],
        resLocation: json["res_location"],
        resMinOrderPrice: json["res_min_order_price"],
      );

  Map<String, dynamic> toJson() => {
        "res_id": resId,
        "res_name": resName,
        "res_location": resLocation,
        "res_min_order_price": resMinOrderPrice,
      };
}

class RoomMemberMenu {
  RoomMemberMenu({
    required this.userId,
    required this.menuId,
    required this.menuPrice,
    required this.menuCount,
  });

  int userId;
  int menuId;
  int menuPrice;
  int menuCount;

  factory RoomMemberMenu.fromJson(Map<String, dynamic> json) => RoomMemberMenu(
        userId: json["user_id"],
        menuId: json["menu_id"],
        menuPrice: json["menu_price"],
        menuCount: json["menu_count"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "menu_id": menuId,
        "menu_price": menuPrice,
        "menu_count": menuCount,
      };
}

class RoomUser {
  RoomUser({
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

  factory RoomUser.fromJson(Map<String, dynamic> json) => RoomUser(
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
