import 'package:baedal_moa/Model/ShoppingCart.dart';
import 'package:baedal_moa/Services/Services_Res.dart';
import 'package:baedal_moa/Services/Services_Room.dart';
import 'package:baedal_moa/Services/Services_User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '';

import '../Model/Res.dart';
import '../Model/Room.dart';
import '../Model/User.dart';

class CreateRoomPage extends StatefulWidget {
  Res res;
  String userId;
  ShoppingCart shoppingCart;
  DateTime now = DateTime.now();
  // late Room new_room;

  CreateRoomPage(
      {required this.shoppingCart, required this.res, required this.userId});

  @override
  State<CreateRoomPage> createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  // late List<User> user = [];
  late User user;
  late Room new_room;

  int member_count = 0; //모집인원 저장하는 변수
  int time_count = 0; //모집시간 저장하는 변수
  final room_title = TextEditingController(); //TextField 사용하기 위한 변수
  // 방이름 정보 -> room_title.text에 저장됨

  List<Marker> myMarker = [];

  double lat = 0;
  double lon = 0;

  getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    lat = position.latitude;
    lon = position.longitude;
    setState(() {
      myMarker
          .add(Marker(markerId: MarkerId("first"), position: LatLng(lat, lon)));
    });
  }

  @override
  void initState() {
    super.initState();
    getLocation();
    print("aaaaa");
    new_room = Room(
        roomId: 0,
        roomName: 'a',
        resId: 'a',
        hostUserId: 'a',
        roomMaxPeople: 0,
        roomExpireTime: DateTime.now(),
        roomStartTime: DateTime.now(),
        roomLocationX: "0",
        roomLocationY: "0",
        roomOrderPrice: 0,
        roomDelFee: 0,
        roomIsActive: 0,
        roomUser: []);
    // Services_User.getUsers(widget.userId.toString()).then((User1) {
    //   setState(() {
    //     user = User1;
    //   });
    // });
  }

  void _plus() {
    setState(() {
      member_count++;
    });
  }

  void _minus() {
    setState(() {
      member_count--;
    });
  }

  void time_plus() {
    setState(() {
      time_count = time_count + 5;
      ;
    });
  }

  void time_minus() {
    setState(() {
      time_count = time_count - 5;
    });
  }

  void printn() {
    print(new_room.roomUser);
    new_room.roomId = 0; //db 들어가면 업데이트 됨
    new_room.roomName = room_title.text.toString();
    new_room.resId = widget.res.resId.toString();
    new_room.hostUserId = widget.userId.toString();
    new_room.roomMaxPeople = member_count.toInt();
    new_room.roomStartTime = widget.now;
    new_room.roomExpireTime = widget.now.add(Duration(minutes: time_count));
    new_room.roomLocationX = myMarker[0].position.latitude.toString();
    new_room.roomLocationY = myMarker[0].position.longitude.toString();
    new_room.roomOrderPrice = widget.shoppingCart.totalPrice;
    new_room.roomDelFee = widget.res.deliveryFees.last.delFee.toInt();
    new_room.roomIsActive = 1;
    // new_room.roomUser[0] = widget.userId;

    Services_Room.postRoom(new_room);

    print("방 번호 : " + new_room.roomId.toString());
    print("방 이름 : " + new_room.roomName);
    print("가게 번호 : " + new_room.resId);
    print("모집 인원 : " + new_room.roomMaxPeople.toString());
    print("모집 시작 시간 : " + new_room.roomStartTime.toString());
    print("모집 마감 시간 : " + new_room.roomExpireTime.toString());
    print("금액 : " + new_room.roomOrderPrice.toString());
    print("배달비 : " + new_room.roomDelFee.toString());
    print("음식 받을 곳(위도) : " + myMarker[0].position.latitude.toString());
    print("음식 받을 곳(경도) : " + myMarker[0].position.longitude.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            res_info,
            line,
            Container(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      '방 정보 설정',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: const Text('방 제목'),
                        ),
                        Expanded(
                            child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          controller: room_title,
                        )), //Textfield넣어야 함
                        SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ), //TextField 사용 -> 방제목 입력
            Container(
              padding: EdgeInsets.only(bottom: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('   모집인원 (명)'),
                  Container(
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 7),
                          child: IconButton(
                            icon: Icon(Icons.remove),
                            iconSize: 14,
                            onPressed: _minus,
                          ),
                          width: 40,
                          height: 25,
                          color: Colors.black12,
                        ),
                        Container(
                          width: 40,
                          height: 25,
                          child: Text('$member_count'),
                          margin: EdgeInsets.only(left: 10, right: 10),
                          padding: EdgeInsets.only(left: 15, top: 4),
                          decoration: BoxDecoration(
                            border: Border.all(),
                          ),
                        ),
                        Container(
                          child: IconButton(
                            icon: Icon(Icons.add),
                            iconSize: 14,
                            onPressed: _plus,
                          ),
                          width: 40,
                          height: 25,
                          color: Colors.black12,
                        ),
                      ],
                    ),
                  ),
                  Text('  (최대 5명 까지)'),
                ],
              ),
            ), //모집인원 +-버튼
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('   모집시간 (분)'),
                Container(
                  margin: EdgeInsets.only(left: 7),
                  child: Row(
                    children: [
                      Container(
                        child: IconButton(
                          icon: Icon(Icons.remove),
                          iconSize: 14,
                          onPressed: time_minus,
                        ),
                        width: 40,
                        height: 25,
                        color: Colors.black12,
                      ),
                      Container(
                        width: 40,
                        height: 25,
                        child: Text('$time_count'),
                        margin: EdgeInsets.only(left: 10, right: 10),
                        padding: EdgeInsets.only(left: 15, top: 4),
                        decoration: BoxDecoration(
                          border: Border.all(),
                        ),
                      ),
                      Container(
                        child: IconButton(
                          icon: Icon(Icons.add),
                          iconSize: 14,
                          onPressed: time_plus,
                        ),
                        width: 40,
                        height: 25,
                        color: Colors.black12,
                      ),
                    ],
                  ),
                ),
              ],
            ), // 모집시간 +-버튼 ->5분 단위로 설정함
            line,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, bottom: 10),
                  child: Text(
                    '음식 받을 곳',
                    style: TextStyle(fontSize: 17),
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
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Text(
                            '주소 : 경기도 수원시 연무동',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: MediaQuery.of(context).size.width * 0.8,
                            margin: EdgeInsets.only(right: 3),
                            child: Container(
                                child: myMarker.isEmpty
                                    ? Center(child: Text("loading map..."))
                                    : GoogleMap(
                                        initialCameraPosition: CameraPosition(
                                            target: myMarker[0].position,
                                            zoom: 20.0),
                                        markers: Set.from(myMarker),
                                        onTap: _handleTap,
                                      ))),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10, left: 100, right: 100),
                  width: double.infinity,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        minimumSize: Size(100, 40)),
                    child: Text(
                      '이대로 방 생성하기',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: printn,
                  ),
                )
              ],
            ), //구글맵 연동
          ],
        ),
      ),
    );
  }

  @override
  Widget line = Container(
    margin: EdgeInsets.only(top: 10, bottom: 10),
    height: 1,
    color: Colors.grey,
  );

  Widget res_info = Container(
    padding: EdgeInsets.only(left: 10, top: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '가게 정보',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                '롯데리아 연무점',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Row(
                  children: [
                    Text('최소주문'),
                    Text('  ' + '8,000원'),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Text('배달요금'),
                    Text(
                      '  ' + '무료 ~ 3,500원',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Text('배달시간'),
                    Text('  ' + '20분 ~ 30분'),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Text('가게거리'),
                    Text('  ' + '1.1km'),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    ),
  );

  _handleTap(LatLng tappedPoint) {
    double lai = tappedPoint.latitude;
    double loni = tappedPoint.longitude;

    setState(() {
      myMarker = [];
      myMarker.add(Marker(
        markerId: MarkerId(tappedPoint.toString()),
        position: tappedPoint,
      ));
    });
  }
}
