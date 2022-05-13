import 'package:flutter/material.dart';
import 'package:reslist_json_parsion/Restaurant_info.dart';
import 'Services.dart';
import 'Res.dart';

class JsonParseDemo extends StatefulWidget {
  JsonParseDemo() : super();

  @override
  _JsonParseDemoState createState() => _JsonParseDemoState();
}

class _JsonParseDemoState extends State<JsonParseDemo> {
  late List<Res> _res = [];
  late bool _loading;

  void initState() {
    super.initState();
    _loading = true;
    // Services.getRests().then((Res1) {
    //   print("aaa");
    //   _res = Res1;
    //   _loading = false;
    // });
    Services.getRests().then((Res1) {
      setState(() {
        _res = Res1;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_loading ? 'Loading ... ' 'Json Parsing' : '가게 목록'),
        ),
        body: Container(
          color: Colors.white,
          child: ListView.builder(
              itemCount: null == _res ? 0 : _res.length,
              itemBuilder: (context, index) {
                Res res = _res[index];
                return ListTile(
                  title: Text(res.resName),
                  subtitle:
                      Text('최소주문 금액 : ' + res.resMinOrderPrice.toString()),
                  onTap: () {
                    Services.postRest(res.resName.toString());
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Restaurant_info(res: res),
                        ));
                  },
                );
              }),
        ));
  }
}
