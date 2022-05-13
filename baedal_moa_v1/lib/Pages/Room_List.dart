//안쓰임

import 'dart:convert';

import 'package:flutter/material.dart';

import '../Model/Room.dart';
import '../Services/Services_Room.dart';
import 'Room_info.dart';

class Room_List extends StatefulWidget {
  Room_List() : super();

  @override
  _Room_ListState createState() => _Room_ListState();
}

class _Room_ListState extends State<Room_List> {
  @override
  late List<Room> _room = [];

  void initState() {
    super.initState();
    Services_Room.getRooms().then((Room1) {
      setState(() {
        _room = Room1;
      });
    });
  }

  Widget build(BuildContext context) {
    if (_room.isEmpty) {
      return Center(child: Text("현재 주변에 방이 없습니다.."));
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "내 근처 모집 중인 먹친방",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: 1,
            color: Colors.deepOrange,
          ),
          Expanded(
            child: ListView.separated(
              itemCount: _room.length,
              itemBuilder: (context, index) {
                Room room = _room[index];
                return ListTile(
                  title: Row(children: [
                    SizedBox(
                      width: 300,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              room.roomName.toString(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            SizedBox(height: 5),
                            Text(
                              room.roomInfo.toString(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 16),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                room.hostUserId.toString(),
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ),
                          ]),
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 22,
                            child: IconButton(
                              padding: const EdgeInsets.all(0),
                              constraints: BoxConstraints(),
                              onPressed: () {
                                print("찜하기");
                              },
                              icon: Icon(
                                Icons.favorite_border,
                                color: Colors.deepOrange,
                              ),
                              iconSize: 25,
                            ),
                          ),
                          SizedBox(
                            height: 63,
                            child: IconButton(
                                padding: const EdgeInsets.all(0),
                                constraints: BoxConstraints(),
                                onPressed: () {
                                  print("위치보기");
                                },
                                icon: Icon(
                                  Icons.map_outlined,
                                  color: Colors.deepOrange,
                                ),
                                iconSize: 60),
                          ),
                        ],
                      ),
                    )
                  ]),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(room.roomExpireTime.toString(),
                          style: TextStyle(fontSize: 16)),
                      SizedBox(width: 30),
                      Text(room.roomOrderPrice.toString(),
                          style: TextStyle(fontSize: 16)),
                      SizedBox(width: 30),
                      Text(room.roomOrderPrice.toString(),
                          style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  onTap: () {
                    print("참여하기");
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        // return object of type Dialog
                        return AlertDialog(
                          title: Text("<" +
                              room.roomInfo.toString() +
                              "> 방에 참여하시겠습니까?"),
                          actions: <Widget>[
                            TextButton(
                              child: const Text(
                                "취소",
                                style: TextStyle(color: Colors.deepOrange),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                                child: const Text(
                                  "확인",
                                  style: TextStyle(color: Colors.deepOrange),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  Services_Room.postRoom(
                                      room.roomId.toString());
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Room_info(room: room),
                                      ));
                                })
                          ],
                        );
                      },
                    );
                  },
                );
              },
              separatorBuilder: (BuildContext _context, int index) {
                return Container(height: 1, color: Colors.deepOrange);
              },
            ),
          ),
        ],
      );
    }
  }
}
