import 'dart:convert';

import 'package:baedal_moa/Model/Room.dart';
import 'package:baedal_moa/Model/ShoppingCart.dart';
import 'package:baedal_moa/Pages/CreateRoomPage.dart';
import 'package:baedal_moa/Pages/RoomInfo.dart';
import 'package:baedal_moa/Services/Services_Room.dart';
import 'package:baedal_moa/Services/Services_ShoppingCart.dart';
import 'package:baedal_moa/Services/Services_User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Model/Menu.dart';
import '../Model/Res.dart';
import '../Model/AppUser.dart';

class CartPage extends StatefulWidget {
  late Res res;
  late ShoppingCart shoppingCart;
  late final ValueChanged<int> update;
  late int userId;
  bool isHost;
  int roomId;
  CartPage(
      {required this.roomId,
      required this.res,
      required this.shoppingCart,
      required this.update,
      required this.userId,
      required this.isHost});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late List<Room> _room;
  late List<AppUser> _userList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Services_Room.getRooms(widget.userId.toString()).then((Room1) {
      setState(() {
        _room = Room1;
      });
    });
    Services_User.getUsers(widget.userId.toString()).then((User1) {
      setState(() {
        _userList = User1;
      });
    });
  }

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
                    if (widget.shoppingCart.menus.isNotEmpty && widget.isHost) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            // 방 만들기 페이지로
                            builder: (context) => CreateRoomPage(
                                shoppingCart: widget.shoppingCart,
                                res: widget.res,
                                userId: widget.userId)),
                      );
                    } else if (widget.shoppingCart.menus.isNotEmpty &&
                        !widget.isHost) {
                      for (Room room in _room) {
                        if (widget.roomId == room.roomId) {
                          List<RoomMemberMenu> menuList = [];
                          for (Menu m in widget.shoppingCart.menus) {
                            menuList.add(RoomMemberMenu(
                                menuId: m.menuId,
                                userId: widget.userId,
                                menuPrice: m.menuPrice,
                                menuCount:
                                    widget.shoppingCart.menusCnt[m.menuName]!));
                          }
                          room.roomMemberMenus.add(menuList);
                          room.roomUser.add(RoomUser(
                              userId: widget.userId,
                              userNickname: _userList[0].userNickname,
                              userLocationX: _userList[0].userLocationX,
                              userLocationY: _userList[0].userLocationY,
                              userCash: _userList[0].userCash));
                          print("룸 멤버 메뉴 : " +
                              jsonEncode(menuList) +
                              menuList[0].userId.toString());
                          Services_ShoppingCart.postShoppingCart(
                              menuList, widget.roomId.toString());
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                //방 정보 페이지로
                                builder: (context) => Room_info(
                                      room: room,
                                      userId: widget.userId,
                                      isHost: widget.isHost,
                                    )),
                          );
                        }
                      }
                    }
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
                    child: Image.network(
                      m.menuImageDir,
                      width: 100,
                      height: 70,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 70,
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Text(m.menuName),
                                Expanded(
                                    child: Container(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
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
                                          cnt += widget.shoppingCart
                                              .menusCnt[m.menuName]!;
                                        }
                                        widget.update(cnt);
                                      });
                                    },
                                  ),
                                ))
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Text((m.menuPrice * cnt!).toString() + " 원"),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(right: 7),
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    widget.shoppingCart.menusCnt[m.menuName]
                                            .toString() +
                                        " 개",
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
        Column(
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
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
        )
      ],
    );
  }
}
