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
    required this.menuName,
    required this.menuPrice,
    // required this.menuImageDir,
  });

  String menuName;
  int menuPrice;
  // MenuImageDir menuImageDir;

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        menuName: json["menu_name"],
        menuPrice: json["menu_price"],
        // menuImageDir: MenuImageDir.fromJson(json["menu_image_dir"]),
      );

  Map<String, dynamic> toJson() => {
        "menu_name": menuName,
        "menu_price": menuPrice,
        // "menu_image_dir": menuImageDir.toJson(),
      };
}
//
// class MenuImageDir {
//   MenuImageDir({
//     required this.type,
//     required this.data,
//   });
//
//   String type;
//   List<int> data;
//
//   factory MenuImageDir.fromJson(Map<String, dynamic> json) => MenuImageDir(
//         type: json["type"],
//         data: List<int>.from(json["data"].map((x) => x)),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "type": type,
//         "data": List<dynamic>.from(data.map((x) => x)),
//       };
// }
