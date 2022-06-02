import 'dart:math';

import 'package:baedal_moa/Pages/GoogleMapPage.dart';
import 'package:baedal_moa/Pages/LikeList.dart';
import 'package:baedal_moa/Pages/OrderLogPage.dart';
import 'package:baedal_moa/Services/Services_User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Model/AppUser.dart';
import 'ProfilePage.dart';
import 'RestaurantList.dart';
import 'RoomList.dart';
import 'SearchPage.dart';

class App extends StatefulWidget {
  int userId;
  late String curLoc;
  int curPageIndex;
  App(
      {Key? key,
      required this.userId,
      required this.curLoc,
      required this.curPageIndex})
      : super(key: key);
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late AppUser _user;
  late Icon appBarIcon;
  bool _drawerIsOpened = false;
  int currentPageIndex = 0;
  Map<String, String> categoryNames = {
    '햄버거': 'burger',
    '치킨': 'chicken',
    '피자,양식': 'pizza',
    '중국집': 'zzangggae',
    '한식': 'korea',
    '일식,돈까스': 'japanese',
    '족발,보쌈': 'zokbal',
    '분식': 'bunsik',
    '카페,디저트': 'cafe'
  };
  @override
  void initState() {
    super.initState();
    Services_User.getUsers(widget.userId.toString()).then((User1) {
      setState(() {
        _user = User1.first;
      });
    });
  }

  PreferredSizeWidget appbarWidget() {
    // print(widget.curLoc);
    String currentTitle = "";
    switch (currentPageIndex) {
      case 0:
        return AppBar(
          title: TextButton.icon(
            onPressed: () {
              print("위치 설정");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GoogleMapPage(userId: widget.userId),
                  ));
            },
            icon: Icon(Icons.room, color: Colors.deepOrange),
            label: Text(widget.curLoc,
                overflow: TextOverflow.fade,
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w400)),
          ),
          elevation: 1,
        );
      case 1:
        currentTitle = "찜 목록";
        break;
      case 3:
        currentTitle = "주문 내역";
        break;
      case 4:
        currentTitle = "마이 프로필";
        break;
    }
    return AppBar(
      automaticallyImplyLeading: false,
      title: Center(
        child: Text(currentTitle),
      ),
      elevation: 1,
    );
  }

  getCategory(String name) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Restaurant_List(
                curLoc: widget.curLoc,
                userId: widget.userId,
                isCategory: true,
                categoryName: '${categoryNames[name]}',
              ),
            ));
      },
      child: Container(
        width: 100,
        height: 150,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Image.asset(
            "assets/images/${name}.png",
            width: 100,
            height: 100,
          ),
          Text(name)
        ]),
      ),
    );
  }

  Widget drawerWidget(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Drawer(
          child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("카테고리"),
          elevation: 1,
        ),
        body: Container(
          color: CupertinoColors.secondarySystemBackground,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  getCategory("햄버거"),
                  getCategory("치킨"),
                  getCategory("피자,양식"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  getCategory("중국집"),
                  getCategory("한식"),
                  getCategory("일식,돈까스"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  getCategory("족발,보쌈"),
                  getCategory("분식"),
                  getCategory("카페,디저트"),
                ],
              )
            ],
          ),
        ),
      )),
    );
  }

  Widget bodyWidget(BuildContext context) {
    switch (currentPageIndex) {
      case 0:
        return Room_List(userId: widget.userId);
      case 1:
        return LikeList();
      case 2:
        return SearchPage();
      case 3:
        return OrderLogPage();
      case 4:
        return ProfilePage(
          user: _user,
        );
    }
    return Container();
  }

  // 하단의 + 버튼
  FloatingActionButton floatingActionButtonWidget() {
    return FloatingActionButton(
        elevation: 0,
        child: Icon(
          Icons.add,
          size: 30,
        ),
        backgroundColor: Colors.deepOrange,
        onPressed: () {
          print("방 만들기");
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                title: const Text("직접 방을 만드시겠습니까?"),
                actions: <Widget>[
                  TextButton(
                    child: const Text(
                      "취소",
                      style: TextStyle(color: Colors.deepOrange),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                      child: const Text(
                        "확인",
                        style: TextStyle(color: Colors.deepOrange),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Restaurant_List(
                                curLoc: widget.curLoc,
                                userId: widget.userId,
                                isCategory: false,
                                categoryName: '',
                              ),
                            ));
                      })
                ],
              );
            },
          );
        });
  }

  Widget bottomNavigationBarWidget() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        print(index);
        setState(() {
          currentPageIndex = index;
        });
      },
      currentIndex: currentPageIndex,
      iconSize: 30,
      elevation: 10,
      selectedItemColor: Colors.deepOrange,
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "홈"),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "찜 목록"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "검색"),
        BottomNavigationBarItem(icon: Icon(Icons.assignment), label: "주문 내역"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "프로필")
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (currentPageIndex == 0) {
      //홈 탭
      return WillPopScope(
        onWillPop: onBackKey,
        child: Scaffold(
            appBar: appbarWidget(),
            endDrawer: drawerWidget(context),
            onEndDrawerChanged: (isOpened) {
              _drawerIsOpened = !_drawerIsOpened;
            },
            body: bodyWidget(context),
            floatingActionButton: floatingActionButtonWidget(),
            bottomNavigationBar: bottomNavigationBarWidget()),
      );
    } else if (currentPageIndex == 2) {
      //검색 탭
      return WillPopScope(
        onWillPop: onBackKey,
        child: Scaffold(
          body: bodyWidget(context),
          bottomNavigationBar: bottomNavigationBarWidget(),
        ),
      );
    } else {
      //나머지 탭 (주문내역)
      return WillPopScope(
        onWillPop: onBackKey,
        child: Scaffold(
            appBar: appbarWidget(),
            body: bodyWidget(context),
            bottomNavigationBar: bottomNavigationBarWidget()),
      );
    }
  }

  Future<bool> onBackKey() async {
    if (_drawerIsOpened) {
      Navigator.of(context).pop();
      return false;
    }
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("앱을 종료하시겠습니까?"),
            actions: [
              TextButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  child: Text(
                    "확인",
                    style: TextStyle(color: Colors.deepOrange),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text(
                    "취소",
                    style: TextStyle(color: Colors.deepOrange),
                  )),
            ],
          );
        });
  }
}
