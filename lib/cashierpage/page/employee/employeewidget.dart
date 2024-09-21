import 'dart:convert';

import 'package:booking_haircut_application/config/custom_widget.dart';
import 'package:booking_haircut_application/config/list/employee_body.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/api/sqlite.dart';
import '../../../data/provider/branchprovider.dart';
import '../../../data/model/employeemodel.dart';
import '../../../data/model/branchmodel.dart';
import 'package:flutter/material.dart';
import 'package:booking_haircut_application/config/const.dart';

class EmployeeWidget extends StatefulWidget {
  const EmployeeWidget({super.key});

  @override
  State<EmployeeWidget> createState() => _EmployeeWidgetState();
}

class _EmployeeWidgetState extends State<EmployeeWidget> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Employee> lstEmployee = [];

  Employee employee = Employee(id: 0);
  Branch branch = Branch(id: 0);

  Future<List<Employee>> _getListEmployee(int? id) async {
    return await _databaseHelper.getEmployeesByBranch(id);
  }

  getEmployee() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String strEmployee = pref.getString('employee')!;

    if (strEmployee == null) {
      employee = Employee(id: 0);
      print("Không tìm thấy employee");
    } else {
      employee = Employee.fromJson(jsonDecode(strEmployee));
      print("Employee: ${employee.name.toString()}");
    }
    setState(() {});
  }

  getBranch() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? strBranch = pref.getString('branchCashier');

    if (strBranch == null) {
      branch = Branch(id: 0);
      print("Không tìm thấy branch");
    } else {
      branch = Branch.fromJson(jsonDecode(strBranch));
      lstEmployee = await _getListEmployee(branch.id);
      print("Branch: ${branch.name.toString()}");
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getEmployee();
    getBranch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: branch.id == 0 || employee.id == 0
          ? LoadingScreen()
          : Stack(
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(urlBackground),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                  child: SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyInfo(employee, branch.anothername),
                          const Text(
                            "Thông tin chi nhánh",
                            style: titleStyle22,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          // Tên của chi nhánh
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                "Tên chi nhánh:",
                                style: subtitleDetailStyle,
                              ),
                              const SizedBox(
                                width: 32,
                              ),
                              Expanded(
                                child: Text(
                                  branch!.name!,
                                  style: infoDetailStyle,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                          // Tên của chi nhánh ----------- End
                          const SizedBox(
                            height: 5,
                          ),
                          // Tên rút gọn
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                "Tên rút gọn:",
                                style: subtitleDetailStyle,
                              ),
                              const SizedBox(
                                width: 32,
                              ),
                              Expanded(
                                child: Text(
                                  branch!.anothername!,
                                  style: infoDetailStyle,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                          // Tên rút gọn ----------- End
                          const SizedBox(
                            height: 5,
                          ),
                          // Loại chi nhánh
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                "Loại chi nhánh:",
                                style: subtitleDetailStyle,
                              ),
                              const SizedBox(
                                width: 32,
                              ),
                              Expanded(
                                child: Text(
                                  branch!.type == 0
                                      ? "Chi nhánh phụ"
                                      : "Chi nhánh chính",
                                  style: infoDetailStyle,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                          // Loại chi nhánh ----------- End
                          const SizedBox(
                            height: 5,
                          ),
                          // Địa chỉ chi nhánh
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                "Địa chỉ chi nhánh:",
                                style: subtitleDetailStyle,
                              ),
                              const SizedBox(
                                width: 32,
                              ),
                              Expanded(
                                child: Text(
                                  branch!.address ?? "Không tìm thấy",
                                  style: infoDetailStyle,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                          // Địa chỉ chi nhánh ----------- End
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "Danh sách nhân viên",
                            style: titleStyle22,
                          ),
                          const Divider(
                            color: branchColor,
                            height: 10,
                            thickness: 2,
                          ),
                          // DANH SÁCH NHÂN VIÊN
                          lstEmployee.isEmpty
                              ? const Text(
                                  'Không có nhân viên nào!',
                                  style: nullStyle,
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: lstEmployee.length,
                                  itemBuilder: (context, index) {
                                    return itemEmployeeView(
                                        lstEmployee[index], index, context);
                                  },
                                ),
                          const Padding(
                            padding: EdgeInsets.only(
                              bottom: 80,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
