// To parse this JSON data, do
//
//     final menu = menuFromJson(jsonString);

import 'dart:convert';

List<Menu> menuFromJson(String str) =>
    List<Menu>.from(json.decode(str).map((x) => Menu.fromJson(x)));

String menuToJson(List<Menu> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Menu {
  Menu({
    required this.menuId,
    required this.menuName,
    required this.menuPrice,
    required this.menuImageDir,
  });
  int menuId;
  String menuName;
  int menuPrice;
  String menuImageDir;

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        menuId: json["menu_id"],
        menuName: json["menu_name"],
        menuPrice: json["menu_price"],
        menuImageDir: json["menu_image_dir"],
      );

  Map<String, dynamic> toJson() => {
        "menu_id": menuId,
        "menu_name": menuName,
        "menu_price": menuPrice,
        "menu_image_dir": menuImageDir,
      };
}
