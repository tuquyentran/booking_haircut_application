import 'package:booking_haircut_application/data/model/employeemodel.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

import 'dart:io';
import 'dart:convert';

import 'package:sqflite/sqflite.dart';

class ReadDataEmployee {
  String formatNumber(int number, int length) {
    return number.toString().padLeft(length, '0');
  }

  Future<List<Employee>> loadData() async {
    try {
      final data =
          await rootBundle.loadString("assets/files/employeelist.json");
      final jsonData = json.decode(data) as Map<String, dynamic>;
      final dataJson = jsonData['employee'] as List<dynamic>;
      return dataJson.map((p) => Employee.fromJson(p)).toList();
    } catch (e) {
      print("Error loading employee data: $e");
      return []; // Return an empty list on error
    }
  }

  Future<Employee?> loadTypeById(int? id) async {
    var employeeList = await loadData();

    for (var employee in employeeList) {
      if (employee.id == id) {
        print(employee.name.toString());
        return employee;
      }
    }
    return null;
  }

  Future<List<String>> loadBranches() async {
    final String dataPath = "assets/files/employeelist.json";
    final data = await rootBundle.loadString(dataPath);
    final jsonData = json.decode(data) as Map<String, dynamic>;
    final List<dynamic> employees = jsonData['employee'];

    // Trích xuất danh sách các chi nhánh từ dữ liệu JSON
    Set<String> branchSet = Set(); // Sử dụng Set để đảm bảo không trùng lặp

    for (var employee in employees) {
      String? branch = employee['branch'];
      if (branch != null && branch.isNotEmpty) {
        branchSet.add(branch);
      }
    }

    return branchSet
        .toList(); // Chuyển từ Set sang List để sử dụng cho dropdown
  }

  Future<void> addEmployee(Employee newEmployee) async {
    try {
      // Đọc nội dung tệp JSON
      final String jsonString =
          await rootBundle.loadString('assets/files/employeelist.json');
      final List<dynamic> jsonResponse = json.decode(jsonString);

      // Chuyển đổi danh sách JSON thành danh sách các đối tượng Employee
      List<Employee> employees =
          jsonResponse.map((data) => Employee.fromJson(data)).toList();

      // Thêm đối tượng Employee mới vào danh sách
      employees.add(newEmployee);

      // Chuyển đổi danh sách các đối tượng Employee thành JSON
      String updatedJsonString =
          json.encode(employees.map((e) => e.toJson()).toList());

      // Ghi lại nội dung mới vào tệp JSON
      final file = File('assets/files/employeelist.json');
      await file.writeAsString(updatedJsonString);
    } catch (e) {
      print("Error adding employee: $e");
    }
    // var employeeList = await loadData();
    // employeeList.add(newEmployee);

    // // Convert to JSON format
    // List<Map<String, dynamic>> jsonList =
    //     employeeList.map((e) => e.toJson()).toList();
    // Map<String, dynamic> jsonData = {'employee': jsonList};

    // // Write to employee.json file
    // final file = File("assets/jsonfiles/employeelist.json");
    // await file.writeAsString(json.encode(jsonData));
  }

  Future<String> getNextEmployeeId() async {
    var employeeList = await loadData();

    // Find the highest existing ID number
    int maxId = 0;
    for (var employee in employeeList) {
      String currentId = employee.id.toString() ?? '';
      if (currentId.startsWith('NV')) {
        try {
          int idNumber = int.parse(currentId.substring(2));
          if (idNumber > maxId) {
            maxId = idNumber;
          }
        } catch (e) {
          // Ignore parsing errors
        }
      }
    }

    // Generate new ID
    String newId = 'NV${formatNumber((maxId + 1), 6)}';
    return newId;
  }

// Load roles from JSON
  // Future<List<int>> loadRoles() async {
  //   final String dataPath = "assets/jsonfiles/employeelist.json";
  //   final data = await rootBundle.loadString(dataPath);
  //   final jsonData = json.decode(data) as Map<String, dynamic>;
  //   final List<dynamic> employees = jsonData['employee'];

  //   // Extract roles from JSON data
  //   Set<int> roleSet = Set();

  //   for (var employee in employees) {
  //     int? role = employee['role'];
  //     if (role != null) {
  //       roleSet.add(role);
  //     }
  //   }

  //   return roleSet.toList();
  // }

  // // Load states from JSON
  // Future<List<int>> loadStates() async {
  //   final String dataPath = "assets/jsonfiles/employeelist.json";
  //   final data = await rootBundle.loadString(dataPath);
  //   final jsonData = json.decode(data) as Map<String, dynamic>;
  //   final List<dynamic> employees = jsonData['employee'];

  //   // Extract states from JSON data
  //   Set<int> stateSet = Set();

  //   for (var employee in employees) {
  //     int? state = employee['state'];
  //     if (state != null) {
  //       stateSet.add(state);
  //     }
  //   }

  //   return stateSet.toList();
  // }

  Future<Employee?> loadEmployeeById(int? id) async {
    var employeeList = await loadData();

    for (var employee in employeeList) {
      if (employee.id == id) {
        return employee;
      }
    }
    return null; // Nếu không tìm thấy branch với id này
  }

  Future<List<Employee>> loadDataDB() async {
    var data = await rootBundle.loadString("assets/database/employee.json");
    var dataJson = jsonDecode(data);

    return (dataJson['employee'] as List)
        .map((p) => Employee.fromJson(p))
        .toList();
  }

  Future<void> insertEmployeeToDB(Database db, List<Employee> list) async {
    for (var employee in list) {
      await db.insert(
        'employee',
        employee.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }
}
