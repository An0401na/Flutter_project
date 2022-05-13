import 'package:flutter/material.dart';

import '../Model/Menu.dart';

class Menu_info extends StatelessWidget {
  late final Menu menu;

  Menu_info({required this.menu});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(menu.menuName),
        elevation: 0,
      ),
      body: Column(
        children: [
          Image.asset(
            "assets/images/lotteria2.png",
            width: MediaQuery.of(context).size.width,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                child: Text("가격"),
                width: 50,
              ),
              Expanded(child: Text("가격")),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                child: Text("수량"),
                width: 50,
              ),
              Expanded(child: Text("1개")),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 90,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: ElevatedButton(
                  child: Text(
                    "장바구니에 담기",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(primary: Colors.deepOrange)),
            )),
        elevation: 10,
      ),
    );
  }
}
