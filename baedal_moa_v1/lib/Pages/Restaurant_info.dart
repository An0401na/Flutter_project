import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:baedal_moa/Model/ShoppingCart.dart';
import 'package:baedal_moa/Pages/Menu_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Model/Res.dart';
import '../Model/Menu.dart';
import '../Model/User.dart';
import '../Services/Services_Menu.dart';
import 'CartPage.dart';

class Restaurant_info extends StatefulWidget {
  Res res;
  int userId;
  Restaurant_info({required this.res, required this.userId});

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
        resId: widget.res.resId, menus: [], menusCnt: {}, totalPrice: 0);
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
          position: BadgePosition.topEnd(top: -10, end: -8),
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
    for (Menu m in _menu) {
      print(m.menuName);
    }
    return WillPopScope(
      onWillPop: onBackKey,
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              widget.res.resName.toString(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            elevation: 0,
          ),
          extendBodyBehindAppBar: true,
          floatingActionButton: floatingActionButtonWidget(),
          body: ListView.separated(
              separatorBuilder: (BuildContext context, int index) {
                return Container(
                  height: 1,
                  color: Colors.grey,
                );
              },
              itemCount: _menu.length,
              itemBuilder: (BuildContext context, int index) {
                Menu menu = _menu[index];
                if (index == 0) {
                  return Column(
                    children: [
                      // 가게 사진
                      Container(
                        child: Image.memory(
                          base64Decode(
                              utf8.decode(widget.res.resImageDir.data)),
                          // width: deviceWidth,
                        ),
                      ),
                      // 가게 정보
                      Container(
                        padding: EdgeInsets.all(15),
                        child: Row(
                          children: [
                            Flexible(
                              fit: FlexFit.tight,
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
                                      Text(widget.res.resMinOrderPrice
                                              .toString() +
                                          "원")
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
                                          widget.res.deliveryFees.last.delFee
                                              .toString() +
                                          "원")
                                    ],
                                  ),
                                  Container(
                                    width: double.infinity,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                                width: 50,
                                child: IconButton(
                                    onPressed: () {
                                      print("찜하기");
                                    },
                                    icon: Icon(
                                      Icons.favorite_border_rounded,
                                      size: 40,
                                      color: Colors.deepOrange,
                                    )))
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return ListTile(
                    title: Row(children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.memory(
                            base64Decode(utf8.decode(menu.menuImageDir.data)),
                            width: 100,
                          )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(menu.menuName),
                            Text(menu.menuPrice.toString() + "원")
                          ],
                        ),
                      ),
                    ]),
                    onTap: () {
                      Services_Menu.postMenu(menu.menuName.toString());
                      print(
                          widget.res.resName + "의 " + menu.menuName + "메뉴 선택");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Menu_info(
                                    menu: menu,
                                    shoppingCart: shoppingCart,
                                    update: update,
                                  )));
                    },
                  );
                }
              })),
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
}
