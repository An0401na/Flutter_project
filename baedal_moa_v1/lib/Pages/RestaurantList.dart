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
  late bool isLike;
  late String categoryName;

  Restaurant_List(
      {Key? key,
      required this.userId,
      required this.curLoc,
      required this.isCategory,
      required this.categoryName,
      required this.isLike})
      : super(key: key);
  @override
  _Restaurant_ListState createState() => _Restaurant_ListState();
}

class _Restaurant_ListState extends State<Restaurant_List> {
  @override
  late List<Res> _res = [];
  Map<String, String> categoryNames = {
    '햄버거': 'burger',
    '치킨': 'chicken',
    '피자,양식': 'pizza',
    '중국집': 'zzangggae',
    '한식': 'korea',
    '일식,돈까스': 'japanese',
    '족발,보쌈': 'zokbal',
    '분식': 'bunsik',
    '카페,디저트': 'cafe'
  };

  @override
  void initState() {
    super.initState();

    if (widget.isCategory) {
      Services_Res.getCats(categoryNames[widget.categoryName]!).then((Res1) {
        setState(() {
          _res = Res1;
        });
      });
    } else if (widget.isLike) {
      Services_Res.getLikedResList(widget.userId.toString()).then((Res1) {
        setState(() {
          _res = Res1;
        });
      });
    } else {
      Services_Res.getRests().then((Res1) {
        setState(() {
          _res = Res1;
        });
      });
    }
  }

  AppBar LikedListAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Center(
        child: Text("찜 목록"),
      ),
      elevation: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: widget.isLike
            ? LikedListAppBar()
            : AppBar(
                title: Text(
                    widget.isCategory ? widget.categoryName : widget.curLoc,
                    overflow: TextOverflow.fade,
                    style: TextStyle(color: Colors.black)),
                elevation: 1,
              ),
        body: widget.isLike && _res.isEmpty
            ? Container(
                color: CupertinoColors.secondarySystemBackground,
                child: Center(child: Text("찜한 가게가 없습니다.")),
              )
            : Container(
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
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "최소 주문 금액 : " +
                                      res.resMinOrderPrice.toString() +
                                      "원",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "배달 요금 : " +
                                      res.deliveryFees.first.delFee.toString() +
                                      "~" +
                                      res.deliveryFees.last.delFee.toString() +
                                      " 원",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey),
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
