// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

import 'dart:convert';

List<Order> orderFromJson(String str) =>
    List<Order>.from(json.decode(str).map((x) => Order.fromJson(x)));

String orderToJson(List<Order> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Order {
  Order({
    required this.roomId,
    required this.menuName,
    required this.menuPrice,
    required this.menuCount,
    required this.resName,
    required this.roomExpireTime,
    required this.userDelFee,
  });

  int roomId;
  String menuName;
  int menuPrice;
  int menuCount;
  String resName;
  DateTime roomExpireTime;
  int userDelFee;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        roomId: json["room_id"],
        menuName: json["menu_id"],
        menuPrice: json["menu_price"],
        menuCount: json["menu_count"],
        resName: json["res_id"],
        roomExpireTime: DateTime.parse(json["room_expire_time"]),
        userDelFee: json["user_del_fee"],
      );

  Map<String, dynamic> toJson() => {
        "room_id": roomId,
        "menu_id": menuName,
        "menu_price": menuPrice,
        "menu_count": menuCount,
        "res_id": resName,
        "room_expire_time": roomExpireTime.toIso8601String(),
        "user_del_fee": userDelFee,
      };
}
