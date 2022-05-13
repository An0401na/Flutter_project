import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp()); //앱 구동 시켜주세요~
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // home: Center(
        //     child: Container(
        //         width: 50, height: 50, color: Colors.blue))); //페이지에 위젯을 넣어 디자인
        home: Scaffold(
            appBar: AppBar(),
            body: Container(
                width: 500,
                height: 500,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.star),
                      Icon(Icons.shop),
                      Icon(Icons.shop)
                    ])),
            bottomNavigationBar: BottomAppBar(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(.)
                ],
              ))
            ));
  }
}

/*
1. Icon을 넣을때는 Icon(Icons.아이콘이름)
2. 이미지를 넣을때는 Image.assets('이미지경로')
프로젝트 안 asset폴더 안에 존재해야함. (assets 폴더는 직접만들어주기)
이미지를 사용하기 전 pubspec.yaml 파일에 등록해야함.
pubspec.yaml => 앱 만들때 필요한 자료들을 정리해논 파일 (패키지, 라이브러리 등등)
"flutter : " 아래에  <>코드 추가해서 이미지 등록
<추가할 코드>
assets :
  - assets/     => assets 폴더 안 이미지를 모두 등록한다는 의미
3. text 넣을때는 Text('헬로우')
4. 네모 박스를 넣을때는 Container(width: 50, height: 50, color: Colors.blue) 혹은 SizedBox()
단위는 LP 50LP는 1.2cm
Container()
이렇게만해서 코드를 돌렸을때 박스가 화면에 다 차는 이유는 범위를 지정해주지 않았기 때문
Center()를 이용해서 범위를 지정해주자 !
home: Center(
            child: Container(
                width: 50, height: 50, color: Colors.blue)));
Container는 Center의 자식 위젯
child 는 항상 쓰는게 아니라 쓰는 위젯이 정해져 있으니 주의하자!

*/

/*
MaterialApp() 위젯은 구글이 제공하는 matarial 테마를 사용할 수 있다. 다만 구글 스타일임
Cupertino() 위젯은 아이폰 스타일의 테마를 사용할 수 있다.
나만의 스타일의 앱을 만들고 싶을때도 MaterialApp()을 넣어놓고 시작하면 된다. 디자인 뿐만 아니라 기본 셋팅도 제공하기 때문

<위젯 배치를 위한 위젯>
- Scaffold() 위젯 앱의 상단, 중간, 하단 을 만들기 위해서 사용.
이 위젯을 사용하게 되면 기준점을 왼쪽으로 잡아준다.
- Row(children :[]) 여러개의 위젯을 화면에 가로로 배치하기 위해서 사용
여러개의 위젯을 자식 위젯으로 넣어야하니까 children : 을 써서 다수의 위젯을넣어준다.
body: Row(children: [Icon(Icons.star), Icon(Icons.shop)])
- Column(children :[]) Row()와 반대로 여러개의 위젯을 세로로 배치하기 위해서 사용
- mainAxisAlignment : MainAxisAlignment.~~~ 사용하여 Row, Column 요소 위젯의 배치방법을 설정할 수 있다.
~~~ : center -> 가운데 정렬
    : spaceEvenly -> 띄엄띄엄
- crossAxisAlignment : CrossAxisAlignment.~~~ 사용하여  Row, Column 요소 위젯의 반대 방향으로 배치 방법을 설정할 수 있다.
즉 Row 안에 main뭐시기는 가로로 배치를 어떻게 할것인가, cross는 row방향(가로)와 크로스 교차하는 방향이니까 즉 세로를 말한다.
그렇다면 Column 은 main 머시기 일때는 세로이고, cross는 가로방향의 배치를 어떻게 할것인지를 말한다.

TIP!
속성.~~~~ 에서 ~~가 뭐뭐 있는지 잘 모르겠다 => 자동완성 ctrl + space
파라미터 : ~~~~에서 ~~가 뭐뭐 있는지 모르겠다. => 파라미터를 대문자로 써본다. or 파라미터에 마우스를 올리면 Type: 해가지고 나오는데 그걸 그대로 적어본다. or 구글링
 */

//Container 안에 Row를 활용하여 상하 폭 을 주어 cross 할때 상하 정렬해보기
//상단바, 하단바에 Icons.phone, Icons,message, Icons.contact_page 를 띄엄띄엄 넣어보기, 중간에 글자 넣어보기
