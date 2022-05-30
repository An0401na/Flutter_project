import 'dart:convert';

import 'package:http/http.dart' as http;
import '../Model/AppUser.dart';

class Services_User {
  static const String url = 'http://203.249.22.50:8080/userprofile';

  static Future<List<AppUser>> getUsers(String userId) async {
    try {
      final response =
          await http.post(Uri.parse(url), headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      }, body: {
        "user_id": userId
      });
      print("getUsers의 상태코드 : " + response.statusCode.toString());
      if (200 == response.statusCode) {
        final List<AppUser> user1 = userFromJson(response.body);
        print("사용자: " + response.body);
        return user1;
      } else {
        print('User not found');
        return <AppUser>[]; // 빈 사용자 목록을 반환
      }
    } catch (e) {
      return <AppUser>[];
    }
  }
  //
  // static Future<dynamic> getUser(String userId) async {
  //   try {
  //     final response =
  //         await http.post(Uri.parse(url), headers: <String, String>{
  //       'Content-Type': 'application/x-www-form-urlencoded',
  //     }, body: {
  //       "user_id": userId
  //     });
  //     print("getUser의 상태코드 : " + response.statusCode.toString());
  //     if (200 == response.statusCode) {
  //       final AppUser user1 = jsonDecode(response.body) as AppUser;
  //       print("사용자: " + response.body);
  //       return user1;
  //     } else {
  //       print('User not found');
  //       return '사용자 없음'; // 빈 사용자 목록을 반환
  //     }
  //   } catch (e) {
  //     return 'getUser 오류';
  //   }
  // }
}
