import 'dart:convert';

import 'package:baedal_moa/Model/ShoppingCart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Model/Room.dart';

class Services_Room {
  static const String url = 'http://203.249.22.50:8080/room';

  static Future<List<Room>> getRooms(String userId) async {
    try {
      final response =
          await http.post(Uri.parse(url), headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      }, body: {
        "user_id": userId
      });
      print("getRooms의 상태코드  : " + response.statusCode.toString());
      if (200 == response.statusCode) {
        final List<Room> room = roomFromJson(response.body);
        for (Room r in room)
          print(r.roomId.toString() + ":" + jsonEncode(r.roomUser));
        return room;
      } else {
        print('Room empty');
        return <Room>[]; // 빈 사용자 목록을 반환
      }
    } catch (e) {
      return <Room>[];
    }
  }

  static Future<dynamic> postRoom(Room room) async {
    try {
      String __url = 'http://203.249.22.50:8080/room/create';
      final res = await http.post(Uri.parse(__url), headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      }, body: {
        "room_name": room.roomName.toString(),
        "res_id": room.resId.toString(),
        "host_user_id": room.hostUserId.toString(),
        "room_max_people": room.roomMaxPeople.toString(),
        "room_start_time": room.roomStartTime.toString(),
        "room_expire_time": room.roomExpireTime.toString(),
        "room_location_x": room.roomLocationX.toString(),
        "room_location_y": room.roomLocationY.toString(),
        "room_order_price": room.roomOrderPrice.toString(),
        "room_del_fee": room.roomDelFee.toString(),
        "room_member_menus": jsonEncode(room.roomMemberMenus).toString(),
        "address": room.address
      });
      print("room_postRoom의 상태 코드 : " + res.statusCode.toString());
      if (res.statusCode == 200) {
        int tmp = jsonDecode(res.body)['room_id'];
        print("room_id: " + tmp.toString());
        return tmp;
      } else {
        return -1;
      }
    } catch (error) {
      print('postRoom 에러 : ' + error.toString());
      return -1;
    }
  }

  static Future<void> expireRoom(Room room) async {
    try {
      String __url = 'http://203.249.22.50:8080/room/expire';
      http.post(Uri.parse(__url), headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      }, body: {
        "room_id": room.roomId.toString(),
      }).then((res) {
        print("room_expireRoom의 상태 코드 : " + res.statusCode.toString());
      }).catchError(
          (error) => print("room_expireRoom 에러 : " + error.toString()));
    } catch (error) {
      print('expirRoom 에러 : ' + error.toString());
    }
  }

  //room/out 에 room_id랑 user_id 주면 방 나가기
  static Future<void> outRoom(String roomId, String userId) async {
    try {
      String __url = 'http://203.249.22.50:8080/room/out';
      http.post(Uri.parse(__url), headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      }, body: {
        "room_id": roomId,
        "user_id": userId
      }).then((res) {
        print("outRoom 상태 코드 : " + res.statusCode.toString());
      }).catchError((error) => print("outRoom 에러 : " + error.toString()));
    } catch (error) {
      print('outRoom 에러 : ' + error.toString());
    }
  }
}
