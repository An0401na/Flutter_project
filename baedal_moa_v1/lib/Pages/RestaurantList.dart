import 'dart:convert';
import 'dart:typed_data';

import 'package:baedal_moa/Model/AppUser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Model/Res.dart';
import '../Services/Services_Res.dart';
import '../Services/Services_User.dart';
import 'RestaurantInfo.dart';

//가게 목록 페이지
class Restaurant_List extends StatefulWidget {
  late int userId;
  late String curLoc;
  late bool isCategory;
  late String categoryName;

  Restaurant_List(
      {Key? key,
      required this.userId,
      required this.curLoc,
      required this.isCategory,
      required this.categoryName})
      : super(key: key);
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

    if (widget.isCategory) {
      Services_Res.getCats(widget.categoryName).then((Res1) {
        setState(() {
          _res = Res1;
        });
      });
    } else {
      Services_Res.getRests().then((Res1) {
        setState(() {
          _res = Res1;
          _loading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.curLoc,
              overflow: TextOverflow.fade,
              style: TextStyle(color: Colors.black)),
          elevation: 1,
        ),
        body: Container(
          color: CupertinoColors.secondarySystemBackground,
          child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) {
              return Container(height: 1, color: Colors.grey);
            },
            itemCount: _res.length,
            itemBuilder: (context, index) {
              Res res = _res[index];
              String image = res.resImageDir;
              return ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Restaurant_info(
                          roomId: 0,
                          res: res,
                          userId: widget.userId,
                          image: image,
                          isHost: true,
                        ),
                      ));
                },
                title: Row(children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Hero(
                      tag: res.resId,
                      child: Image.network(
                        image,
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            res.resName,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "최소 주문 금액 : " +
                                res.resMinOrderPrice.toString() +
                                "원",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          SizedBox(
                            height: 5,
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
                ]),
              );
            },
          ),
        ));
  }
}
