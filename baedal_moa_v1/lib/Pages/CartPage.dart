import 'dart:convert';

import 'package:baedal_moa/Model/ShoppingCart.dart';
import 'package:baedal_moa/Pages/CreateRoomPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Model/Menu.dart';
import '../Model/Res.dart';
import '../Model/User.dart';

class CartPage extends StatefulWidget {
  late Res res;
  late ShoppingCart shoppingCart;
  late final ValueChanged<int> update;
  late int userId;

  CartPage(
      {required this.res,
      required this.shoppingCart,
      required this.update,
      required this.userId});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    // for (Menu mN in shoppingCart.menus) {
    //   print(mN.menuName);
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text("장바구니"),
        elevation: 1,
      ),
      body: bodyWidget(context),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
            width: double.infinity,
            height: 90,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: ElevatedButton(
                  child: Text(
                    "메뉴 선택 끝내기",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    print("<최종 선택 메뉴>");
                    print(
                        "선택한 메뉴 : " + widget.shoppingCart.menusCnt.toString());
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateRoomPage(
                              shoppingCart: widget.shoppingCart,
                              res: widget.res,
                              userId: widget.userId)),
                    );
                    // 방 만들기 페이지로
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.deepOrange)),
            )),
        elevation: 10,
      ),
    );
  }

  bodyWidget(BuildContext context) {
    int totalPrice = 0;
    for (Menu m in widget.shoppingCart.menus) {
      int? cnt = widget.shoppingCart.menusCnt[m.menuName];
      totalPrice += m.menuPrice * cnt!;
      widget.shoppingCart.totalPrice = totalPrice;
    }
    return Column(
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) {
              return Container(
                height: 1,
                color: Colors.grey,
              );
            },
            itemCount: widget.shoppingCart.menus.length,
            itemBuilder: (BuildContext context, int index) {
              Menu m = widget.shoppingCart.menus[index];
              int? cnt = widget.shoppingCart.menusCnt[m.menuName];
              return Container(
                padding: EdgeInsets.all(8.5),
                child: Row(children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Image.memory(
                      base64Decode(utf8.decode(m.menuImageDir.data)),
                      width: 100,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(m.menuName),
                              Expanded(
                                  child: Container(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      int cnt = 0;
                                      widget.shoppingCart.menus.remove(m);
                                      widget.shoppingCart.menusCnt
                                          .remove(m.menuName);
                                      for (Menu m
                                          in widget.shoppingCart.menus) {
                                        cnt += widget
                                            .shoppingCart.menusCnt[m.menuName]!;
                                      }
                                      widget.update(cnt);
                                    });
                                  },
                                ),
                              ))
                            ],
                          ),
                          Row(
                            children: [
                              Text((m.menuPrice * cnt!).toString() + " 원"),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(right: 18),
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    widget.shoppingCart.menusCnt[m.menuName]
                                            .toString() +
                                        "개",
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ]),
              );
            },
          ),
        ),
        Container(
          height: 1,
          color: Colors.grey,
        ),
        Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add,
                      color: Colors.deepOrange,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "메뉴 추가하기",
                        style: TextStyle(color: Colors.deepOrange),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 1,
                color: Colors.deepOrange,
              ),
              Container(
                  child: Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      child: Text(
                        "총 주문 금액",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            totalPrice.toString() + " 원",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          )),
                    ),
                  ],
                ),
              ))
            ],
          ),
        )
      ],
    );
  }
}
