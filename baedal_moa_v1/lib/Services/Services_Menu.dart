import 'dart:convert';

import 'package:http/http.dart' as http;
import '../Model/Menu.dart';

class Services_Menu {
  static const String url = 'http://203.249.22.50:8080/menu';

  //선택된 가게 보내고 메뉴 목록 받아옴
  static Future<List<Menu>> getMenus(String resId) async {
    try {
      final response =
          await http.post(Uri.parse(url), headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      }, body: {
        "res_id": resId
      });
      print(response.statusCode.toString());
      if (200 == response.statusCode) {
        final List<Menu> Menu1 = menuFromJson(response.body);
        // print("메뉴 바디 : " + response.body);
        return Menu1;
      } else {
        print('Menu empty');
        return <Menu>[]; // 빈 사용자 목록을 반환
      }
    } catch (e) {
      return <Menu>[];
    }
  }

  static Future<void> postMenu(String menuName) async {
    try {
      String __url = 'http://203.249.22.50:8080/reslist';
      final _url = Uri.parse(__url);
      print("선택한 메뉴 이름 : " + menuName);
      http
          .post(_url, headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded',
          }, body: {
            "menu_name": menuName
          })
          .then((res) => print(json.decode(res.body)))
          .catchError((error) => print(error.toString()));
    } catch (error) {
      print('에러?? : ' + error.toString());
    }
  }
}
