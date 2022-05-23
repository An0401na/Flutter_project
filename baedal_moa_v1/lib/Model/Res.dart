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
    required this.deliveryFees,
  });

  int resId;
  String resName;
  String resLocation;
  String resCategory;
  String resInformation;
  int resMinOrderPrice;
  String resImageDir;
  List<DeliveryFee> deliveryFees;

  factory Res.fromJson(Map<String, dynamic> json) => Res(
        resId: json["res_id"],
        resName: json["res_name"],
        resLocation: json["res_location"],
        resCategory: json["res_category"],
        resInformation: json["res_information"],
        resMinOrderPrice: json["res_min_order_price"],
        resImageDir: json["res_image_dir"],
        deliveryFees: List<DeliveryFee>.from(
            json["delivery_fees"].map((x) => DeliveryFee.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "res_id": resId,
        "res_name": resName,
        "res_location": resLocation,
        "res_category": resCategory,
        "res_information": resInformation,
        "res_min_order_price": resMinOrderPrice,
        "res_image_dir": resImageDir,
        "delivery_fees":
            List<dynamic>.from(deliveryFees.map((x) => x.toJson())),
      };
}

class DeliveryFee {
  DeliveryFee({
    required this.delFee,
    required this.delMinOrderPrice,
  });

  int delFee;
  int delMinOrderPrice;

  factory DeliveryFee.fromJson(Map<String, dynamic> json) => DeliveryFee(
        delFee: json["del_fee"],
        delMinOrderPrice: json["del_min_order_price"],
      );

  Map<String, dynamic> toJson() => {
        "del_fee": delFee,
        "del_min_order_price": delMinOrderPrice,
      };
}
