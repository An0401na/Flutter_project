import 'dart:convert';

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
      print(response.statusCode.toString());
      if (200 == response.statusCode) {
        final List<Room> room = roomFromJson(response.body);
        print("먹친방 바디 : " + response.body);
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
//   static Future<void> postRoom(String roomId) async {
//     try {
//       String __url = 'http://203.249.22.50:8080/noa';
//       final _url = Uri.parse(__url);
//       print("방 이름 : " + roomId);
//
//       http
//           .post(_url, headers: <String, String>{
//             'Content-Type': 'application/x-www-form-urlencoded',
//           }, body: {
//             "room_id": roomId
//           })
//           .then((res) => print(json.decode(res.body)))
//           .catchError((error) => print(error.toString()));
//     } catch (error) {
//       print('에러?? : ' + error.toString());
//     }
//   }
}
