import 'dart:convert';

import 'package:baedal_moa/Model/ShoppingCart.dart';
import 'package:baedal_moa/Pages/RoomInfo.dart';
import 'package:baedal_moa/Services/Services_Res.dart';
import 'package:baedal_moa/Services/Services_Room.dart';
import 'package:baedal_moa/Services/Services_ShoppingCart.dart';
import 'package:baedal_moa/Services/Services_User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

import '../Model/Menu.dart';
import '../Model/Res.dart';
import '../Model/Room.dart';
import '../Model/AppUser.dart';

class CreateRoomPage extends StatefulWidget {
  Res res;
  int userId;
  ShoppingCart shoppingCart;

  CreateRoomPage(
      {required this.shoppingCart, required this.res, required this.userId});

  @override
  State<CreateRoomPage> createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  late List<AppUser> userList = [];
  late Room new_room;
  late String locStr = "";
  late DateTime curTime;

  int member_count = 2; //모집인원 저장하는 변수
  int time_count = 5; //모집시간 저장하는 변수
  final room_title = TextEditingController(); //TextField 사용하기 위한 변수
  final address = TextEditingController();
  // 방이름 정보 -> room_title.text에 저장됨

  List<Marker> myMarker = [];

  double lat = 0;
  double lon = 0;

  getLocation() async {
    List<AppUser> User1 =
        await Services_User.getUsers(widget.userId.toString());
    userList = User1;
    // Position position = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.high);
    lat = double.parse(userList[0].userLocationX);
    lon = double.parse(userList[0].userLocationY);
    setState(() {
      myMarker
          .add(Marker(markerId: MarkerId("first"), position: LatLng(lat, lon)));
    });
    getLocStr();
  }

  getLocStr() async {
    final placeMarks =
        await placemarkFromCoordinates(lat, lon, localeIdentifier: "ko_KR");
    setState(() {
      locStr = ("${placeMarks[0].street}");
      print("LocStr : " + locStr);
    });
  }

  _handleTap(LatLng tappedPoint) {
    lat = tappedPoint.latitude;
    lon = tappedPoint.longitude;
    getLocStr();
    setState(() {
      myMarker = [];
      myMarker.add(Marker(
        markerId: MarkerId(tappedPoint.toString()),
        position: tappedPoint,
      ));
    });
  }

  @override
  void initState() {
    super.initState();

    new_room = Room(
        roomId: 0,
        roomName: '',
        resId: 0,
        hostUserId: 0,
        roomMaxPeople: 0,
        roomExpireTime: DateTime.now(),
        roomStartTime: DateTime.now(),
        roomLocationX: "0",
        roomLocationY: "0",
        roomOrderPrice: 0,
        roomDelFee: 0,
        roomIsActive: 0,
        roomMemberMenus: [],
        roomUser: [],
        res: RoomRes(
            resId: 0, resName: '', resLocation: '', resMinOrderPrice: 0),
        address: "");

    getLocation();
  }

  void _plus() {
    if (member_count < 5) {
      setState(() {
        member_count++;
      });
    }
  }

  void _minus() {
    if (member_count > 2) {
      setState(() {
        member_count--;
      });
    }
  }

  void time_plus() {
    if (time_count < 30) {
      setState(() {
        time_count = time_count + 5;
      });
    }
  }

  void time_minus() {
    if (time_count > 5) {
      setState(() {
        time_count = time_count - 5;
      });
    }
  }

