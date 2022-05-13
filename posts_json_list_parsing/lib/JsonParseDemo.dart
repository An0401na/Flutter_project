import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'Services.dart';
import 'Posts.dart';

class JsonParseDemo extends StatefulWidget {
  JsonParseDemo() : super();

  @override
  State<JsonParseDemo> createState() => _JsonParseDemoState();
}

class _JsonParseDemoState extends State<JsonParseDemo> {
  late List<Post> _posts;
  late bool _loading;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loading = true;
    Services.getPost().then((posts) {
      setState(() {
        _posts = posts;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_loading ? 'Loading....' : 'Posts'),
      ),
      body: Container(
        color: Colors.white,
        child: ListView.builder(
            itemCount: null == _posts ? 0 : _posts.length,
            itemBuilder: (context, index) {
              Post post = _posts[index];
              return ListTile(
                title: Text(post.userId.toString()),
                subtitle: Text(post.title),
              );
            }),
      ),
    );
  }
}
