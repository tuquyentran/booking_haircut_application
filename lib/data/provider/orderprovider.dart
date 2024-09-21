import 'package:booking_haircut_application/data/model/ordermodel.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

class ReadDataOrder {
  Future<List<Order>> loadData() async {
    var data = await rootBundle.loadString("assets/files/orderlist.json");
    var dataJson = jsonDecode(data);

    return (dataJson['order'] as List).map((p) => Order.fromJson(p)).toList();
  }

  Future<List<Order>?> loadOrderBranch(int? id) async {
    var lstOrder = await loadData();

    lstOrder.where((order) => order.branch == id);
    if (lstOrder.isEmpty) {
      return null;
    }
    return lstOrder;
  }

  Future<List<Order>> loadOrderByIdCus(int? idCus) async {
    var orderList = await loadData();
    var customerOrders = <Order>[];

    for (var order in orderList) {
      if (order.customer == idCus) {
        customerOrders.add(order);
      }
    }
    return customerOrders;
  }

  Future<List<Order>> loadDataDB() async {
    var data = await rootBundle.loadString("assets/database/order.json");
    var dataJson = jsonDecode(data);

    return (dataJson['order'] as List).map((p) => Order.fromJson(p)).toList();
  }

  Future<void> insertOrderToDB(Database db, List<Order> list) async {
    for (var order in list) {
      await db.insert(
        'order',
        order.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }
}
