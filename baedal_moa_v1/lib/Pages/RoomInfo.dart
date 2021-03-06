import 'dart:async';
import 'dart:convert';

import 'package:baedal_moa/Services/Services_Room.dart';
import 'package:baedal_moa/Services/Services_ShoppingCart.dart';
import 'package:baedal_moa/Services/Services_User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/AppUser.dart';
import '../Model/Room.dart';
import 'App.dart';

class Room_info extends StatefulWidget {
  late Room room;
  late int userId;
  bool isHost;

  Room_info({required this.isHost, required this.room, required this.userId});

  @override
  State<Room_info> createState() => _Room_infoState();
}

class _Room_infoState extends State<Room_info> {
  late String locStr;
  late List<AppUser> userList;
  late List<Room> roomList;
  late Room _room;
  late String userLoc;
  late Timer timer;
  late int timeRest;
  bool loading = false;
  DateTime curTime = DateTime.now();
  List<Marker> myMarker = [];
  int roomTotalMenuPrice = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
    Services_User.getUsers(widget.userId.toString()).then((User1) {
      setState(() {
        userList = User1;
      });
    });
    Services_Room.getRooms(widget.userId.toString()).then((Room1) {
      setState(() {
        roomList = Room1;
        for (Room r in roomList) {
          if (r.roomId == widget.room.roomId) _room = r;
        }
        setSharedPrefs(true, _room.roomId);
        loading = true;
      });
    });
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        curTime = DateTime.now();
        Services_Room.getRooms(widget.userId.toString()).then((Room1) {
          setState(() {
            roomList = Room1;
            _room.roomIsActive = 0;
            for (Room r in roomList) {
              if (r.roomId == widget.room.roomId) {
                _room = r;
                break;
              }
            }
            print("??? ????????? ??????:" + _room.roomIsActive.toString());
            if (_room.roomIsActive == 0) {
              timer.cancel();
              getUserLocation();
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("????????? ?????????????????????!"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              timer.cancel();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => App(
                                      userId: widget.userId,
                                      curLoc: userLoc,
                                      curPageIndex: 3,
                                    ),
                                  ));
                            },
                            child: Text(
                              "??????",
                              style: TextStyle(color: Colors.deepOrange),
                            )),
                      ],
                    );
                  });
            }
          });
        });
        if (timeRest < 0) {
          timer.cancel();
          setSharedPrefs(false, -1);
          getUserLocation();
          if (roomTotalMenuPrice < _room.res.resMinOrderPrice) {
            Services_Room.outRoom(
                widget.room.roomId.toString(), widget.userId.toString());
            // // DB??? ?????? ????????? ?????? ??????
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("?????? ?????? ?????? ????????? ????????? ?????????????????????..."),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => App(
                                    userId: widget.userId,
                                    curLoc: userLoc,
                                    curPageIndex: 0,
                                  ),
                                ));
                          },
                          child: Text(
                            "??????",
                            style: TextStyle(color: Colors.deepOrange),
                          )),
                    ],
                  );
                });
          } else {
            timer.cancel();
            if (widget.isHost) Services_Room.expireRoom(widget.room);
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("????????? ?????????????????????!"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => App(
                                    userId: widget.userId,
                                    curLoc: userLoc,
                                    curPageIndex: 3,
                                  ),
                                ));
                          },
                          child: Text(
                            "??????",
                            style: TextStyle(color: Colors.deepOrange),
                          )),
                    ],
                  );
                });
          }
        }
      });
    });
  }

  void dispose() {
    super.dispose();
    timer.cancel();
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

  getUserLocation() async {
    double lat = double.parse(userList[0].userLocationX);
    double lon = double.parse(userList[0].userLocationY);

    final placeMarks =
        await placemarkFromCoordinates(lat, lon, localeIdentifier: "ko_KR");
    userLoc = "${placeMarks[0].thoroughfare} ${placeMarks[0].subThoroughfare}";
  }

  MemberList() {
    roomTotalMenuPrice = 0;
    List<int> temp = [];
    for (List<RoomMemberMenu> rMML in _room.roomMemberMenus) {
      int tmp = 0;
      for (RoomMemberMenu rMM in rMML) {
        tmp += rMM.menuCount * rMM.menuPrice;
      }
      temp.add(tmp);
      roomTotalMenuPrice += tmp;
    }
    return Column(
      children: [
        for (int i = 0; i < _room.roomUser.length; i++)
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.deepOrange),
                color: CupertinoColors.secondarySystemBackground),
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/user.png",
                        width: 50,
                        height: 50,
                      ),
                      Text(
                        _room.roomUser[i].userNickname,
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  Text(
                    "?????? ?????? : " + temp[i].toString() + " ??? ",
                    style: TextStyle(fontSize: 20),
                  )
                ]),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return !loading
        ? Center(
            child: Container(child: Text('loading...')),
          )
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Center(child: Text(widget.room.roomName)),
              elevation: 1,
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: WillPopScope(
                    onWillPop: onBackKey,
                    child: Column(
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
                                    '?????? ??????',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    widget.room.res.resName,
                                    style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w600),
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
                                      const Text(
                                        '?????? ??????',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        widget.room.res.resMinOrderPrice
                                                .toString() +
                                            ' ???',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        '?????? ??????',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Text(
                                          widget.room.res.resLocation,
                                          style: TextStyle(fontSize: 15),
                                          overflow: TextOverflow.visible,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  )
                                ],
                              )
                            ],
                          ),
                        ), //?????? ??????
                        Container(
                          color: CupertinoColors.secondarySystemBackground,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, left: 10.0),
                                child: Text(
                                  '?????? ?????? ???',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(20),
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 20),
                                          child: Text(
                                            (myMarker.isEmpty
                                                ? 'loading map...'
                                                : locStr),
                                            style: TextStyle(fontSize: 20),
                                            overflow: TextOverflow.visible,
                                          )),
                                      Container(
                                          color: Colors.deepOrange,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          padding: const EdgeInsets.all(3),
                                          child: Container(
                                              color: Colors.white,
                                              child: myMarker.isEmpty
                                                  ? const Center(
                                                      child: Text(
                                                          "loading map..."))
                                                  : GoogleMap(
                                                      initialCameraPosition:
                                                          CameraPosition(
                                                              target:
                                                                  myMarker[0]
                                                                      .position,
                                                              zoom: 18.0),
                                                      markers:
                                                          Set.from(myMarker),
                                                    ))),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: const Text('?????? ??????'),
                                      ),
                                      Text(
                                        widget.room.address,
                                        style: TextStyle(fontSize: 20),
                                        overflow: TextOverflow.visible,
                                      )
                                      // Text(
                                      //   (myMarker.isEmpty
                                      //       ? 'loading map...'
                                      //       : locStr),
                                      //   style: TextStyle(fontSize: 20),
                                      //   overflow: TextOverflow.visible,
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(
                              top: 10, left: 10.0, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '?????? ??????',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                '?????? ??? ?????? ?????? : ' +
                                    roomTotalMenuPrice.toString() +
                                    ' ???',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                        MemberList(),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.deepOrange,
                              width: 1,
                              style: BorderStyle.solid)),
                      child: Center(
                        child: Text(
                          (timeRest = widget.room.roomExpireTime
                                      .difference(curTime)
                                      .inSeconds) >
                                  0
                              ? (timeRest / 60).toInt().toString() +
                                  " : " +
                                  (timeRest % 60).toInt().toString()
                              : "?????? ??????",
                          style: TextStyle(fontSize: 20),
                        ),
                      )),
                )
              ],
              // child:
            ),
            bottomNavigationBar: BottomAppBar(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    widget.isHost
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.deepOrange,
                                  fixedSize: Size(
                                      MediaQuery.of(context).size.width * 0.8,
                                      50)),
                              child: const Text(
                                '????????? ????????????',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () {
                                print("?????? ???????????? ??????");
                                if (roomTotalMenuPrice <
                                    _room.res.resMinOrderPrice) {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("?????? ?????? ????????? ??????????????????!"),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context, false);
                                                },
                                                child: Text(
                                                  "??????",
                                                  style: TextStyle(
                                                      color: Colors.deepOrange),
                                                )),
                                          ],
                                        );
                                      });
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("????????? ?????? ???????????????????"),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  getUserLocation();
                                                  //?????? ?????????
                                                  if (widget.isHost)
                                                    Services_Room.expireRoom(
                                                        widget.room);
                                                  Navigator.pop(context, false);
                                                  showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              "????????? ?????????????????????!"),
                                                          actions: [
                                                            TextButton(
                                                                onPressed: () {
                                                                  timer
                                                                      .cancel();
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                App(
                                                                          userId:
                                                                              widget.userId,
                                                                          curLoc:
                                                                              userLoc,
                                                                          curPageIndex:
                                                                              3,
                                                                        ),
                                                                      ));
                                                                },
                                                                child: Text(
                                                                  "??????",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .deepOrange),
                                                                )),
                                                          ],
                                                        );
                                                      });
                                                },
                                                child: Text(
                                                  "??????",
                                                  style: TextStyle(
                                                      color: Colors.deepOrange),
                                                )),
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context, false);
                                                },
                                                child: Text(
                                                  "??????",
                                                  style: TextStyle(
                                                      color: Colors.deepOrange),
                                                )),
                                          ],
                                        );
                                      });
                                }
                              },
                            ),
                          )
                        : Container(),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1,
                                  style: BorderStyle.solid,
                                  color: Colors.deepOrange)),
                          child: Container(
                            padding: EdgeInsets.all(1),
                            color: Colors.deepOrange,
                            child: Container(
                              padding: EdgeInsets.only(
                                  top: 8, bottom: 8, left: 2, right: 2),
                              color: Colors.white,
                              child: Row(
                                children: [
                                  Text("?????? ?????? ?????????"),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    (_room.roomDelFee / _room.roomUser.length)
                                        .ceil()
                                        .toInt()
                                        .toString(),
                                    style: TextStyle(color: Colors.deepOrange),
                                  ),
                                  Text("???"),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                            child: Container(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("?????? ??? ?????????"),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                userList[0].userCash.toString(),
                                style: TextStyle(color: Colors.deepOrange),
                              )
                            ],
                          ),
                        ))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Future<bool> onBackKey() async {
    getUserLocation();
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("?????? ??????????????????????"),
            actions: [
              TextButton(
                  onPressed: () {
                    setSharedPrefs(false, -1);
                    Services_Room.outRoom(widget.room.roomId.toString(),
                        widget.userId.toString());
                    // DB??? ?????? ????????? ?????? ??????
                    timer.cancel();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => App(
                            userId: widget.userId,
                            curLoc: userLoc,
                            curPageIndex: 0,
                          ),
                        ));
                  },
                  child: Text(
                    "??????",
                    style: TextStyle(color: Colors.deepOrange),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text(
                    "??????",
                    style: TextStyle(color: Colors.deepOrange),
                  )),
            ],
          );
        });
  }

  void setSharedPrefs(bool isInRoom, int roomId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isInRoom', isInRoom);
    prefs.setInt('roomId', roomId);
  }
}
