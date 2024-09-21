import 'package:booking_haircut_application/data/model/branchmodel.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ReadDataBranch {
  Future<List<Branch>> loadData() async {
    var data = await rootBundle.loadString("assets/files/branchlist.json");
    var dataJson = jsonDecode(data);

    return (dataJson['branch'] as List).map((p) => Branch.fromJson(p)).toList();
  }

  Future<List<Branch>> loadDataDB() async {
    var data = await rootBundle.loadString("assets/database/branch.json");
    var dataJson = jsonDecode(data);

    return (dataJson['branch'] as List).map((p) => Branch.fromJson(p)).toList();
  }

  Future<Branch?> loadBranchById(int? id) async {
    var branchList = await loadData();

    for (var branch in branchList) {
      if (branch.id == id) {
        return branch;
      }
    }
    return null;
  }

  Future<void> insertBranchToDB(Database db, List<Branch> list) async {
    for (var branch in list) {
      await db.insert(
        'branch',
        branch.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }
}
