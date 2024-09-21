import 'dart:convert';

class OrderService {
  int? order;
  int? service;
  double? price;

  OrderService({
    this.order,
    this.service,
    this.price,
  });

  OrderService.fromJson(Map<String, dynamic> json) {
    order = json['order'];
    service = json['service'];
    price = json['price']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order'] = order;
    data['service'] = service;
    data['price'] = price;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'order': order,
      'service': service,
      'price': price,
    };
  }

  factory OrderService.fromMap(Map<String, dynamic> map) {
    return OrderService(
        order: map['order'] ?? 0,
        service: map['service'] ?? 0,
        price: map['price'] ?? 0.0);
  }

  String toJsonSQLite() => json.encode(toMap());

  factory OrderService.fromJsonSQLite(String source) =>
      OrderService.fromMap(json.decode(source));
}
