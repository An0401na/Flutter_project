import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'post.dart';

Future<Post> fetchPost() async {
  final response =
      await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));
  if (response.statusCode == 200) {
    print('응답함');
    return Post.fromJson(json.decode(response.body));
  } else {
    print("응답안함");
    throw Exception('Failed to load post');
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Post>? post;

  void initState() {
    super.initState();
    post = fetchPost();
    print(post);
  }

  Widget build(BuildContext context) {
    Color c1 = const Color(0xffF55A3B);
    return MaterialApp(
      title: 'ddddd',
      theme: ThemeData(primaryColor: c1),
      home: Scaffold(
        appBar: AppBar(
          title: Text("dd"),
        ),
        body: Center(
          child: FutureBuilder(
            future: fetchPost(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return buildColumn(snapshot);
              } else if (snapshot.hasError) {
                return Text("// ${snapshot.error} 에러");
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }

  Widget buildColumn(snapshot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('USER ID : ' + snapshot.data!.userId.toString(),
            style: TextStyle(fontSize: 20)),
        Text('ID : ' + snapshot.data!.id.toString(),
            style: TextStyle(fontSize: 20)),
        Text('TITLE : ' + snapshot.data!.title.toString(),
            style: TextStyle(fontSize: 20)),
        Text('BODY : ' + snapshot.data!.body.toString(),
            style: TextStyle(fontSize: 20)),
      ],
    );
  }
}

//참고자료 https://stackoverflow.com/questions/65630743/how-to-solve-flutter-web-api-cors-error-only-with-dart-code