  void createRoomButtonPressed() {
    curTime = DateTime.now();
    new_room.roomName = room_title.text;
    new_room.resId = widget.res.resId;
    new_room.hostUserId = widget.userId;
    new_room.roomMaxPeople = member_count;
    new_room.roomStartTime = curTime;
    new_room.roomExpireTime = curTime.add(Duration(minutes: time_count));
    new_room.roomLocationX = myMarker[0].position.latitude.toString();
    new_room.roomLocationY = myMarker[0].position.longitude.toString();
    new_room.roomOrderPrice = widget.shoppingCart.totalPrice;
    new_room.roomDelFee = widget.res.deliveryFees.last.delFee;
    List<RoomMemberMenu> rMM = [];
    for (Menu m in widget.shoppingCart.menus) {
      rMM.add(RoomMemberMenu(
          userId: widget.userId,
          menuId: m.menuId,
          menuPrice: m.menuPrice,
          menuCount: widget.shoppingCart.menusCnt[m.menuName]!));
    }
    new_room.roomMemberMenus.add(rMM);
    new_room.roomUser.add(RoomUser(
        userId: widget.userId,
        userNickname: userList[0].userNickname,
        userLocationX: userList[0].userLocationX,
        userLocationY: userList[0].userLocationY,
        userCash: userList[0].userCash));
    new_room.res = RoomRes(
        resName: widget.res.resName,
        resLocation: widget.res.resLocation,
        resMinOrderPrice: widget.res.resMinOrderPrice,
        resId: widget.res.resId);
    new_room.address = address.text;

    Services_Room.postRoom(new_room).then((tmp) {
      setState(() {
        new_room.roomId = tmp;
        print("방 이름 : " + new_room.roomName);
        print("가게 번호 : " + new_room.resId.toString());
        print("모집 인원 : " + new_room.roomMaxPeople.toString());
        print("모집 시작 시간 : " + new_room.roomStartTime.toString());
        print("모집 마감 시간 : " + new_room.roomExpireTime.toString());
        print("금액 : " + new_room.roomOrderPrice.toString());
        print("배달비 : " + new_room.roomDelFee.toString());
        print("음식 받을 곳(위도) : " + myMarker[0].position.latitude.toString());
        print("음식 받을 곳(경도) : " + myMarker[0].position.longitude.toString());
        print("인원 : " + jsonEncode(new_room.roomUser));
        print("메뉴 : " + jsonEncode(new_room.roomMemberMenus));
        print("세부주소 : " + new_room.address);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Room_info(
                room: new_room,
                userId: widget.userId,
                isHost: true,
              ),
            ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(left: 10, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '가게 정보',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.res.resName,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('최소 주문'),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(widget.res.resMinOrderPrice.toString() + ' 원'),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('배달 요금'),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            widget.res.deliveryFees[0].delFee.toString() +
                                ' ~ ' +
                                widget.res.deliveryFees.last.delFee.toString() +
                                ' 원',
                            style: const TextStyle(color: Colors.deepOrange),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('가게 위치'),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              widget.res.resLocation,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ), //가게 정보
            line,
            Container(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      '방 정보 설정',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: Text('방 제목'),
                        ),
                        Expanded(
                            child: TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          controller: room_title, //Textfield넣어야 함
                        )),
                        const SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Text('모집 인원(명)'),
                      Row(
                        children: [
                          IconButton(
                            splashRadius: 10,
                            icon: Icon(Icons.remove),
                            iconSize: 20,
                            onPressed: _minus,
                          ),
                          Text(
                            '$member_count',
                            style: TextStyle(fontSize: 15),
                          ),
                          IconButton(
                            splashRadius: 10,
                            icon: Icon(Icons.add),
                            iconSize: 20,
                            onPressed: _plus,
                          ),
                        ],
                      ),
                      Text('(최대 5명)'),
                    ],
                  ), //모집인원 +-버튼
                  Row(
                    children: [
                      Text('모집 시간(분)'),
                      Row(
                        children: [
                          IconButton(
                            splashRadius: 10,
                            icon: Icon(Icons.remove),
                            iconSize: 20,
                            onPressed: time_minus,
                          ),
                          Text(
                            '$time_count',
                            style: TextStyle(fontSize: 15),
                          ),
                          IconButton(
                            splashRadius: 10,
                            icon: Icon(Icons.add),
                            iconSize: 20,
                            onPressed: time_plus,
                          ),
                        ],
                      ),
                      Text('(최대 30분)'),
                    ],
                  ),
                ],
              ),
            ), //TextField 사용 -> 방제목 입력
            // 모집시간 +-버튼 ->5분 단위로 설정함
            line,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, bottom: 10),
                  child: Text(
                    '음식 받을 곳',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  color: CupertinoColors.extraLightBackgroundGray,
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Text(
                            '주소 : ' +
                                (myMarker.isEmpty ? 'loading map...' : locStr),
                            style: TextStyle(fontSize: 15),
                            overflow: TextOverflow.visible,
                          ),
                        ),
                        Container(
                            color: Colors.deepOrange,
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: MediaQuery.of(context).size.width * 0.8,
                            padding: const EdgeInsets.all(3),
                            child: Container(
                                color: Colors.white,
                                child: myMarker.isEmpty
                                    ? const Center(
                                        child: Text("loading map..."))
                                    : GoogleMap(
                                        gestureRecognizers: <
                                            Factory<
                                                OneSequenceGestureRecognizer>>[
                                          new Factory<
                                              OneSequenceGestureRecognizer>(
                                            () => new EagerGestureRecognizer(),
                                          ),
                                        ].toSet(),
                                        initialCameraPosition: CameraPosition(
                                            target: myMarker.first.position,
                                            zoom: 18.0),
                                        markers: Set.from(myMarker),
                                        onTap: _handleTap,
                                      ))),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: const Text('세부 주소 입력'),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            controller: address, //Textfield넣어야 함
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ), //음식 받을곳 (구글맵 연동)
            Container(
              padding: const EdgeInsets.only(
                  top: 10, left: 100, right: 100, bottom: 10),
              width: double.infinity,
              child: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    minimumSize: Size(100, 40)),
                child: const Text(
                  '이대로 방 생성하기',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  if (room_title.text.isEmpty) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("방 제목을 입력해주세요!"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "확인",
                                    style: TextStyle(color: Colors.deepOrange),
                                  ))
                            ],
                          );
                        });
                  } else if (address.text.isEmpty) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("세부 주소를 입력해주세요!"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "확인",
                                    style: TextStyle(color: Colors.deepOrange),
                                  ))
                            ],
                          );
                        });
                  } else {
                    createRoomButtonPressed();
                  }
                },
              ),
            ) // 방 생성 버튼
          ],
        ),
      ),
    );
  }

  Widget line = Container(
    margin: EdgeInsets.only(top: 10, bottom: 10),
    height: 1,
    color: Colors.grey,
  );
}
