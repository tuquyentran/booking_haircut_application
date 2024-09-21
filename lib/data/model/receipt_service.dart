import 'dart:convert';

class ReceiptService {
  int? receipt;
  int? service;
  double? price;

  ReceiptService({
    this.receipt,
    this.service,
    this.price,
  });

  ReceiptService.fromJson(Map<String, dynamic> json) {
    receipt = json['receipt'];
    service = json['service'];
    price = json['price']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['receipt'] = receipt;
    data['service'] = service;
    data['price'] = price;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'receipt': receipt,
      'service': service,
      'price': price,
    };
  }

  factory ReceiptService.fromMap(Map<String, dynamic> map) {
    return ReceiptService(
        receipt: map['receipt'] ?? 0,
        service: map['service'] ?? 0,
        price: map['price'] ?? 0);
  }

  String toJsonSQLite() => json.encode(toMap());

  factory ReceiptService.fromJsonSQLite(String source) =>
      ReceiptService.fromMap(json.decode(source));
}
