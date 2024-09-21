import 'dart:convert';

import '../../data/model/servicemodel.dart';

class Order {
  int? id;
  int? customer;
  String? name;
  int? branch;
  int? employee;
  String? phone;
  String? date;
  String? time;
  String? note;
  int? state;
  double? total;
  String? dateCreate;
  List<Service>? services;

  Order({
    this.id,
    this.customer,
    this.name,
    this.branch,
    this.employee,
    this.phone,
    this.date,
    this.time,
    this.total,
    this.note,
    this.services,
    this.state,
    this.dateCreate,
  });

  Order.fromJson(Map<String, dynamic> json)
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
    date = json['date'];
    time = json['time'];
    note = json['note'];
    state = json['state'];
    dateCreate = json['dateCreate'];
    total = json['total']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['customer'] = customer;
    data['name'] = name;
    data['branch'] = branch;
    data['employee'] = employee;
    data['phone'] = phone;
    data['date'] = date;
    data['time'] = time;
    data['note'] = note;
    data['state'] = state;
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
      'date': date,
      'time': time,
      'note': note,
      'total': total,
      'state': state,
      'dateCreate': dateCreate,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
        id: map['id'] ?? 0,
        branch: map['branch'] ?? 0,
        customer: map['customer'] ?? 0,
        employee: map['employee'] ?? 0,
        name: map['name'] ?? '',
        phone: map['phone'] ?? '',
        date: map['date'] ?? '',
        time: map['time'] ?? '',
        note: map['note'] ?? '',
        total: map['total'] ?? 0,
        state: map['state'] ?? 0,
        dateCreate: map['dateCreate'] ?? '');
  }

  String toJsonSQLite() => json.encode(toMap());

  factory Order.fromJsonSQLite(String source) =>
      Order.fromMap(json.decode(source));
}
