import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import '../model/receipt_service.dart';

class ReadDataReceiptService {
  Future<List<ReceiptService>> loadData() async {
    var data =
        await rootBundle.loadString("assets/database/receipt_service.json");
    var dataJson = jsonDecode(data);

    return (dataJson['receipt_service'] as List)
        .map((p) => ReceiptService.fromJson(p))
        .toList();
  }

  Future<void> insertReceiptServiceToDB(
      Database db, List<ReceiptService> list) async {
    for (var item in list) {
      await db.insert(
        'receipt_service',
        item.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }
}
