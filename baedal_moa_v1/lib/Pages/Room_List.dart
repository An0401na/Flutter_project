import 'package:baedal_moa/Pages/Restaurant_info.dart';
import 'package:baedal_moa/Services/Services_User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

import '../Model/Room.dart';
import '../Model/User.dart';
import '../Services/Services_Room.dart';
import 'Room_info.dart';
import 'dart:async';
import 'dart:core';

class Room_List extends StatefulWidget {
  int userId;
  Room_List({Key? key, required this.userId}) : super(key: key);

  @override
  _Room_ListState createState() => _Room_ListState();
}

class _Room_ListState extends State<Room_List> {
  @override
  late List<Room> _room = [];
  late Timer timer;
  DateTime curTime = DateTime.now();
  late String locStr;
  List<Marker> myMarker = [];
  // late List<User> user = [];

  void initState() {
    super.initState();
    Services_Room.getRooms(widget.userId.toString()).then((Room1) {
      setState(() {
        _room = Room1;
      });
    });
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        curTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  void getLocation(Room room) async {
    double lat = double.parse(room.roomLocationX);
    double lon = double.parse(room.roomLocationY);
    setState(() {
      if (myMarker.isNotEmpty) myMarker.clear();
      myMarker.add(Marker(markerId: MarkerId(""), position: LatLng(lat, lon)));
    });

    final placeMarks =
        await placemarkFromCoordinates(lat, lon, localeIdentifier: "ko_KR");
    setState(() {
      locStr = ("${placeMarks.first.street}");
      print("LocStr : " + locStr);
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
          Flexible(
            fit: FlexFit.tight,
            child: Container(
              color: CupertinoColors.extraLightBackgroundGray,
              child: ListView.separated(
                itemCount: _room.length,
                itemBuilder: (context, index) {
                  Room room = _room[index];
                  int timeRest =
                      room.roomExpireTime.difference(curTime).inSeconds;
                  return Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.deepOrange),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    margin: EdgeInsets.only(
                        left: 10,
                        right: 10,
                        top: index == 0 ? 10 : 5,
                        bottom: index == _room.length - 1 ? 10 : 5),
                    child: ListTile(
                      title: Row(children: [
                        Flexible(
                          fit: FlexFit.tight,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  room.resId,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  room.roomName,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  room.hostUserId,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                                SizedBox(height: 5),
                              ]),
                        ),
                        Container(
                          width: 70,
                          padding: const EdgeInsets.all(5),
                          child: IconButton(
                              padding: const EdgeInsets.all(0),
                              constraints: BoxConstraints(),
                              onPressed: () {
                                print("방 배달 받을 주소 보기");
                                getLocation(room);
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Padding(
                                                padding:
                                                    EdgeInsets.only(bottom: 20),
                                                child: Text(
                                                  "음식 받는 위치",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                            Container(
                                                color: Colors.deepOrange,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                padding:
                                                    const EdgeInsets.all(3),
                                                child: Container(
                                                    color: Colors.white,
                                                    child: myMarker.isEmpty
                                                        ? const Center(
                                                            child: Text(
                                                                "loading map..."))
                                                        : GoogleMap(
                                                            initialCameraPosition:
                                                                CameraPosition(
                                                                    target: myMarker
                                                                        .first
                                                                        .position,
                                                                    zoom: 18.0),
                                                            markers: Set.from(
                                                                myMarker),
                                                          ))),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(top: 20),
                                                child: Text(
                                                  locStr,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ))
                                          ],
                                        ),
                                      );
                                    });
                              },
                              icon: Icon(
                                Icons.map_outlined,
                                color: Colors.deepOrange,
                              ),
                              iconSize: 60),
                        )
                      ]),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            color: CupertinoColors.secondarySystemBackground,
                            child: Text(
                                timeRest > 0
                                    ? (timeRest / 60).toInt() > 0
                                        ? (timeRest / 60).toInt().toString() +
                                            "분 남음"
                                        : (timeRest % 60).toInt().toString() +
                                            "초 남음"
                                    : "시간 만료",
                                style: TextStyle(fontSize: 16)),
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            color: CupertinoColors.secondarySystemBackground,
                            child: Text(
                                room.roomUser.length.toString() +
                                    " / " +
                                    room.roomMaxPeople.toString(),
                                style: TextStyle(fontSize: 16)),
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            color: CupertinoColors.secondarySystemBackground,
                            child: Text(
                                "인당 배달비 : " +
                                    (room.roomDelFee / room.roomUser.length)
                                        .ceil()
                                        .toInt()
                                        .toString() +
                                    "원",
                                style: TextStyle(fontSize: 16)),
                          ),
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
                                  room.roomName.toString() +
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
                                      style:
                                          TextStyle(color: Colors.deepOrange),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Room_info(
                                                    room: room,
                                                  )));
                                    })
                              ],
                            );
                          },
                        );
                      },
                    ),
                  );
                },
                separatorBuilder: (BuildContext _context, int index) {
                  return Container();
                },
              ),
            ),
          ),
        ],
      );
    }
  }
}
