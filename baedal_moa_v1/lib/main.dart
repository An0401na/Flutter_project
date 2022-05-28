import 'dart:async';

import 'package:baedal_moa/Pages/App.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'Pages/KakaoLoginPage.dart';
import 'Pages/GoogleMapPage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays(
      [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  KakaoContext.clientId = "259973fec2ab30fe979de7a40850c394";
  runApp(Baedal_Moa());
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

class Baedal_Moa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(Duration(seconds: 2)),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(home: Splash());
          } else {
            return MaterialApp(
                title: 'Baedal_Moa',
                theme: ThemeData(
                    appBarTheme: AppBarTheme(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.deepOrange,
                        titleTextStyle: TextStyle(color: Colors.black))),
                home: KakaoLoginPage()
                // GoogleMapPage(
                // userId: 0,
                // )
                );
          }
        });
  }
}
