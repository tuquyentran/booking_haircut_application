import 'package:booking_haircut_application/data/model/customermodel.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

class ReadDataCustomer {
  Future<List<Customer>> loadData() async {
    try {
      final data =
          await rootBundle.loadString("assets/files/customerlist.json");
      final jsonData = json.decode(data) as Map<String, dynamic>;
      final dataJson = jsonData['customer'] as List<dynamic>;
      return dataJson.map((p) => Customer.fromJson(p)).toList();
    } catch (e) {
      print("Error loading customer data: $e");
      return []; // Return an empty list on error
    }
  }

  Future<List<Customer>> loadDataDB() async {
    var data = await rootBundle.loadString("assets/database/customer.json");
    var dataJson = jsonDecode(data);

    return (dataJson['customer'] as List)
        .map((p) => Customer.fromJson(p))
        .toList();
  }

  Future<void> insertCustomerToDB(Database db, List<Customer> list) async {
    for (var customer in list) {
      await db.insert(
        'customer',
        customer.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  // Future<List<Customer>> loadData() async {
  //   try {
  //     final data =
  //         await rootBundle.loadString("assets/files/customerlist.json");
  //     final dataJson = jsonDecode(data);
  //     List<Customer> customers = (dataJson['customer'] as List)
  //         .map((p) => Customer.fromJson(p))
  //         .toList();
  //     print("Loaded customers: $customers"); // Log list of customers
  //     return customers;
  //   } catch (e) {
  //     print("Error loading customer data: $e");
  //     return []; // Return an empty list on error
  //   }
  // }
}
