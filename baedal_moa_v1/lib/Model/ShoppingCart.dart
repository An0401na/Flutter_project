import 'Menu.dart';

// 한 사람이 주문한 목록
class ShoppingCart {
  ShoppingCart(
      {required this.resId,
      required this.menus,
      required this.menusCnt,
      required this.totalPrice});

  int resId;
  List<Menu> menus;
  Map<String, int> menusCnt;
  int totalPrice;
}
