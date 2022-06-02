import 'dart:async';

import 'package:baedal_moa/Pages/App.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Model/Room.dart';
import 'Pages/KakaoLoginPage.dart';
import 'Pages/GoogleMapPage.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'Pages/RoomInfo.dart';
import 'Services/Services_Room.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays(
      [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  KakaoContext.clientId = "259973fec2ab30fe979de7a40850c394";
  runApp(Baedal_Moa());
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Image.asset(
        'assets/logo.png',
        width: MediaQuery.of(context).size.width * 0.7,
      )),
    );
  }
}

class Baedal_Moa extends StatefulWidget {
  @override
  State<Baedal_Moa> createState() => _Baedal_MoaState();
}

class _Baedal_MoaState extends State<Baedal_Moa> {
  late final int userId;
  late final String curLoc;
  late final bool isInRoom;
  late final int roomId;

  bool isHost = false;

  late Room room;
  late Future<StatefulWidget> future;

  @override
  initState() {
    super.initState();

    future = getSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<StatefulWidget>(
        future: future,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("splash");
            return MaterialApp(home: Splash());
          } else if (snapshot.hasData) {
            print("app");
            return MaterialApp(
                title: 'Baedal_Moa',
                theme: ThemeData(
                    appBarTheme: AppBarTheme(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.deepOrange,
                        titleTextStyle: TextStyle(color: Colors.black))),
                home: snapshot.data);
          } else if (snapshot.hasError) {
            return MaterialApp(
              home: Scaffold(
                body: Center(
                  child: Text("loading..."),
                ),
              )
              // Text(snapshot.error.toString())
              ,
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Future<StatefulWidget> getSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId') ?? -1;
    curLoc = prefs.getString('curLoc') ?? '';
    isInRoom = prefs.getBool('isInRoom') ?? false;
    roomId = prefs.getInt('roomId') ?? -1;

    print(userId);
    if (userId == -1) {
      return KakaoLoginPage();
    }
    if (curLoc == '') {
      return GoogleMapPage(userId: userId);
    }
    if (isInRoom) {
      print("방");
      final Room1 = await Services_Room.getRooms(userId.toString());
      List<Room> roomList = Room1;
      room.roomIsActive = 0;
      for (Room r in roomList) {
        if (r.roomId == roomId) {
          room = r;
          break;
        }
      }
      if (userId == room.hostUserId) {
        print("방장");
        isHost = true;
      } else {
        print("멤버");
      }
      if (room.roomIsActive == 1) {
        prefs.setBool('isInRoom', false);
        prefs.remove('roomId');
        return Room_info(isHost: isHost, room: room, userId: userId);
      }
    }
    return App(
      userId: userId,
      curLoc: curLoc,
      curPageIndex: 0,
    );
  }
}
