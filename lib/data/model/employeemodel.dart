import 'dart:convert';

import 'package:booking_haircut_application/data/model/branchmodel.dart';
import 'package:booking_haircut_application/data/provider/branchprovider.dart';

import '../api/sqlite.dart';
import '../provider/orderprovider.dart';
import 'ordermodel.dart';
import 'receiptmodel.dart';
import '../../data/model/picturemodel.dart';

class Employee {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  int? id;
  int? branch;
  String? image;
  String? email;
  String? name;
  String? nickname;
  String? birthday;
  String? phone;
  int? gender;
  int? role;
  int? state;
  List<Picture>? pictures;
  List<Receipt>? receipts;

  Employee({
    this.id,
    this.branch,
    this.image,
    this.email,
    this.name,
    this.nickname,
    this.birthday,
    this.phone,
    this.gender,
    this.state,
    this.role,
    this.pictures,
  });

  Future<void> init() async {
    receipts = await _getListReceipt();
  }

  Future<List<Receipt>> _getListReceipt() async {
    return await _databaseHelper.getReceiptsByEmployee(id);
  }

  Future<List<Order>> _getListOrder() async {
    return await _databaseHelper.getOrdersByEmployee(id);
  }

  Future<String> getBranchID() async {
    List<Branch> lst = await ReadDataBranch().loadData();
    String branchID = lst.where((br) => branch == br.id).toString();
    return branchID;
  }

  Future<int> getTotalOrder() async {
    List<Order>? lstOrder = await _getListOrder();
    return lstOrder
        .where((order) => order.employee == id && order.state == 1)
        .length;
  }

  int? get totalReceipt => receipts?.length;

  int? get totalReceiptwithTip =>
      receipts?.where((receipt) => receipt.tip != 0).length;

  double? get total =>
      receipts?.fold(0, (sum, receipt) => sum! + (receipt.total! * 0.3));

  double? get totalTip =>
      receipts?.fold(0, (sum, receipt) => sum! + receipt.tip!);

  double? get totalBonus =>
      receipts?.fold(0, (sum, receipt) => (totalReceipt! ~/ 10) * 250000);

  double? get salary => totalTip! + totalBonus! + total!;

  Employee.fromJson(Map<String, dynamic> json)
      : pictures = (json['pictures'] as List?)
                ?.map((e) => Picture.fromJson(e))
                .toList() ??
            [],
        receipts = (json['receipts'] as List?)
                ?.map((e) => Receipt.fromJson(e))
                .toList() ??
            [] {
    id = json['id'];
    name = json['name'];
    nickname = json['nickname'];
    image = json['image'];
    email = json['email'];
    branch = json['branch'];
    birthday = json['birthday'];
    phone = json['phone'];
    gender = json['gender'];
    state = json['state'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['nickname'] = nickname;
    data['branch'] = branch;
    data['image'] = image;
    data['birthday'] = birthday;
    data['phone'] = phone;
    data['gender'] = gender;
    data['state'] = state;
    data['role'] = role;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'nickname': nickname,
      'email': email,
      'birthday': birthday,
      'phone': phone,
      'gender': gender,
      'state': state,
      'role': role,
      'branch': branch,
    };
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
        id: map['id'] ?? 0,
        name: map['name'] ?? '',
        image: map['image'] ?? '',
        nickname: map['nickname'] ?? '',
        email: map['email'] ?? '',
        birthday: map['birthday'] ?? '',
        phone: map['phone'] ?? '',
        gender: map['gender'] ?? 0,
        state: map['state'] ?? 1,
        role: map['role'] ?? 0,
        branch: map['branch'] ?? 0);
  }

  String toJsonSQLite() => json.encode(toMap());

  factory Employee.fromJsonSQLite(String source) =>
      Employee.fromMap(json.decode(source));
}
