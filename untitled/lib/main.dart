import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: MapSample(),
      ),
    ),
  );
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  List<Marker> myMarker = [];
  double la = 0.0;
  double lo = 0.0;
  String add = "";

  void fetchData() async {
    final response = await http.get(Uri.parse('http://203.249.22.49:8000'));

    String jsonData = response.body;
    List list = jsonDecode(jsonData);
    la = list[0]['lantitude'];
    lo = list[0]['longitude'];

    final placeMarks = await placemarkFromCoordinates(
      la,
      lo,
    );
    print(placeMarks[0].country);
    print(placeMarks[0].administrativeArea);
    print(placeMarks[0].locality);
    print(placeMarks[0].subLocality);
    print(placeMarks[0].thoroughfare);
    print(placeMarks[0].postalCode);

    add = ("${placeMarks[0].country}, ${placeMarks[0].administrativeArea}, "
        "${placeMarks[0].locality}, ${placeMarks[0].subLocality}, "
        "${placeMarks[0].thoroughfare}, ${placeMarks[0].postalCode}");

    print(add);
    setState(() {
      myMarker = [];
      myMarker.add(
        Marker(markerId: MarkerId(add), position: LatLng(la, lo)),
      );
    });
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(myMarker[0].markerId.toString()),
        ),
        body: GoogleMap(
          initialCameraPosition:
              CameraPosition(target: myMarker[0].position, zoom: 14.0),
          markers: Set.from(myMarker),
        ));
  }
}
