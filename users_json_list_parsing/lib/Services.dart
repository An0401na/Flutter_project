import 'package:http/http.dart' as http;
import 'package:json_list_parsing/Users.dart';

class Services {
  static const String url = 'https://jsonplaceholder.typicode.com/users';

  static Future<List<User>> getUsers() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (200 == response.statusCode) {
        final List<User> users = usersFromJson(response.body);
        return users;
      } else {
        return <User>[]; // 빈 사용자 목록을 반환
      }
    } catch (e) {
      return <User>[];
    }
  }
}
