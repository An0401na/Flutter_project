import 'package:http/http.dart' as http;
import 'package:test_json_list_parsing/Users.dart';

class Services {
  static const String url = 'http://203.249.22.52:8000/';

  static Future<List<User>> getUsers() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (200 == response.statusCode) {
        final List<User> users = usersFromJson(response.body);
        print("바디 : " + response.body);
        return users;
      } else {
        print("비어있음" + 'empty');
        return <User>[]; // 빈 사용자 목록을 반환
      }
    } catch (e) {
      return <User>[];
    }
  }
}
