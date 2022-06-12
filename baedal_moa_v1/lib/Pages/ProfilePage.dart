import 'package:baedal_moa/Services/Services_Nickname.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kakao_flutter_sdk/all.dart';

import '../Model/AppUser.dart';
import '../Services/Services_User.dart';

class ProfilePage extends StatefulWidget {
  AppUser user;
  ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final nickName = TextEditingController();
  List<AppUser> _user = [];
  late String userNickName;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Services_User.getUsers(widget.user.userId.toString()).then((User1) {
      setState(() {
        _user = User1;
        userNickName = _user.first.userNickname;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _user.isEmpty
        ? Container(
            color: CupertinoColors.secondarySystemBackground,
            child: Center(child: Text("loading...")),
          )
        : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    "assets/images/user.png",
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  // margin: EdgeInsets.only(bottom: 8),
                  height: 0.3,
                  color: Colors.grey,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '닉네임 : ' + userNickName,
                        style: TextStyle(fontSize: 25),
                      ),
                      TextButton(
                          onPressed: () {
                            print("닉네임 변경");
                            nickName.text = '';
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  BuildContext firstContext = context;
                                  return AlertDialog(
                                    title: Text("닉네임 변경"),
                                    content: TextField(
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                      controller: nickName,
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            if (nickName.text.isEmpty) {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title:
                                                          Text("글자를 입력해주세요!"),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text(
                                                              "확인",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .deepOrange),
                                                            ))
                                                      ],
                                                    );
                                                  });
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          "닉네임을 변경하시겠습니까?"),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Services_Nickname
                                                                .changedNickname(
                                                                    widget.user
                                                                        .userId
                                                                        .toString(),
                                                                    nickName
                                                                        .text);
                                                            Services_User.getUsers(
                                                                    widget.user
                                                                        .userId
                                                                        .toString())
                                                                .then((User1) {
                                                              setState(() {
                                                                _user = User1;
                                                                userNickName = _user
                                                                    .first
                                                                    .userNickname;
                                                              });
                                                            });
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.pop(
                                                                firstContext);
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    "닉네임이 변경되었습니다.",
                                                                backgroundColor:
                                                                    Colors.grey,
                                                                gravity:
                                                                    ToastGravity
                                                                        .CENTER);
                                                          },
                                                          child: Text(
                                                            "확인",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .deepOrange),
                                                          ),
                                                        ),
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text(
                                                              '취소',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .deepOrange),
                                                            )),
                                                      ],
                                                    );
                                                  });
                                            }
                                          },
                                          child: Text(
                                            "변경하기",
                                            style: TextStyle(
                                                color: Colors.deepOrange),
                                          )),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            '취소',
                                            style: TextStyle(
                                                color: Colors.deepOrange),
                                          )),
                                    ],
                                  );
                                });
                          },
                          child: Text(
                            "닉네임 변경",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    '포인트 : ' + _user.first.userCash.toString(),
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ],
            ),
          );
  }
}
