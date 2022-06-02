import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  late List<Order> orderList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Services_Order.getOrders(widget.userId.toString()).then((value) {
      setState(() {
        orderList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return orderList.isEmpty
        ? Center(
            child: Text('주문 내역이 없습니다.'),
          )
        : SingleChildScrollView(
            child: getOrderList(),
          );
  }

  getOrderList() {
    List<int> orderNumList = [];
    Map<int, OrderLog> orderLogList = {};
    for (Order o in orderList) {
      if (orderLogList.containsKey(o.roomId)) {
        orderLogList[o.roomId]?.menuList.add(OrderedMenu(
            menuPrice: o.menuPrice,
            menuName: o.menuName,
            menuCount: o.menuCount));
        orderLogList[o.roomId]!.totalPrice =
            orderLogList[o.roomId]!.totalPrice + o.menuPrice * o.menuCount;
      } else {
        orderNumList.add(o.roomId);
        orderLogList.addAll({
          o.roomId: OrderLog(
              orderId: o.roomId,
              orderedTime: o.roomExpireTime,
              resName: o.resName,
              menuList: [
                OrderedMenu(
                    menuPrice: o.menuPrice,
                    menuName: o.menuName,
                    menuCount: o.menuCount)
              ],
              totalPrice: o.menuCount * o.menuPrice + o.roomDelFee,
              orderDelfee: o.roomDelFee)
        });
      }
    }
    return Column(children: [
      for (int i in orderNumList.reversed)
        Column(
          children: [
            Text(
              //o.resName,
              '롯데리아 경기대역점',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('주문 번호 : ' + orderLogList[i]!.orderId.toString()),
            for (OrderedMenu om in orderLogList[i]!.menuList)
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(om.menuName + ' x ' + om.menuCount.toString()),
                    Text((om.menuCount * om.menuPrice).toString() + ' 원')
                  ],
                ),
              ),
            Text('배달비 : ' + orderLogList[i]!.orderDelfee.toString() + ' 원'),
            Text('총 결제 금액 : ' + orderLogList[i]!.totalPrice.toString() + ' 원'),
            Text('주문 완료 시간 : ' +
                DateFormat('yyyy-MM-dd hh:mm')
                    .format(orderLogList[i]!.orderedTime)),
            Container(
              height: 1,
              color: Colors.deepOrange,
            ),
          ],
        )
    ]);
  }
}

class OrderLog {
  OrderLog(
      {required this.orderId,
      required this.resName,
      required this.orderedTime,
      required this.menuList,
      required this.totalPrice,
      required this.orderDelfee});
  int orderId;
  String resName;
  DateTime orderedTime;
  List<OrderedMenu> menuList;
  int totalPrice;
  int orderDelfee;
}

class OrderedMenu {
  OrderedMenu({
    required this.menuPrice,
    required this.menuName,
    required this.menuCount,
  });
  String menuName;
  int menuPrice;
  int menuCount;
}
