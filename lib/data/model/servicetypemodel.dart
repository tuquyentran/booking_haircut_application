import 'dart:convert';

import '../../data/model/servicemodel.dart';

class ServiceType {
  int? id;
  String? name;
  List<Service>? services;

  ServiceType({
    this.id,
    this.name,
    this.services,
  });

  ServiceType.fromJson(Map<String, dynamic> json)
      : services = (json['services'] as List?)
                ?.map((e) => Service.fromJson(e))
                .toList() ??
            [] {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory ServiceType.fromMap(Map<String, dynamic> map) {
    return ServiceType(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
    );
  }

  String toJsonSQLite() => json.encode(toMap());

  factory ServiceType.fromJsonSQLite(String source) =>
      ServiceType.fromMap(json.decode(source));
}
