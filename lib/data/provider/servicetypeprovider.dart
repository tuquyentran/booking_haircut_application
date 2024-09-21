import 'package:booking_haircut_application/data/model/servicetypemodel.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

class ReadDataServiceType {
  Future<List<ServiceType>> loadData() async {
    var data = await rootBundle.loadString("assets/files/servicetypelist.json");
    var dataJson = jsonDecode(data);

    return (dataJson['servicetype'] as List)
        .map((p) => ServiceType.fromJson(p))
        .toList();
  }

  Future<ServiceType?> loadTypeById(int? id) async {
    var servicetypeList = await loadData();

    for (var servicetype in servicetypeList) {
      if (servicetype.id == id) {
        print(servicetype.name.toString());
        return servicetype;
      }
    }
    return null;
  }

  Future<List<ServiceType>> loadDataDB() async {
    var data = await rootBundle.loadString("assets/database/servicetype.json");
    var dataJson = jsonDecode(data);

    return (dataJson['servicetype'] as List)
        .map((p) => ServiceType.fromJson(p))
        .toList();
  }

  Future<void> insertServiceTypeToDB(
      Database db, List<ServiceType> list) async {
    for (var servicetype in list) {
      await db.insert(
        'service_type',
        servicetype.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }
}
