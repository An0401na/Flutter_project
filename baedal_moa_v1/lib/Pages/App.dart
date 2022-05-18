import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Restaurant_List.dart';
import 'Room_List.dart';

class App extends StatefulWidget {
  late String userId;
  late String curLoc;
  App({Key? key, required this.userId, required this.curLoc}) : super(key: key);
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late Icon appBarIcon;
  int currentPageIndex = 0;
  bool isCreateRoom = false;

  PreferredSizeWidget appbarWidget() {
    print(widget.curLoc);
    String currentTitle = "";
    switch (currentPageIndex) {
      case 0:
        return AppBar(
          title: Row(
            children: [
              IconButton(
                  onPressed: () {
                    if (isCreateRoom) {
                      print("방 목록으로 돌아가기");
                      setState(() {
                        isCreateRoom = false;
                      });
                    } else {
                      print("위치 설정");
                    }
                  },
                  icon: isCreateRoom
                      ? Icon(Icons.arrow_back)
                      : Icon(Icons.room, color: Colors.deepOrange)),
              Expanded(
                child: Text(
                  widget.curLoc,
                  style: TextStyle(color: Colors.black),
                ),
              )
            ],
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

  Widget drawerWidget(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Drawer(),
    );
  }

  Widget bodyWidget(BuildContext context) {
    String contents = "";
    switch (currentPageIndex) {
      case 0:
        return isCreateRoom
            ? Restaurant_List()
            : Room_List(userId: widget.userId);
      case 1:
        contents = "찜 목록";
        break;
      case 2:
        contents = "검색 화면";
        break;
      case 3:
        contents = "주문 내역";
        break;
      case 4:
        contents = "프로필 화면";
        break;
    }
    return Center(
        child: Text(
      contents,
    ));
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
                        setState(() {
                          isCreateRoom = true;
                        });
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    if (currentPageIndex == 0) {
      if (!isCreateRoom) {
        return Scaffold(
            appBar: appbarWidget(),
            endDrawer: drawerWidget(context),
            body: bodyWidget(context),
            floatingActionButton: floatingActionButtonWidget(),
            bottomNavigationBar: bottomNavigationBarWidget());
      } else {
        return Scaffold(
          appBar: appbarWidget(),
          endDrawer: drawerWidget(context),
          body: bodyWidget(context),
          bottomNavigationBar: bottomNavigationBarWidget(),
        );
      }
    } else if (currentPageIndex == 2) {
      return Scaffold(
        body: bodyWidget(context),
        bottomNavigationBar: bottomNavigationBarWidget(),
      );
    } else {
      return Scaffold(
          appBar: appbarWidget(),
          body: bodyWidget(context),
          bottomNavigationBar: bottomNavigationBarWidget());
    }
  }
}
