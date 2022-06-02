import 'package:flutter/material.dart';

class OrderLogPage extends StatefulWidget {
  @override
  State<OrderLogPage> createState() => _OrderLogPageState();
}

class _OrderLogPageState extends State<OrderLogPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Text('내 주문 내역', style: TextStyle(fontSize: 25)),
          padding: EdgeInsets.only(left: 10, top: 5),
        ),
        line,
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                //사진을 넣을 컨테이너
                width: 100,
                height: 100,
                color: Colors.black12,
                margin: EdgeInsets.only(left: 10),
                child: Text('가게사진'), //나중에 사진 넣을 위치
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '롯데리아 경기대역점',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text('새우버거 세트' + ' x ' + '1',
                        style: TextStyle(color: Colors.grey)),
                    Text('불고기버거 세트' + ' x ' + '1',
                        style: TextStyle(color: Colors.grey)),
                    Text('총 결제 포인트 : ' + '14000원',
                        style: TextStyle(color: Colors.black)),
                  ],
                ),
                margin: EdgeInsets.only(left: 5),
              ),
              Container(
                child: Text(
                  '결제 중',
                  style: TextStyle(fontSize: 18),
                ),
                padding: EdgeInsets.only(left: 40),
              ),
            ],
          ),
          margin: EdgeInsets.only(top: 2),
        ),
        line,
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                //사진을 넣을 컨테이너
                width: 100,
                height: 100,
                color: Colors.black12,
                margin: EdgeInsets.only(left: 10),
                child: Text('가게사진'), //나중에 사진 넣을 위치
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '수련반점',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text('간짜장' + ' x ' + '2',
                        style: TextStyle(color: Colors.grey)),
                    Text('탕수육(소)' + ' x ' + '1',
                        style: TextStyle(color: Colors.grey)),
                    Text('총 결제 포인트 : ' + '25000원',
                        style: TextStyle(color: Colors.black)),
                  ],
                ),
                margin: EdgeInsets.only(left: 5),
              ),
              Container(
                child: Text(
                  '결제 완료',
                  style: TextStyle(fontSize: 18),
                ),
                padding: EdgeInsets.only(left: 40),
              ),
            ],
          ),
          margin: EdgeInsets.only(top: 2),
        ),
        line,
      ],
    );
  }

  @override
  Widget line = Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      width: 500,
      child: Divider(color: Colors.black, thickness: 1.0));
}
