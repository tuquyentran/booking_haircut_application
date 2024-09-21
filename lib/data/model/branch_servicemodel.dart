import 'dart:convert';

import '../api/sqlite.dart';
import 'servicemodel.dart';

class BranchService {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  int? branch;
  int? service;
  double? price;

  BranchService({
    this.branch,
    this.service,
    this.price,
  });

  BranchService.fromJson(Map<String, dynamic> json) {
    branch = json['branch'];
    service = json['service'];
    price = json['price']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['branch'] = branch;
    data['service'] = service;
    data['price'] = price;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'branch': branch,
      'service': service,
      'price': price,
    };
  }

  factory BranchService.fromMap(Map<String, dynamic> map) {
    return BranchService(
        branch: map['branch'] ?? 0,
        service: map['service'] ?? 0,
        price: map['price'] ?? 0);
  }

  String toJsonSQLite() => json.encode(toMap());

  factory BranchService.fromJsonSQLite(String source) =>
      BranchService.fromMap(json.decode(source));
}
