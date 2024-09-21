import 'package:booking_haircut_application/data/model/branchmodel.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/branch_servicemodel.dart';

class ReadDataBranchService {
  Future<List<BranchService>> loadData() async {
    var data =
        await rootBundle.loadString("assets/database/branch_service.json");
    var dataJson = jsonDecode(data);

    return (dataJson['branch_service'] as List)
        .map((p) => BranchService.fromJson(p))
        .toList();
  }

  Future<void> insertBranchServiceToDB(
      Database db, List<BranchService> list) async {
    for (var item in list) {
      await db.insert(
        'branch_service',
        item.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }
}
