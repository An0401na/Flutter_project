import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateRoomPage extends StatefulWidget {
  @override
  State<CreateRoomPage> createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
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
    print("방 제목 : " + member_count.toString());
    print("모집 인원 : " + time_count.toString());
    print("모집 시간 : " + room_title.text);
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          res_info,
          line,
          Container(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '방 정보 설정',
                  style: TextStyle(fontSize: 17),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Row(
                    children: [
                      Text('방 제목'),
                      Container(
                          margin: EdgeInsets.only(left: 40),
                          width: 142,
                          height: 20,
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            controller: room_title,
                          )) //Textfield넣어야 함
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
                padding: EdgeInsets.only(top: 20, left: 100, right: 100),
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
