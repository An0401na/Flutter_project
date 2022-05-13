import 'package:http/http.dart' as http;
import 'Posts.dart';

class Services {
  static const String url = 'https://jsonplaceholder.typicode.com/posts';

  static Future<List<Post>> getPost() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (200 == response.statusCode) {
        final List<Post> posts = postsFromJson(response.body);
        return posts;
      } else {
        return <Post>[];
      }
    } catch (e) {
      return <Post>[];
    }
  }
}
