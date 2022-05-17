import 'Menu.dart';

class ShoppingCart {
  ShoppingCart({
    required this.resId,
    required this.menus,
    required this.menusCnt});

  int resId;
  List<Menu> menus;
  Map<String, int> menusCnt;
}
