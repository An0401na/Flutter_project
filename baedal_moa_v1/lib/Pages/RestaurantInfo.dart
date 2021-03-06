import 'dart:convert';
import 'dart:typed_data';

import 'package:badges/badges.dart';
import 'package:baedal_moa/Model/Room.dart';
import 'package:baedal_moa/Model/ShoppingCart.dart';
import 'package:baedal_moa/Pages/MenuInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import '../Model/Res.dart';
import '../Model/Menu.dart';
import '../Model/AppUser.dart';
import '../Services/Services_Menu.dart';
import '../Services/Services_Res.dart';
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
  late List<Res> _res = [];
  late ShoppingCart shoppingCart;
  bool isLiked = false;
  int menuCnt = 0;
  late Icon icon;
  bool iconLoading = false;

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
    Services_Res.getLikedResList(widget.userId.toString()).then((Res1) {
      setState(() {
        _res = Res1;
        for (Res r in _res) {
          if (r.resId == widget.res.resId) isLiked = true;
        }
        icon = setIcon(isLiked);
        iconLoading = true;
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
        print("???????????? : " + shoppingCart.menusCnt.toString());
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
                            onPressed: pressedLikeButton,
                            icon: iconLoading
                                ? icon
                                : Icon(
                                    Icons.favorite_border,
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
                            Text("?????? ??????",
                                style: TextStyle(
                                  color: Colors.grey,
                                )),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(widget.res.resMinOrderPrice.toString() + "???")
                          ],
                        ),
                        Row(
                          children: [
                            Text("?????? ??????",
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
                                "???")
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("?????? ??????",
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
                  ), //?????? ??????
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
            title: Text("??????????????? ????????? ?????????.\n?????? ????????? ?????? ???????????????????"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text(
                    "??????",
                    style: TextStyle(color: Colors.deepOrange),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text(
                    "??????",
                    style: TextStyle(color: Colors.deepOrange),
                  )),
            ],
          );
        });
  }

  Icon setIcon(bool isLiked) {
    return isLiked
        ? const Icon(
            Icons.favorite,
            size: 40,
            color: Colors.deepOrange,
          )
        : const Icon(
            Icons.favorite_border,
            size: 40,
            color: Colors.deepOrange,
          );
  }

  MenuList() {
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
                  print(widget.res.resName + "??? " + m.menuName + "?????? ??????");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Menu_info(
                                menu: m,
                                shoppingCart: shoppingCart,
                                update: update,
                                image: m.menuImageDir,
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
                            m.menuImageDir,
                            width: 100,
                          ),
                        )),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              m.menuName,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(m.menuPrice.toString() + "???")
                          ],
                        ),
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

  void pressedLikeButton() {
    print("??? ?????? ??????");
    isLiked = !isLiked;
    Services_Res.likedRes(
        widget.res.resId.toString(), widget.userId.toString(), isLiked);
    setState(() {
      icon = setIcon(isLiked);
    });
  }
}
