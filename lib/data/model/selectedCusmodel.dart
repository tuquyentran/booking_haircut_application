import 'package:booking_haircut_application/data/model/branchmodel.dart';
import 'package:booking_haircut_application/data/model/employeemodel.dart';
import 'package:booking_haircut_application/data/model/servicemodel.dart';
import 'package:flutter/material.dart';

import '../provider/branchprovider.dart';

class SelectedCusModel extends ChangeNotifier {
  List<Service> lstSelected = [];
  Employee? employee = null;
  Branch? branch = null;
  List<Service> lstBranchSer = [];
  List<Employee> lstBranchEmp = [];

  void MakeNull() {
    employee = null;
    lstSelected = [];
    lstBranchSer = [];
    lstBranchEmp = [];
  }

  bool serviceSelected(Service service) {
    bool selected = false;
    for (var ser in lstSelected) {
      if (ser.name == service.name) {
        selected = true;
      }
    }
    return selected;
  }

  void Add(Service service) {
    if (lstSelected.length < 6) {
      if (!lstSelected.contains(service)) {
        lstSelected.add(service);
      }
    }
    print(lstSelected);
    notifyListeners();
  }

  void Delete(Service service) {
    lstSelected.remove(service);
    notifyListeners();
  }

  int get totalItems => lstSelected.length;

  double get totalPrice =>
      lstSelected.fold(0, (sum, service) => sum + service.price!);

  int get totalTimes =>
      lstSelected.fold(0, (sum, service) => sum + service.time!);

  // For Employee
  bool chosen(Employee? emp) {
    bool chosen = true;
    if (employee?.id == emp?.id) {
      chosen = false;
    }
    return chosen;
  }

  void Choose(Employee? emp) {
    employee = emp;
    notifyListeners();
  }

  // For Branch
  Future<void> FirstBranch() async {
    branch = await ReadDataBranch().loadBranchById(1);
    MakeNull();
    lstBranchSer = branch!.services!;
    lstBranchEmp = branch!.employees!;
    lstBranchEmp.removeWhere((employee) => employee.role == 1);
    notifyListeners();
  }

  bool isSelect(Branch? brnch) {
    bool selected = true;
    if (branch?.id != brnch?.id) {
      selected = false;
    }
    return selected;
  }

  void Selected(Branch? brnch) {
    branch = brnch;
    MakeNull();
    lstBranchSer = branch!.services!;
    lstBranchEmp = branch!.employees!;
    lstBranchEmp.removeWhere((employee) => employee.role == 1);
    notifyListeners();
  }
}
