import 'dart:convert';

import 'package:http/http.dart' as http;
import '../Model/User.dart';

class Services_User {
  static const String url = 'http://203.249.22.50:8080/userprofile';

  static Future<List<User>> getUsers(String userId) async {
    try {
      final response =
          await http.post(Uri.parse(url), headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      }, body: {
        "user_id": userId
      });
      print(response.statusCode.toString());
      if (200 == response.statusCode) {
        final List<User> user1 = userFromJson(response.body);
        // user1.insert(
        //     0,
        //     User(
        //         userId: 0,
        //         userCash: 0,
        //         userLocationX: "0.0",
        //         userLocationY: "0.0",
        //         userNickname: "a"));
        print("사용자: " + response.body);
        return user1;
      } else {
        print('User not found');
        return <User>[]; // 빈 사용자 목록을 반환
      }
    } catch (e) {
      return <User>[];
    }
  }
}
