import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'KakaoLoginPage.dart';

void main() {
  KakaoContext.clientId = "259973fec2ab30fe979de7a40850c394";
  runApp(DamosaLoginApp());
}

class DamosaLoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Damosa Login App',
      home: KakaoLoginPage(),
    );
  }
}
