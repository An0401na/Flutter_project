import 'dart:convert';

import 'package:baedal_moa/Model/Menu.dart';
import 'package:http/http.dart' as http;
import '../Model/Res.dart';

class Services_Res {
  static const String url = 'http://203.249.22.50:8080/reslist';

  static Future<List<Res>> getRests() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (200 == response.statusCode) {
        final List<Res> Res1 = resFromJson(response.body);
        // for (int i = 0; i < Res1.length; i++) {
        //   print("가게 : " + Res1[i].resLocation);
        // }
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
      String __url = 'http://203.249.22.50:8080/like';
      http.post(Uri.parse(__url), headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      }, body: {
        "res_id": resId,
        "user_id": userId,
        "is_liked": isLiked.toString()
        //찜이 안되어 있어서 찜을 하려고 디비에 넣을건지 아니면 찜 취소여서 삭제를 할건지 결정하는 변수
      }).then((res) {
        print("likeRes 상태 코드 : " + res.statusCode.toString());
      }).catchError((error) => print("likeRes 에러 : " + error.toString()));
    } catch (error) {
      print('likeRes 에러 : ' + error.toString());
    }
  }

  //사용자가 가게정보페이지에 들어갔을때 찜에 되었는지 확인할 정보
  static Future<bool> isResLiked(String resId, String userId) async {
    try {
      String __url = 'http://203.249.22.50:8080/????';
      final res = await http.post(Uri.parse(__url), headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      }, body: {
        "res_id": resId,
        "user_id": userId
      });
      print("isLikeRes의 상태 코드 : " + res.statusCode.toString());
      if (res.statusCode == 200) {
        bool isLiked = jsonDecode(res.body)['????'];
        print("찜 유무 : " + isLiked.toString());
        return isLiked;
      } else {
        return false;
      }
    } catch (error) {
      print('isLikeRes 에러 : ' + error.toString());
      return false;
    }
  }

  static Future<bool> getLikedResList(String userId) async {
    try {
      String __url = 'http://203.249.22.50:8080/????';
      final res = await http.post(Uri.parse(__url), headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      }, body: {
        "user_id": userId
      });
      print("getLikedResList의 상태 코드 : " + res.statusCode.toString());
      if (res.statusCode == 200) {
        bool isLiked = jsonDecode(res.body)['????'];
        return isLiked;
      } else {
        return false;
      }
    } catch (error) {
      print('isLikeRes 에러 : ' + error.toString());
      return false;
    }
  }
}
