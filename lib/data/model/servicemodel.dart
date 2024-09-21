import 'dart:convert';

class Service {
  int? id;
  String? name;
  int? type;
  int? time;
  double? price;

  Service({
    this.id,
    this.name,
    this.type,
    this.time,
    this.price,
  });

  Service.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    time = json['time'];
    price = json['price']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['type'] = type;
    data['time'] = time;
    data['price'] = price;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'time': time,
      'price': price,
      'type': type,
    };
  }

  factory Service.fromMap(Map<String, dynamic> map) {
    return Service(
        id: map['id'] ?? 0,
        name: map['name'] ?? '',
        time: map['time'] ?? '',
        price: map['price'] ?? 0.0,
        type: map['type'] ?? 0);
  }

  String toJsonSQLite() => json.encode(toMap());

  factory Service.fromJsonSQLite(String source) =>
      Service.fromMap(json.decode(source));
}
