import 'dart:convert';
import 'dart:typed_data';

import 'package:badges/badges.dart';
import 'package:baedal_moa/Model/Room.dart';
import 'package:baedal_moa/Model/ShoppingCart.dart';
import 'package:baedal_moa/Pages/MenuInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Model/Res.dart';
import '../Model/Menu.dart';
import '../Model/AppUser.dart';
import '../Services/Services_Menu.dart';
import 'CartPage.dart';

class Restaurant_info extends StatefulWidget {
  Res res;
  int userId;
  String image;
  bool isHost;
  int roomId;
  Restaurant_info(
      {required this.roomId,
      required this.res,
      required this.userId,
      required this.image,
      required this.isHost});

  @override
  _Restaurant_infoState createState() => _Restaurant_infoState();
}

class _Restaurant_infoState extends State<Restaurant_info> {
  late List<Menu> _menu = [];
  late ShoppingCart shoppingCart;

  int menuCnt = 0;

  void initState() {
    super.initState();
    shoppingCart = ShoppingCart(
        roomId: widget.roomId,
        userId: widget.userId,
        resId: widget.res.resId,
        menus: [],
        menusCnt: {},
        totalPrice: 0);
    Services_Menu.getMenus(widget.res.resId.toString()).then((Menu1) {
      setState(() {
        _menu = Menu1;
      });
    });
  }

  void update(int count) {
    setState(() {
      menuCnt = count;
    });
  }

  @override
  FloatingActionButton floatingActionButtonWidget() {
    return FloatingActionButton(
      child: Badge(
          showBadge: menuCnt == 0 ? false : true,
          position: BadgePosition.topEnd(top: -10, end: -5),
          badgeContent: Text(
            menuCnt.toString(),
            style: TextStyle(color: Colors.white),
          ),
          child: Icon(Icons.shopping_cart, color: Colors.deepOrange, size: 30)),
      backgroundColor: Colors.white,
      shape:
          StadiumBorder(side: BorderSide(color: Colors.deepOrange, width: 3)),
      onPressed: () {
        print("장바구니 : " + shoppingCart.menusCnt.toString());
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CartPage(
                      res: widget.res,
                      shoppingCart: shoppingCart,
                      update: update,
                      userId: widget.userId,
                      isHost: widget.isHost,
                      roomId: widget.roomId,
                    )));
      },
      elevation: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    if (widget.isHost == true) {
      print("방장입니다.");
    } else {
      print("참여자 입니다.");
    }
    return WillPopScope(
      onWillPop: shoppingCart.menus.isNotEmpty
          ? onBackKey
          : () {
              return Future(() => true);
            },
      child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          floatingActionButton: Visibility(
              visible: shoppingCart.menus.isEmpty ? false : true,
              child: floatingActionButtonWidget()),
          body: SingleChildScrollView(
            child: Container(
              color: CupertinoColors.secondarySystemBackground,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Hero(
                    tag: widget.res.resId,
                    child: Image.network(
                      widget.image,
                      fit: BoxFit.fill,
                    ),
                    // Image.memory(
                    //   base64Decode(utf8.decode(widget.res.resImageDir.data)),
                    // ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.res.resName,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.visible,
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              print("찜하기");
                            },
                            icon: Icon(
                              Icons.favorite_border_rounded,
                              size: 40,
                              color: Colors.deepOrange,
                            ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text("최소 주문",
                                style: TextStyle(
                                  color: Colors.grey,
                                )),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(widget.res.resMinOrderPrice.toString() + "원")
                          ],
                        ),
                        Row(
                          children: [
                            Text("배달 요금",
                                style: TextStyle(
                                  color: Colors.grey,
                                )),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(widget.res.deliveryFees.first.delFee
                                    .toString() +
                                "~" +
                                widget.res.deliveryFees.last.delFee.toString() +
                                "원")
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("가게 위치",
                                style: TextStyle(
                                  color: Colors.grey,
                                )),
                            const SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              fit: FlexFit.loose,
                              child: Text(
                                widget.res.resLocation.toString(),
                                overflow: TextOverflow.visible,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ), //가게 정보
                  MenuList(),
                ],
              ),
            ),
          )),
    );
  }

  Future<bool> onBackKey() async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("장바구니가 초기화 됩니다.\n다른 가게를 보러 가시겠습니까?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text(
                    "확인",
                    style: TextStyle(color: Colors.deepOrange),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text(
                    "취소",
                    style: TextStyle(color: Colors.deepOrange),
                  )),
            ],
          );
        });
  }

  MenuList() {
    late String menuImage;
    return Column(
      children: [
        for (Menu m in _menu)
          Column(
            children: [
              Container(
                height: 1,
                color: Colors.grey,
              ),
              InkWell(
                onTap: () {
                  Services_Menu.postMenu(m.menuName.toString());
                  print(widget.res.resName + "의 " + m.menuName + "메뉴 선택");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Menu_info(
                                menu: m,
                                shoppingCart: shoppingCart,
                                update: update,
                                image: menuImage,
                                isHost: widget.isHost,
                              )));
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Hero(
                          tag: m.menuName,
                          child: Image.network(
                            menuImage = m.menuImageDir,
                            width: 100,
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(m.menuName),
                          SizedBox(
                            height: 10,
                          ),
                          Text(m.menuPrice.toString() + "원")
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          )
      ],
    );
  }
}
