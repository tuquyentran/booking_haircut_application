import 'dart:convert';

class Picture {
  int? id;
  int? employee;
  String? image;

  Picture({
    this.id,
    this.employee,
    this.image,
  });

  Picture.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employee = json['employee'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['employee'] = employee;
    data['image'] = image;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'employee': employee,
      'image': image,
    };
  }

  factory Picture.fromMap(Map<String, dynamic> map) {
    return Picture(
        id: map['id'] ?? 0,
        image: map['image'] ?? '',
        employee: map['employee'] ?? 0);
  }

  String toJsonSQLite() => json.encode(toMap());

  factory Picture.fromJsonSQLite(String source) =>
      Picture.fromMap(json.decode(source));
}
