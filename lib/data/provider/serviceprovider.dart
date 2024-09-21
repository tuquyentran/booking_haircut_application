import 'package:booking_haircut_application/data/model/servicemodel.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

import '../model/servicetypemodel.dart';

class ReadDataService {
  Future<List<Service>> loadData() async {
    final data =
        await rootBundle.loadString("assets/files/servicetypelist.json");

    final jsonData = json.decode(data) as Map<String, dynamic>;
    final dataJson = jsonData['services'] as List<dynamic>;
    return dataJson.map((p) => Service.fromJson(p)).toList();
  }

  static Future<List<String>> loadServiceTypes() async {
    final data =
        await rootBundle.loadString('assets/files/servicetypelist.json');
    final jsonData = json.decode(data) as Map<String, dynamic>;

    final List<dynamic> servicetypes = jsonData['servicetype'];

    // Trích xuất danh sách các loại dịch vụ từ dữ liệu
    Set<String> typeSet = Set(); // Sử dụng Set để đảm bảo không trùng lặp

    // for (var serviceType in servicetypes) {
    //   if (serviceType.services != null) {
    //     for (var service in serviceType.services!) {
    //       String? type = service.type;
    //       if (type != null && type.isNotEmpty) {
    //         typeSet.add(type);
    //       }
    //     }
    //   }
    // }
    for (var serviceType in servicetypes) {
      if (serviceType['services'] != null) {
        for (var service in serviceType['services']) {
          String? type = service['type'];
          if (type != null && type.isNotEmpty) {
            typeSet.add(type);
          }
        }
      }
    }

    return typeSet.toList(); // Chuyển từ Set sang List để sử dụng
  }

  Future<List<Service>> loadDataDB() async {
    var data = await rootBundle.loadString("assets/database/service.json");
    var dataJson = jsonDecode(data);

    return (dataJson['service'] as List)
        .map((p) => Service.fromJson(p))
        .toList();
  }

  Future<void> insertServiceToDB(Database db, List<Service> list) async {
    for (var service in list) {
      await db.insert(
        'service',
        service.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }
}
