import 'dart:convert';

import 'package:booking_haircut_application/data/model/ordermodel.dart';
import 'package:booking_haircut_application/data/model/receiptmodel.dart';
import 'package:booking_haircut_application/data/provider/orderprovider.dart';
import 'package:booking_haircut_application/data/provider/receiptprovider.dart';
import 'package:intl/intl.dart';

import '../../data/model/servicemodel.dart';
import '../../data/model/employeemodel.dart';
import '../api/sqlite.dart';

class Branch {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  int? id;
  String? image;
  String? name;
  String? anothername;
  String? address;
  int? type;
  List<Service>? services;
  List<Employee>? employees;
  // List<Order>? lstOrder;
  // List<Receipt>? lstReceipt;

  Branch({
    this.id,
    this.image,
    this.name,
    this.anothername,
    this.address,
    this.type,
    this.services,
    this.employees,
  });

  Future<List<Employee>> _getListEmployee() async {
    return await _databaseHelper.getEmployeesByBranch(id);
  }

  Future<List<Order>> _getListOrder() async {
    return await _databaseHelper.getOrdersByBranch(id);
  }

  Future<List<Receipt>> _getListReceipt() async {
    return await _databaseHelper.getReceiptsByBranch(id);
  }

  Future<List<Order>> filterOrdersToday() async {
    List<Order> list = await _getListOrder();
    DateTime now = DateTime.now();
    String todayString = DateFormat('dd/MM/yyyy').format(now);

    return list.where((order) {
      String dateString = order.date!.trim();
      bool isToday = dateString == todayString;

      return isToday;
    }).toList();
  }

  Future<List<Receipt>> filterReceiptsToday() async {
    List<Receipt> list = await _getListReceipt();
    DateTime now = DateTime.now();
    String todayString = DateFormat('dd/MM/yyyy').format(now);

    return list.where((receipt) {
      String dateString = receipt.dateCreate!.split(', ')[1].trim();
      bool isToday = dateString == todayString;

      return isToday;
    }).toList();
  }

  Future<int?> totalEmployee() async {
    employees = (await _getListEmployee()).cast<Employee>();
    return employees?.where((employee) => employee.state == 1).length;
  }


  Future<int> getTotalOrder() async {
    List<Order>? lstOrder = await _getListOrder();
    return lstOrder
        .where((order) => order.branch == id && order.state == 1)
        .length;
  }

  Future<int> getTotalReceipt() async {
    List<Receipt>? lstReceipt = await _getListReceipt();
    return lstReceipt.where((receipt) => receipt.branch == id).length;
  }

  Future<double> getRevenue() async {
    List<Receipt>? lstReceipt = await _getListReceipt();
    double total = 0;
    lstReceipt.where((receipt) => receipt.branch == id);
    total = lstReceipt.fold(0, (sum, receipt) => sum + receipt.total!);
    return total;
  }

  Future<int> getTotalOrderToday() async {
    List<Order>? lstOrder = await _getListOrder();
    lstOrder.where((order) => order.branch == id);
    var listFilter = await filterOrdersToday();
    return listFilter.length;
  }

  Branch.fromJson(Map<String, dynamic> json)
      : services = (json['services'] as List?)
                ?.map((e) => Service.fromJson(e))
                .toList() ??
            [],
        employees = (json['employees'] as List?)
                ?.map((e) => Employee.fromJson(e))
                .toList() ??
            [] {
    id = json['id'];
    name = json['name'];
    anothername = json['anothername'];
    image = json['image'];
    address = json['address'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['anothername'] = anothername;
    data['image'] = image;
    data['address'] = address;
    data['type'] = type;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'anothername': anothername,
      'address': address,
      'type': type
    };
  }

  factory Branch.fromMap(Map<String, dynamic> map) {
    return Branch(
        id: map['id'] ?? 0,
        name: map['name'] ?? '',
        image: map['image'] ?? '',
        anothername: map['anothername'] ?? '',
        address: map['address'] ?? '',
        type: map['type'] ?? 1);
  }

  String toJsonSQLite() => json.encode(toMap());

  factory Branch.fromJsonSQLite(String source) =>
      Branch.fromMap(json.decode(source));
}
