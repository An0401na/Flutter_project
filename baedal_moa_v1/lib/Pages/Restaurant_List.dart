import 'dart:convert';

import 'package:baedal_moa/Model/User.dart';
import 'package:flutter/material.dart';
import '../Model/Res.dart';
import '../Services/Services_Res.dart';
import '../Services/Services_User.dart';
import 'Restaurant_info.dart';

//가게 목록 페이지
class Restaurant_List extends StatefulWidget {
  late int userId;

  Restaurant_List({Key? key, required this.userId}) : super(key: key);
  @override
  _Restaurant_ListState createState() => _Restaurant_ListState();
}

class _Restaurant_ListState extends State<Restaurant_List> {
  @override
  late List<Res> _res = [];
  late bool _loading;

  @override
  void initState() {
    super.initState();
    _loading = true;

    Services_Res.getRests().then((Res1) {
      setState(() {
        _res = Res1;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) {
        return Container(height: 1, color: Colors.grey);
      },
      itemCount: _res.length,
      itemBuilder: (context, index) {
        Res res = _res[index];
        return ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Restaurant_info(res: res, userId: widget.userId),
                ));
          },
          title: Row(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.memory(
                base64Decode(utf8.decode(res.resImageDir.data)),
                width: 100,
                height: 100,
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      res.resName,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text(
                      "최소 주문 금액 : " + res.resMinOrderPrice.toString() + "원",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      "배달 요금 : " +
                          res.deliveryFees[0].delFee.toString() +
                          "~" +
                          res.deliveryFees.last.delFee.toString() +
                          " 원",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: 65,
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: 22,
                    child: IconButton(
                      padding: const EdgeInsets.all(0),
                      constraints: BoxConstraints(),
                      onPressed: () {
                        print("찜하기");
                      },
                      icon: Icon(
                        Icons.favorite_border,
                        color: Colors.deepOrange,
                      ),
                      iconSize: 25,
                    ),
                  ),
                  Container(
                    height: 63,
                    child: IconButton(
                        padding: const EdgeInsets.all(0),
                        constraints: BoxConstraints(),
                        onPressed: () {
                          print("위치보기");
                        },
                        icon: Icon(
                          Icons.map_outlined,
                          color: Colors.deepOrange,
                        ),
                        iconSize: 60),
                  ),
                ],
              ),
            )
          ]),
        );
      },
    );
  }
}
