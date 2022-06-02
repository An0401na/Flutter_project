import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  int userId;
  SearchPage({
    Key? key,
    required this.userId,
  }) : super(key: key);
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final searching = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(hintText: '검색어를 입력하세요'),
                controller: searching,
              ),
            ),
            TextButton(
                onPressed: () {
                  print("검색");
                },
                child: Text(
                  "검색",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                ))
          ],
        ),
        elevation: 1,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text('우리 동네 맛집', style: TextStyle(fontSize: 25)),
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
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text('최소 주문 금액 : ' + '10000원',
                          style: TextStyle(color: Colors.grey)),
                      Text('배달요금 : ' + '0~3000원',
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  margin: EdgeInsets.only(left: 5),
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
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text('최소 주문 금액 : ' + '8000원',
                          style: TextStyle(color: Colors.grey)),
                      Text('배달요금 : ' + '0~3000원',
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  margin: EdgeInsets.only(left: 5),
                ),
              ],
            ),
            margin: EdgeInsets.only(top: 2),
          ),
          line,
        ],
      ),
    );
  }

  @override
  Widget line = Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      width: 500,
      child: Divider(color: Colors.black, thickness: 1.0));
}
