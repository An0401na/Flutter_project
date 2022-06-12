import 'package:http/http.dart' as http;

class Services_Nickname {
  static Future<void> changedNickname(String userId, String Nickname) async {
    try {
      String __url = 'http://203.249.22.50:8080/userprofile/update';
      http.post(Uri.parse(__url), headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      }, body: {
        "user_id": userId,
        "nickname": Nickname
      }).then((res) {
        print("changedNickname 상태 코드 : " + res.statusCode.toString());
      }).catchError((error) => print("likeRes 에러 : " + error.toString()));
    } catch (error) {
      print('changedNickname 에러 : ' + error.toString());
    }
  }
}
