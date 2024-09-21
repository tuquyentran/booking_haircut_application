import 'dart:convert';

class Notification {
  int? id;
  int? customer;
  String? content;
  String? dateCreate;

  Notification({
    this.id,
    this.customer,
    this.content,
    this.dateCreate,
  });

  Notification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customer = json['customer'];
    content = json['content'];
    dateCreate = json['dateCreate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['customer'] = customer;
    data['content'] = content;
    data['dateCreate'] = dateCreate;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customer': customer,
      'content': content,
      'dateCreate': dateCreate,
    };
  }

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
        id: map['id'] ?? 0,
        customer: map['customer'] ?? 0,
        content: map['content'] ?? '',
        dateCreate: map['dateCreate'] ?? '');
  }

  String toJsonSQLite() => json.encode(toMap());

  factory Notification.fromJsonSQLite(String source) =>
      Notification.fromMap(json.decode(source));
}
