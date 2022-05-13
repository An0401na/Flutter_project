import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'App.dart';

class GoogleMapPage extends StatefulWidget {
  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  List<Marker> myMarker = [];

  //현재 위치 받아오기
  double a = 37.3014;
  double b = 127.0348;

  getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position.latitude);
    print(position.longitude);
    a = position.latitude;
    b = position.longitude;
  }

  Future<void> postPosition(double lat, double lon) async {
    try {
      final _url = Uri.parse('http://203.249.22.50:8080/noa');
      http
          .post(_url, headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded',
          }, body: {
            "latitude": lat.toString(),
            "longitude": lon.toString()
          })
          .then((res) => print(json.decode(res.body.toString())))
          .catchError((e) => print(e.toString()));
    } catch (error) {
      print('에러' + error.toString());
    }
  }

  @override
  void initState() {
    getLocation();
    super.initState();
    myMarker.add(Marker(markerId: MarkerId("first"), position: LatLng(a, b)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('배달 모아'),
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.deepOrange,
          titleTextStyle: TextStyle(
              color: Colors.white,
              letterSpacing: 3.0,
              fontSize: 20.0,
              fontWeight: FontWeight.bold),
          elevation: 1,
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 3,
                          style: BorderStyle.solid,
                          color: Colors.deepOrange)),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  child: GoogleMap(
                    initialCameraPosition:
                        CameraPosition(target: LatLng(a, b), zoom: 17.0),
                    markers: Set.from(myMarker),
                    onTap: _handleTap,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 230,
              child: CupertinoButton(
                child: Text(
                  '이 위치로 설정하기',
                  style: TextStyle(fontSize: 13, color: Colors.white),
                ),
                color: Colors.deepOrange,
                onPressed: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => App(),
                      ))
                },
              ),
            )
          ],
        ));
  }

  _handleTap(LatLng tappedPoint) {
    double lat = tappedPoint.latitude;
    double lon = tappedPoint.longitude;
    print(lat);
    print(lon);
    postPosition(lat, lon);

    setState(() {
      myMarker = [];
      myMarker.add(Marker(
        markerId: MarkerId(tappedPoint.toString()),
        position: tappedPoint,
      ));
    });
  }
}
