import 'dart:convert';

import 'package:intl/intl.dart';
import '../../data/model/servicemodel.dart';

class Receipt {
  int? id;
  int? customer;
  String? name;
  int? branch;
  int? employee;
  String? email;
  String? phone;
  double? tip;
  double? total;
  String? dateCreate;
  List<Service>? services;

  Receipt({
    this.id,
    this.customer,
    this.name,
    this.branch,
    this.employee,
    this.phone,
    this.total,
    this.tip,
    this.services,
    this.dateCreate,
  });

  Receipt.fromJson(Map<String, dynamic> json)
      : services = (json['services'] as List?)
                ?.map((e) => Service.fromJson(e))
                .toList() ??
            [] {
    id = json['id'];
    customer = json['customer'];
    name = json['name'];
    branch = json['branch'];
    employee = json['employee'];
    phone = json['phone'];
    tip = json['tip']?.toDouble();
    dateCreate = json['dateCreate'];
    total = json['total']?.toDouble();
    if (services != null && total == 0) {
      total =
          total! + services!.fold(0, (sum, item) => sum + (item.price ?? 0));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['customer'] = customer;
    data['name'] = name;
    data['branch'] = branch;
    data['employee'] = employee;
    data['phone'] = phone;
    data['tip'] = tip;
    data['dateCreate'] = dateCreate;
    data['total'] = total;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'branch': branch,
      'customer': customer,
      'employee': employee,
      'name': name,
      'phone': phone,
      'tip': tip,
      'total': total,
      'dateCreate': dateCreate,
    };
  }

  factory Receipt.fromMap(Map<String, dynamic> map) {
    return Receipt(
        id: map['id'] ?? 0,
        branch: map['branch'] ?? 0,
        customer: map['customer'] ?? 0,
        employee: map['employee'] ?? 0,
        name: map['name'] ?? '',
        phone: map['phone'] ?? '',
        tip: map['tip'] ?? 0.0,
        total: map['total'] ?? 0.0,
        dateCreate: map['dateCreate'] ?? '');
  }

  String toJsonSQLite() => json.encode(toMap());

  factory Receipt.fromJsonSQLite(String source) =>
      Receipt.fromMap(json.decode(source));
}
