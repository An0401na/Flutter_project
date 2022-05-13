import 'dart:convert';

import 'package:http/http.dart' as http;
import '../Model/Menu.dart';

class Services_Menu {
  static const String url = 'http://203.249.22.50:8080/menulist';

  static Future<List<Menu>> getMenus() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (200 == response.statusCode) {
        final List<Menu> Room1 = menuFromJson(response.body);
        print(response.body);
        return Room1;
      } else {
        print('empty');
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
