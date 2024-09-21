import 'dart:convert';

class Feedback {
  int? id;
  int? receipt;
  int? rate;
  String? content;

  Feedback({
    this.id,
    this.receipt,
    this.content,
    this.rate,
  });

  Feedback.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    receipt = json['receipt'];
    rate = json['rate'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['receipt'] = receipt;
    data['rate'] = rate;
    data['content'] = content;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'receipt': receipt,
      'rate': rate,
      'content': content,
    };
  }

  factory Feedback.fromMap(Map<String, dynamic> map) {
    return Feedback(
        id: map['id'] ?? 0,
        receipt: map['receipt'] ?? 0,
        rate: map['rate'] ?? 0,
        content: map['content'] ?? '');
  }

  String toJsonSQLite() => json.encode(toMap());

  factory Feedback.fromJsonSQLite(String source) =>
      Feedback.fromMap(json.decode(source));
}
