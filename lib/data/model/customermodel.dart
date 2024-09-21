import 'dart:convert';

import '../../data/model/notificationmodel.dart';
import 'receiptmodel.dart';
import '../../data/model/ordermodel.dart';

class Customer {
  int? id;
  String? image;
  String? name;
  String? phone;
  String? email;
  String? password;
  List<Receipt>? receipts;
  List<Order>? orders;
  List<Notification>? notifications;

  Customer({
    this.id,
    this.image,
    this.name,
    this.phone,
    this.email,
    this.password,
    this.receipts,
    this.orders,
    this.notifications,
  });

  Customer.fromJson(Map<String, dynamic> json)
      : receipts = (json['receipts'] as List?)
                ?.map((e) => Receipt.fromJson(e))
                .toList() ??
            [],
        orders =
            (json['orders'] as List?)?.map((e) => Order.fromJson(e)).toList() ??
                [],
        notifications = (json['notifications'] as List?)
                ?.map((e) => Notification.fromJson(e))
                .toList() ??
            [] {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    phone = json['phone'];
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['phone'] = phone;
    data['email'] = email;
    data['password'] = password;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'phone': phone,
      'email': email,
      'password': password
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
        id: map['id'] ?? 0,
        name: map['name'] ?? '',
        image: map['image'] ?? '',
        phone: map['phone'] ?? '',
        email: map['email'] ?? '',
        password: map['password'] ?? '');
  }

  String toJsonSQLite() => json.encode(toMap());

  factory Customer.fromJsonSQLite(String source) =>
      Customer.fromMap(json.decode(source));
}
