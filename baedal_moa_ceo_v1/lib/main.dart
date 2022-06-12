import 'package:baedal_moa_ceo_v1/Pages/App.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  runApp(Baedal_Moa_CEO());
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

class Baedal_Moa_CEO extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(Duration(seconds: 3)),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(home: Splash());
          } else {
            print("splash");
            return MaterialApp(
                title: 'Baedal_Moa',
                theme: ThemeData(
                    appBarTheme: AppBarTheme(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.deepOrange,
                        titleTextStyle: TextStyle(color: Colors.black))),
                home: App());
          }
        });
  }
}
