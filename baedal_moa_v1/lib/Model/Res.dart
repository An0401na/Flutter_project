// To parse this JSON data, do
//
//     final res = resFromJson(jsonString);

import 'dart:convert';

List<Res> resFromJson(String str) =>
    List<Res>.from(json.decode(str).map((x) => Res.fromJson(x)));

String resToJson(List<Res> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Res {
  Res({
    required this.resId,
    required this.resName,
    required this.resLocation,
    required this.resCategory,
    required this.resInformation,
    required this.resMinOrderPrice,
    required this.resImageDir,
  });

  int resId;
  String resName;
  String resLocation;
  String resCategory;
  String resInformation;
  int resMinOrderPrice;
  ResImageDir resImageDir;

  factory Res.fromJson(Map<String, dynamic> json) => Res(
        resId: json["res_id"],
        resName: json["res_name"],
        resLocation: json["res_location"],
        resCategory: json["res_category"],
        resInformation: json["res_information"],
        resMinOrderPrice: json["res_min_order_price"],
        resImageDir: ResImageDir.fromJson(json["res_image_dir"]),
      );

  Map<String, dynamic> toJson() => {
        "res_id": resId,
        "res_name": resName,
        "res_location": resLocation,
        "res_category": resCategory,
        "res_information": resInformation,
        "res_min_order_price": resMinOrderPrice,
        "res_image_dir": resImageDir.toJson(),
      };
}

class ResImageDir {
  ResImageDir({
    required this.type,
    required this.data,
  });

  String type;
  List<int> data;

  factory ResImageDir.fromJson(Map<String, dynamic> json) => ResImageDir(
        type: json["type"],
        data: List<int>.from(json["data"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "data": List<dynamic>.from(data.map((x) => x)),
      };
}
