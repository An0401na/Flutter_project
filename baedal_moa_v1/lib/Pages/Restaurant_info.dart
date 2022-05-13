import 'dart:convert';

import 'package:baedal_moa/Pages/Menu_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Model/Res.dart';
import '../Model/Menu.dart';
import '../Services/Services_Menu.dart';

class Restaurant_info extends StatefulWidget {
  Res res;
  Restaurant_info({Key? key, required this.res}) : super(key: key);

  @override
  _Restaurant_infoState createState() => _Restaurant_infoState();
}

class _Restaurant_infoState extends State<Restaurant_info> {
  late List<Menu> _menu = [];

  void initState() {
    super.initState();
    Services_Menu.getMenus().then((Menu1) {
      setState(() {
        _menu = Menu1;
      });
    });
  }

  @override
  FloatingActionButton floatingActionButtonWidget() {
    return FloatingActionButton(
        child:
            const Icon(Icons.shopping_cart, color: Colors.deepOrange, size: 30),
        backgroundColor: Colors.white,
        shape:
            StadiumBorder(side: BorderSide(color: Colors.deepOrange, width: 4)),
        onPressed: () {});
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    return Scaffold(
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
          // scrollDirection: Axis.vertical,
          // shrinkWrap: true,
          separatorBuilder: (BuildContext context, int index) {
            return Container(
              height: 1,
              color: Colors.grey,
            );
          },
          itemCount: 2,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Column(
                children: [
                  Container(
                    child: Image.memory(
                      base64Decode(utf8.decode(widget.res.resImageDir.data)),
                      width: deviceWidth,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Expanded(
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
                                  Text(widget.res.resMinOrderPrice.toString())
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
                                  Text("" + " ~ " + "" + "원")
                                ],
                              ),
                              Row(
                                children: [
                                  Text("가게 위치",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      )),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(widget.res.resLocation.toString())
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                            child: IconButton(
                                onPressed: () {
                                  print("찜하기");
                                },
                                icon: Icon(
                                  Icons.favorite_outline,
                                  size: 40,
                                  color: Colors.deepOrange,
                                )))
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _menu.length,
                itemBuilder: (context, index) {
                  Menu menu = _menu[index];
                  return ListTile(
                    title: Row(children: [
                      Image.asset("assets/images/lotteria2.png", width: 100),
                      // Image.memory(
                      //   base64Decode(utf8.decode(menu.menuImageDir.data)),
                      //   width: 100,
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
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
                                  )));
                    },
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Container(height: 1, color: Colors.grey);
                },
              );
            }
          },
        ));
  }
}
