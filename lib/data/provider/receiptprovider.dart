import 'package:booking_haircut_application/data/model/receiptmodel.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

class ReadDataReceipt {
  Future<List<Receipt>> loadData() async {
    var data = await rootBundle.loadString("assets/files/receiptlist.json");
    var dataJson = jsonDecode(data);

    return (dataJson['receipt'] as List)
        .map((p) => Receipt.fromJson(p))
        .toList();
  }

  Future<List<Receipt>?> loadReceiptBranch(int? id) async {
    var lstReceipt = await loadData();

    lstReceipt.where((receipt) => receipt.branch == id);
    if (lstReceipt.isEmpty) {
      return null;
    }
    return lstReceipt;
  }

  Future<List<Receipt>> loadReceiptByIdCus(int? idCus) async {
    var receiptList = await loadData();
    var customerReceipt = <Receipt>[];

    for (var receipt in receiptList) {
      if (receipt.customer == idCus) {
        customerReceipt.add(receipt);
      }
    }
    return customerReceipt;
  }

  Future<List<Receipt>> loadDataDB() async {
    var data = await rootBundle.loadString("assets/database/receipt.json");
    var dataJson = jsonDecode(data);

    return (dataJson['receipt'] as List)
        .map((p) => Receipt.fromJson(p))
        .toList();
  }

  Future<void> insertReceiptToDB(Database db, List<Receipt> list) async {
    for (var order in list) {
      await db.insert(
        'receipt',
        order.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }
}
