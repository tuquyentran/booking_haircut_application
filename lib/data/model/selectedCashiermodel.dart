import 'package:booking_haircut_application/data/model/branch_servicemodel.dart';
import 'package:booking_haircut_application/data/model/branchmodel.dart';
import 'package:booking_haircut_application/data/model/employeemodel.dart';
import 'package:booking_haircut_application/data/model/servicemodel.dart';
import 'package:flutter/material.dart';

import '../api/sqlite.dart';
import '../provider/branchprovider.dart';
import 'receipt_service.dart';

class SelectedCashierModel extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  List<Service> lstSelected = [];
  Branch? branch = null;
  List<BranchService> lstBranchSer = [];
  List<Employee> lstBranchEmp = [];

  void MakeNull() {
    lstSelected = [];
    lstBranchSer = [];
    lstBranchEmp = [];
  }

  void Logout() {
    lstSelected = [];
    branch = null;
    lstSelected = [];
    lstBranchSer = [];
    lstBranchEmp = [];
    if (branch == null &&
        lstSelected.isEmpty &&
        lstBranchSer.isEmpty &&
        lstBranchEmp.isEmpty) {
      print("Tất cả đều null");
    }
    print("Đã đăng xuất");
  }

  Future<Branch?> _getBranch(int? id) async {
    return await _databaseHelper.getBranchById(id);
  }

  Future<Service?> _getService(int? id) async {
    return await _databaseHelper.getServiceById(id);
  }

  Future<List<BranchService>?> _getListService(int? id) async {
    return await _databaseHelper.getServiceByBranch(id);
  }

  Future<List<Employee>?> _getEmployee(int? id) async {
    return await _databaseHelper.getEmployeesByBranch(id);
  }

  bool serviceSelected(BranchService service) {
    return lstSelected.any((ser) => ser.id == service.service);
  }

  int? get lengthBraSer => lstBranchSer.length;

  void Add(BranchService service) async {
    if (lstSelected.length < 6) {
      Service? ser = await _getService(service.service);
      if (ser != null && !lstSelected.contains(ser)) {
        lstSelected.add(ser);
      }
    }
    notifyListeners();
  }

  void Delete(BranchService service) async {
    Service? ser = await _getService(service.service);
    if (ser != null) {
      print("Removing service: ${ser.name}");
      lstSelected.removeWhere((s) => s.id == ser.id);
      print("Service removed. Updated list: $lstSelected");
    } else {
      print("Service not found: ${service.service}");
    }
    notifyListeners();
  }

  int get totalItems => lstSelected.length;

  double get totalPrice =>
      lstSelected.fold(0, (sum, service) => sum + service.price!);

  int get totalTimes =>
      lstSelected.fold(0, (sum, service) => sum + service.time!);

  // For Branch
  Future<void> MyBranch(int idBranch) async {
    branch == null;
    branch = await _getBranch(idBranch);
    if (branch == null) {
      print("Không lấy được branch");
    } else {
      print(branch?.name ?? 'Không tìm thấy');
      MakeNull();
      lstBranchSer = (await _getListService(branch?.id))!;
      lstBranchEmp = (await _getEmployee(branch?.id))!;
      lstBranchEmp.removeWhere((employee) => employee.role == 1);

      // print(lstBranchEmp)
    }
    notifyListeners();
  }
}
