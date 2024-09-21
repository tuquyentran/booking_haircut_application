import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import '../model/order_servicemodel.dart';

class ReadDataOrderService {
  Future<List<OrderService>> loadData() async {
    var data =
        await rootBundle.loadString("assets/database/order_service.json");
    var dataJson = jsonDecode(data);

    return (dataJson['order_service'] as List)
        .map((p) => OrderService.fromJson(p))
        .toList();
  }

  Future<void> insertOrderServiceToDB(
      Database db, List<OrderService> list) async {
    for (var item in list) {
      await db.insert(
        'order_service',
        item.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }
}
