import 'Menu.dart';

// 한 사람이 주문한 목록
class ShoppingCart {
  ShoppingCart(
      {required this.roomId,
      required this.userId,
      required this.resId,
      required this.menus,
      required this.menusCnt,
      required this.totalPrice});

  int userId;
  int resId;
  int roomId;
  List<Menu> menus;
  Map<String, int> menusCnt;
  int totalPrice;
}
