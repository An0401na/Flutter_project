import 'dart:convert';

import 'package:baedal_moa/Model/Room.dart';
import 'package:baedal_moa/Model/ShoppingCart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Model/ShoppingCart.dart';

class Services_ShoppingCart {
  static Future<void> postShoppingCart(
      List<RoomMemberMenu> roomMemberMenu, String roomId) async {
    try {
      String __url = 'http://203.249.22.50:8080/room/join';
      http.post(Uri.parse(__url), headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      }, body: {
        "room_id": roomId,
        "user_id": roomMemberMenu[0].userId.toString(),
        "room_member_menus": jsonEncode(roomMemberMenu)
      }).then((res) {
        print("postShoppingCart의 상태 코드 : " + res.statusCode.toString());
      }).catchError(
          (error) => print("postShoppingCart에러 : " + error.toString()));
    } catch (error) {
      print('postShoppingCart 에러 : ' + error.toString());
    }
  }
}
