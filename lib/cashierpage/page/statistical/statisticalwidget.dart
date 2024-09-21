import 'dart:convert';

import 'package:booking_haircut_application/data/model/employeemodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:booking_haircut_application/config/const.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/custom_widget.dart';
import '../../../config/list/employee_body.dart';
import '../../../data/api/sqlite.dart';
import '../../../data/model/branchmodel.dart';
import '../../../data/provider/branchprovider.dart';

class StatisticalWidget extends StatefulWidget {
  const StatisticalWidget({super.key});

  @override
  State<StatisticalWidget> createState() => _StatisticalWidgetState();
}

class _StatisticalWidgetState extends State<StatisticalWidget> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Employee> lst = [];

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
      lst = await _getListEmployee(branch.id);
      lst.removeWhere((emp) => emp.role == 1 && emp.state == 0);
      print("Branch: ${branch.name.toString()}");
    }
    setState(() {});
  }

  Future<void> _loadEmployees() async {
    // Tính tổng số đơn hàng cho từng nhân viên
    List<MapEntry<Employee, int>> sortedEmployees = await Future.wait(
      lst.map((employee) async {
        int totalOrder = await employee.getTotalOrder();
        return MapEntry(employee, totalOrder);
      }).toList(),
    );

    // Sắp xếp danh sách theo tổng số đơn hàng giảm dần
    sortedEmployees.sort((a, b) => b.value.compareTo(a.value));

    setState(() {
      lst = sortedEmployees.map((entry) => entry.key).toList();
      print(lst);
    });
  }

  @override
  void initState() {
    super.initState();
    getEmployee();
    getBranch().then((_) => _loadEmployees());
  }

  @override
  Widget build(BuildContext context) {
    return branch.id == 0 || employee.id == 0
        ? Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(urlBackground),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Center(
                child: CircularProgressIndicator(
                  color: branchColor,
                  backgroundColor: branchColor20,
                ),
              )
            ],
          )
        : Scaffold(
            body: Stack(
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
                  child: SingleChildScrollView(
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Thông tin nhân viên và chi nhánh
                          MyInfo(employee, branch.anothername),
                          // Thông tin nhân viên và chi nhánh --------------- End
                          // Box 1
                          Row(
                            children: [
                              // Box - Số đơn đặt
                              Expanded(
                                flex: 5,
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(16.0),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 0,
                                        blurRadius: 4,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                    color: branchColor20.withOpacity(0.6),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          FutureBuilder(
                                            future: branch.getTotalOrder(),
                                            builder: (context, snapshot) =>
                                                Text(
                                              snapshot.data.toString(),
                                              style: numberStatisticalStyle,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 12,
                                          ),
                                          const Icon(
                                            Icons.receipt_rounded,
                                            size: 30,
                                          ),
                                        ],
                                      ),
                                      const Text("Số đơn đặt lịch cắt tóc",
                                          maxLines:
                                              2, // Đặt maxLines thành 2 để wrap text nếu quá dài
                                          overflow: TextOverflow.ellipsis,
                                          style: textStatisticalStyle),
                                    ],
                                  ),
                                ),
                              ),
                              // Box - Số đơn đặt ------------End
                              const SizedBox(
                                width: 10,
                              ),
                              // Box - Số hóa đơn
                              Expanded(
                                flex: 5,
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(16.0),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 0,
                                        blurRadius: 4,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                    color: branchColor20.withOpacity(0.6),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          FutureBuilder(
                                            future: branch.getTotalReceipt(),
                                            builder: (context, snapshot) =>
                                                Text(
                                              snapshot.data.toString(),
                                              style: numberStatisticalStyle,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 12,
                                          ),
                                          const Icon(
                                            Icons.receipt_long_rounded,
                                            size: 30,
                                          ),
                                        ],
                                      ),
                                      const Text("Số hóa đơn cắt tóc",
                                          maxLines:
                                              2, // Đặt maxLines thành 2 để wrap text nếu quá dài
                                          overflow: TextOverflow.ellipsis,
                                          style: textStatisticalStyle),
                                    ],
                                  ),
                                ),
                              ),
                              // Box - Số hóa đơn ------------End
                            ],
                          ),
                          // Box 1 --------End
                          const SizedBox(
                            height: 10,
                          ),
                          // Box 2
                          Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: // Box - Số đơn đặt trong ngày
                                    Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(16.0),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 0,
                                        blurRadius: 4,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                    color: branchColor20.withOpacity(0.6),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          FutureBuilder(
                                            future: branch.getTotalOrderToday(),
                                            builder: (context, snapshot) =>
                                                Text(
                                              snapshot.data.toString(),
                                              style: numberStatisticalStyle,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 12,
                                          ),
                                          const Icon(
                                            Icons.pending_actions_rounded,
                                            size: 30,
                                          ),
                                        ],
                                      ),
                                      const Text("Số đơn đặt trong ngày",
                                          maxLines:
                                              2, // Đặt maxLines thành 2 để wrap text nếu quá dài
                                          overflow: TextOverflow.ellipsis,
                                          style: textStatisticalStyle),
                                    ],
                                  ),
                                ),
                              ),
                              // Box - Số đơn đặt trong ngày ------------End),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 5,
                                child: // Box - Số nhân viên cắt tóc
                                    Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(16.0),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 0,
                                        blurRadius: 4,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                    color: branchColor20.withOpacity(0.6),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          FutureBuilder(
                                            future: branch.totalEmployee(),
                                            builder: (context, snapshot) =>
                                                Text(
                                              snapshot.data.toString(),
                                              style: numberStatisticalStyle,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 12,
                                          ),
                                          const Icon(
                                            Icons.groups_rounded,
                                            size: 30,
                                          ),
                                        ],
                                      ),
                                      const Text("Số nhân viên của chi nhánh",
                                          maxLines:
                                              2, // Đặt maxLines thành 2 để wrap text nếu quá dài
                                          overflow: TextOverflow.ellipsis,
                                          style: textStatisticalStyle),
                                    ],
                                  ),
                                ),
                              ),
                              // Box - Số nhân viên cắt tóc ------------End),
                            ],
                          ),
                          // Box 2 --------End
                          const SizedBox(
                            height: 10,
                          ),
                          // Box - Tổng doanh thu
                          Container(
                            width: double.maxFinite,
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(16.0),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 0,
                                  blurRadius: 4,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              color: branchColor20.withOpacity(0.6),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text("Tổng doanh thu",
                                    maxLines:
                                        2, // Đặt maxLines thành 2 để wrap text nếu quá dài
                                    overflow: TextOverflow.ellipsis,
                                    style: textStatisticalStyle),
                                const SizedBox(
                                  width: 12,
                                ),
                                FutureBuilder(
                                  future: branch?.getRevenue(),
                                  builder: (context, snapshot) => Text(
                                    NumberFormat('###,###.### đ')
                                        .format(snapshot.data ?? 0),
                                    style: numberStatisticalStyle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Box - Tổng doanh thu ------------End
                          const SizedBox(
                            height: 30,
                          ),
                          const Row(
                            children: <Widget>[
                              Text(
                                "Nhân viên có nhiều đơn đặt",
                                style: titleStyle22,
                              ),
                              Spacer(),
                              Icon(Icons.filter_list_rounded),
                            ],
                          ),
                          const Divider(
                            color: branchColor,
                            height: 10,
                            thickness: 2,
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: lst.length,
                            itemBuilder: (context, index) {
                              final employee = lst[index];
                              return itemEmployeeStatistical(
                                  lst[index], index, context);
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
                ),
              ],
            ),
          );
  }
}
