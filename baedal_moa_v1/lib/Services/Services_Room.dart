import 'dart:convert';

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
      print(userId);
      print("방 상태코드  : " + response.statusCode.toString());
      if (200 == response.statusCode) {
        final List<Room> room = roomFromJson(response.body);
        // print("먹친방 바디 : " + response.body);
        for (Room r in room) {
          print("방 번호: " +
              r.roomId.toString() +
              " , 멤버 수: " +
              r.roomUser.length.toString());
        }
        return room;
      } else {
        print('Room empty');
        return <Room>[]; // 빈 사용자 목록을 반환
      }
    } catch (e) {
      return <Room>[];
    }
  }

  //안쓰임
  static Future<void> postRoom(Room room) async {
    try {
      String __url = 'http://203.249.22.50:8080/room/create';
      print("aaaa");
      // final response =
      http.post(Uri.parse(__url), headers: <String, String>{
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
        "room_is_active": room.roomIsActive.toString(),
      }).then((res) {
        print(res.statusCode.toString());
        // if (200 == res.statusCode) {
        //   final List<Room> _room = roomFromJson(res.body);
        //   print("_room  바디 : " + res.body);
        //   return _room;

        // } else {
        //   print('Room empty');
        //   return <Room>[]; // 빈 사용자 목록을 반환
      }
          // print(json.decode(res.body));
          // }
          ).catchError((error) => print("room_postRoom 에러 : " + error.toString()));
      // print(response.statusCode.toString());
      // if (200 == response.statusCode) {
      //   final List<Room> _room = roomFromJson(response.body);
      //   print("먹친방 바디 : " + response.body);
      //   return _room;
      // } else {
      //   print('Room empty');
      //   return <Room>[]; // 빈 사용자 목록을 반환
      // }
    } catch (error) {
      print('postRoom 에러 : ' + error.toString());
    }
  }
}
