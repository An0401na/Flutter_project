import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Model/Res.dart';
import '../Services/Services_Res.dart';
import 'RestaurantInfo.dart';

class SearchPage extends StatefulWidget {
  int userId;
  SearchPage({
    Key? key,
    required this.userId,
  }) : super(key: key);
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final searchText = TextEditingController();
  List<Res> _res = [];
  @override
  Widget build(BuildContext context) {
    List<int> resIdList = [];
    bool resDuplicated = false;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(hintText: '가게나 메뉴 이름으로 검색'),
                  controller: searchText,
                ),
              ),
              TextButton(
                  onPressed: () {
                    print("검색");
                    Services_Res.getSearchRes(searchText.text.trim())
                        .then((Res1) {
                      setState(() {
                        _res = Res1;
                      });
                    });
                  },
                  child: Text(
                    "검색",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                  ))
            ],
          ),
          elevation: 1,
        ),
        body: Container(
          color: CupertinoColors.secondarySystemBackground,
          child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) {
              if (resDuplicated) return Container();
              return Container(height: 1, color: Colors.grey);
            },
            itemCount: _res.length,
            itemBuilder: (context, index) {
              resDuplicated = false;
              Res res = _res[index];
              String image = res.resImageDir;
              if (resIdList.contains(res.resId)) {
                resDuplicated = true;
                return Container();
              }
              resIdList.add(res.resId);
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
                                res.deliveryFees.first.delFee.toString() +
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
