import 'package:flutter/material.dart';

import '../Model/Menu.dart';
import '../Model/Order.dart';
import '../Services/Services_Order.dart';

class OrderLogPage extends StatefulWidget {
  int userId;
  OrderLogPage({
    Key? key,
    required this.userId,
  }) : super(key: key);
  @override
  State<OrderLogPage> createState() => _OrderLogPageState();
}

class _OrderLogPageState extends State<OrderLogPage> {
  late List<Order> orderList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Services_Order.getOrders(widget.userId.toString()).then((value) {
      orderList = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text('내 주문 내역', style: TextStyle(fontSize: 25)),
            padding: EdgeInsets.only(left: 10, top: 5),
          ),
          getOrderList(),
          line,
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '롯데리아 경기대역점',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  '주문 번호 : ' + '',
                  style: TextStyle(color: Colors.grey),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('새우버거 세트' + ' x ' + '1',
                        style: TextStyle(color: Colors.grey)),
                    Text('개수 X 가격', style: TextStyle(color: Colors.grey))
                  ],
                ),
                Text('총 결제 포인트 : ' + '14000원',
                    style: TextStyle(color: Colors.black)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget line = Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Divider(color: Colors.black, thickness: 1.0));

  getOrderList() {
    Map<int,List<OrderedMenu>> orderMenuList = {};
    for(Order o in orderList){
      if(orderMenuList.containsKey(o.roomId)){
        orderMenuList[o.roomId]?.add(OrderedMenu(menuPrice: o.menuPrice, menuName: o.menuName, menuCount: o.menuCount));
      }else{
        orderMenuList.
      }
    }
    return Column(
      children: [
        for(Order o in orderList)
          Column(
            children: [
              Text(
                //o.resName,
                '롯데리아 경기대역점',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text('주문 번호 : ' + o.),
            ],
          )]);
  }
}

class OrderedMenu{
  OrderedMenu({
    required this.menuPrice,
    required this.menuName,
    required this.menuCount,

  });
  String menuName;
  int menuPrice;
  int menuCount;
}