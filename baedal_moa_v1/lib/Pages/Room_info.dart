import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

import '../Model/Room.dart';

class Room_info extends StatefulWidget {
  late final Room room;

  Room_info({required this.room});

  @override
  State<Room_info> createState() => _Room_infoState();
}

class _Room_infoState extends State<Room_info> {
  late String locStr;
  List<Marker> myMarker = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
  }

  getLocation() async {
    double lat = double.parse(widget.room.roomLocationX);
    double lon = double.parse(widget.room.roomLocationY);
    setState(() {
      myMarker
          .add(Marker(markerId: MarkerId("first"), position: LatLng(lat, lon)));
    });

    final placeMarks =
        await placemarkFromCoordinates(lat, lon, localeIdentifier: "ko_KR");
    setState(() {
      locStr = ("${placeMarks[0].street}");
      print("LocStr : " + locStr);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text(widget.room.roomName)),
        elevation: 1,
      ),
      body: Column(
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
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "가게 이름",
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
                        const Text('최소주문'),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                            // widget.res.resMinOrderPrice.toString() +
                            ' 원'),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('배달요금'),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          // widget.res.deliveryFees.first.delFee.toString() +
                          //     ' ~ ' +
                          //     widget.res.deliveryFees.last.delFee.toString() +
                          ' 원',
                          style: const TextStyle(color: Colors.deepOrange),
                        ),
                      ],
                    ),
                    // Row(
                    //   children: const [
                    //     Text('배달시간'),
                    //     Text('  ' + '20분 ~ 30분'),
                    //   ],
                    // ),
                  ],
                )
              ],
            ),
          ), //가게 정보
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            height: 1,
            color: Colors.grey,
          ),
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
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '주소 : ',
                              style: TextStyle(fontSize: 15),
                            ),
                            myMarker.isEmpty
                                ? Text(
                                    'loading map...',
                                    style: TextStyle(fontSize: 15),
                                  )
                                : Text(
                                    locStr,
                                    style: TextStyle(fontSize: 15),
                                  )
                          ],
                        ),
                      ),
                      Container(
                          color: Colors.deepOrange,
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.width * 0.6,
                          padding: const EdgeInsets.all(3),
                          child: Container(
                              color: Colors.white,
                              child: myMarker.isEmpty
                                  ? const Center(child: Text("loading map..."))
                                  : GoogleMap(
                                      initialCameraPosition: CameraPosition(
                                          target: myMarker[0].position,
                                          zoom: 20.0),
                                      markers: Set.from(myMarker),
                                    ))),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 1,
            color: Colors.grey,
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 10.0, left: 10.0, bottom: 10),
            child: Text(
              '현재 멤버',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: ListView())
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.all(10),
          height: 70,
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 1,
                        style: BorderStyle.solid,
                        color: Colors.deepOrange)),
                child: Row(
                  children: [
                    Text("현재 인당 배달료"),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      (widget.room.roomOrderPrice / widget.room.roomUser.length)
                          .toInt()
                          .toString(),
                      style: TextStyle(color: Colors.deepOrange),
                    ),
                    Text(" 원"),
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                alignment: Alignment.centerRight,
                color: Colors.yellow,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("현재 내 포인트"),
                    SizedBox(
                      width: 5,
                    ),
                    Text('')
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
