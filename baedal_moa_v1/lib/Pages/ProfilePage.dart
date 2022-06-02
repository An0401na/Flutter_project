import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Model/AppUser.dart';

class ProfilePage extends StatefulWidget {
  AppUser user;
  ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Image.asset(
            "assets/images/user.png",
            fit: BoxFit.fill,
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 8),
          height: 1,
          color: Colors.black,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '  닉네임 : ' + widget.user.userNickname,
            style: TextStyle(fontSize: 25),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '  포인트 : ' + widget.user.userCash.toString(),
            style: TextStyle(fontSize: 25),
          ),
        ),
      ],
    );
  }
}
