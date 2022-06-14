import 'dart:convert';

import 'package:baedal_moa/Model/Menu.dart';
import 'package:http/http.dart' as http;
import '../Model/Res.dart';

class Services_Res {
  static const String url = 'http://203.249.22.50:8080/reslist';

  static Future<List<Res>> getRests() async {
    try {
      final response = await http.get(Uri.parse(url));
      print(response.body);
      if (200 == response.statusCode) {
        final List<Res> Res1 = resFromJson(response.body);
        return Res1;
      } else {
        print('Restaurant empty');
        return <Res>[]; // 빈 사용자 목록을 반환
      }
    } catch (e) {
      return <Res>[];
    }
  }

  static Future<List<Res>> getCats(String category) async {
    try {
      String __url = 'http://203.249.22.50:8080/category/${category}';
      final response = await http.get(Uri.parse(__url));
      print(response.body);
      if (200 == response.statusCode) {
        final List<Res> Res1 = resFromJson(response.body);
        return Res1;
      } else {
        print('Restaurant empty');
        return <Res>[]; // 빈 사용자 목록을 반환
      }
    } catch (e) {
      return <Res>[];
    }
  }

  //찜하기 버튼을 눌렀을때 서버에 보낼 정보
  static Future<void> likedRes(
      String resId, String userId, bool isLiked) async {
    try {
      String __url = 'http://203.249.22.50:8080/like/update';
      http.post(Uri.parse(__url), headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      }, body: {
        "res_id": resId,
        "user_id": userId,
        "is_like": isLiked.toString()
        //찜이 안되어 있어서 찜을 하려고 디비에 넣을건지 아니면 찜 취소여서 삭제를 할건지 결정하는 변수
      }).then((res) {
        print("likedRes 상태 코드 : " + res.statusCode.toString());
      }).catchError((error) => print("likeRes 에러 : " + error.toString()));
    } catch (error) {
      print('likedRes 에러 : ' + error.toString());
    }
  }

  static Future<List<Res>> getLikedResList(String userId) async {
    try {
      String __url = 'http://203.249.22.50:8080/like/get';
      final response =
          await http.post(Uri.parse(__url), headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      }, body: {
        "user_id": userId
      });
      print("getLikedResList의 상태 코드 : " + response.statusCode.toString());
      // print(response.body);
      if (response.statusCode == 200) {
        final List<Res> Res1 = resFromJson(response.body);
        return Res1;
      } else {
        print("restaurant empty");
        return [];
      }
    } catch (error) {
      print('getLikedResList 에러 : ' + error.toString());
      return [];
    }
  }

  static Future<List<Res>> getSearchRes(String keyword) async {
    try {
      String __url = 'http://203.249.22.50:8080/reslist/search';
      final response =
          await http.post(Uri.parse(__url), headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      }, body: {
        "keyword": keyword
      });
      print("getSearchRes의 상태 코드 : " + response.statusCode.toString());
      print(response.body);
      if (response.statusCode == 200) {
        final List<Res> Res1 = resFromJson(response.body);
        return Res1;
      } else {
        print("restaurant empty");
        return [];
      }
    } catch (error) {
      print('getSearchRes 에러 : ' + error.toString());
      return [];
    }
  }
}
