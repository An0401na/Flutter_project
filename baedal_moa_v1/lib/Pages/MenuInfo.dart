import 'dart:convert';
import 'dart:typed_data';

import 'package:baedal_moa/Model/ShoppingCart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Model/Menu.dart';

class Menu_info extends StatefulWidget {
  late final Menu menu;
  late final ShoppingCart shoppingCart;
  late final ValueChanged<int> update;
  late Uint8List image;

  Menu_info(
      {required this.menu,
      required this.shoppingCart,
      required this.update,
      required this.image});

  @override
  State<Menu_info> createState() => _Menu_infoState();
}

class _Menu_infoState extends State<Menu_info> {
  int menuCnt = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Hero(
              tag: widget.menu.menuName,
              child: Image.memory(
                widget.image,
                fit: BoxFit.fill,
              )),
          Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  widget.menu.menuName,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Container(height: 1, color: Colors.grey),
          Container(
            padding:
                EdgeInsets.only(top: 30.0, bottom: 30, left: 10, right: 10),
            child: Row(
              children: [
                Container(
                  child: Text(
                    "가격",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Container(
                      padding: EdgeInsets.only(right: 15),
                      alignment: Alignment.centerRight,
                      child: Text(
                        (widget.menu.menuPrice * menuCnt).toString() + " 원",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      )),
                ),
              ],
            ),
          ),
          Container(height: 1, color: Colors.grey),
          Container(
            padding:
                EdgeInsets.only(top: 30.0, bottom: 30, left: 10, right: 10),
            child: Row(
              children: [
                Container(
                  child: Text(
                    "수량",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Container(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              splashRadius: 10,
                              onPressed: () {
                                setState(() {
                                  if (menuCnt > 1) {
                                    menuCnt--;
                                    print(menuCnt.toString());
                                  }
                                });
                              },
                              icon: Icon(Icons.remove)),
                          Text(
                            menuCnt.toString() + " 개",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                              splashRadius: 10,
                              onPressed: () {
                                setState(() {
                                  if (menuCnt < 100) {
                                    menuCnt++;
                                    print(menuCnt.toString());
                                  }
                                });
                              },
                              icon: Icon(Icons.add)),
                        ],
                      )),
                ),
              ],
            ),
          ),
          Container(height: 1, color: Colors.grey),
          Expanded(
              child: Container(
            color: CupertinoColors.lightBackgroundGray,
          ))
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
            width: double.infinity,
            height: 90,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: ElevatedButton(
                  child: Text(
                    menuCnt.toString() + " 개 장바구니에 담기",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    if (widget.shoppingCart.menusCnt
                        .containsKey(widget.menu.menuName)) {
                      widget.shoppingCart.menusCnt.update(
                          widget.menu.menuName, (value) => value + menuCnt);
                    } else {
                      widget.shoppingCart.menus.add(widget.menu);
                      widget.shoppingCart.menusCnt[widget.menu.menuName] =
                          menuCnt;
                    }
                    int cnt = 0;
                    for (Menu m in widget.shoppingCart.menus) {
                      cnt += widget.shoppingCart.menusCnt[m.menuName]!;
                    }
                    widget.update(cnt);
                    print(widget.menu.menuName +
                        " " +
                        menuCnt.toString() +
                        " 개 장바구니에 담김");
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.deepOrange)),
            )),
        elevation: 10,
      ),
    );
  }
}
