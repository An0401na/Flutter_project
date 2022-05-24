import 'package:baedal_moa/Model/ShoppingCart.dart';
import 'package:http/http.dart' as http;
import '../Model/ShoppingCart.dart';

class Services_ShoppingCart {
  static Future<void> postShoppingCart(ShoppingCart shoppingCart) async {
    try {
      String __url = 'http://203.249.22.50:8080/shoppingcart';
      http.post(Uri.parse(__url), headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      }, body: {
        "userId": shoppingCart.userId.toString(),
        "resId": shoppingCart.resId.toString(),
        "menus": shoppingCart.menus,
        "menusCnt": shoppingCart.menusCnt,
        "totalPrice": shoppingCart.totalPrice.toString()
      }).then((res) {
        print("postShoppingCart의 상태 코드 : " + res.statusCode.toString());
      }).catchError(
          (error) => print("postShoppingCart에러 : " + error.toString()));
    } catch (error) {
      print('postShoppingCart 에러 : ' + error.toString());
    }
  }
}
