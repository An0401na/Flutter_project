import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class App extends StatefulWidget {
  late int curPageIndex;

  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late Icon appBarIcon;
  bool _drawerIsOpened = false;
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    currentPageIndex = 0;
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
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => GoogleMapPage(userId: widget.userId),
              //     ));
            },
            icon: Icon(Icons.room, color: Colors.deepOrange),
            label: Text("롯데리아 연무점",
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

  Widget bodyWidget(BuildContext context) {
    switch (currentPageIndex) {
      case 0:
        return Text("접수대기");
      case 1:
        return Text("진행중");
      case 2:
        return Text("완료");
      case 3:
        return Text("주문 조회");
      case 4:
        return Text("aaa");
    }
    return Container();
  }

  // 하단의 + 버튼

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
        BottomNavigationBarItem(icon: Icon(Icons.alarm_on), label: "접수 대기"),
        BottomNavigationBarItem(
            icon: Icon(Icons.fastfood_outlined), label: "진행 중"),
        BottomNavigationBarItem(icon: Icon(Icons.assignment), label: "완료"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "주문 조회"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "프로필")
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Aaaaaaaaaaa");
    if (currentPageIndex == 0) {
      return WillPopScope(
        onWillPop: onBackKey,
        child: Scaffold(
            appBar: appbarWidget(),
            body: bodyWidget(context),
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
      //나머지 탭
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
