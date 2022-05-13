import 'package:flutter/material.dart';
import 'Services.dart';
import 'Users.dart';

class JsonParseDemo extends StatefulWidget {
  JsonParseDemo() : super();

  @override
  _JsonParseDemoState createState() => _JsonParseDemoState();
}

class _JsonParseDemoState extends State<JsonParseDemo> {
  late List<User> _users = [];
  late bool _loading;

  void initState() {
    super.initState();
    _loading = true;
    Services.getUsers().then((users) {
      setState(() {
        _users = users;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_loading ? 'Loading ... ' 'Json Parsing' : 'Users'),
        ),
        body: Container(
          color: Colors.white,
          child: ListView.builder(
              itemCount: null == _users ? 0 : _users.length,
              itemBuilder: (context, index) {
                User user = _users[index];
                return ListTile(
                  title: Text(user.id.toString()),
                  subtitle: Text(user.name),
                );
              }),
        ));
  }
}
