import 'dart:convert';

import 'package:baedal_moa/Model/ShoppingCart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Model/Order.dart';

class Services_Order {
  static const String url = 'http://203.249.22.50:8080/order';

  static Future<List<Order>> getOrders(String userId) async {
    try {
      final response =
          await http.post(Uri.parse(url), headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      }, body: {
        "user_id": userId
      });
      print("getOrders의 상태코드  : " + response.statusCode.toString());
      if (200 == response.statusCode) {
        final List<Order> orderList = orderFromJson(response.body);
        return orderList;
      } else {
        print('Order empty');
        return <Order>[];
      }
    } catch (e) {
      return <Order>[];
    }
  }
}
