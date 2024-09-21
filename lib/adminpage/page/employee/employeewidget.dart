import 'package:booking_haircut_application/adminpage/page/employee/employee_addwidget.dart';
import 'package:booking_haircut_application/adminpage/page/employee/employee_deletewidget.dart';
import 'package:booking_haircut_application/adminpage/page/employee/employee_detailwidget.dart';
import 'package:booking_haircut_application/data/model/employeemodel.dart';
import 'package:booking_haircut_application/data/provider/employeeprovider.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:booking_haircut_application/config/const.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../../../config/list/employee_body_ad.dart';
import '../../../data/api/sqlite.dart';

class Employeewidget extends StatefulWidget {
  const Employeewidget({super.key});

  @override
  State<Employeewidget> createState() => _EmployeewidgetState();
}

class _EmployeewidgetState extends State<Employeewidget> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final TextEditingController _searchController = TextEditingController();
  List<Employee> _searchResults = [];
  Future<void> _searchEmployee(String name) async {
    final Database db = await _databaseHelper.database;
    final List<Map<String, dynamic>> results = await db.query(
      'employee',
      where: 'name LIKE ?',
      whereArgs: ['%$name%'],
    );
    setState(() {
      _searchResults = results.map((e) => Employee.fromMap(e)).toList();
    });
  }

  bool _isSearching = false;

  Future<Map<String, List<Employee>>> _getlistEmployeesByBranch() async {
    // thêm vào 1 dòng dữ liệu nếu getdata không có hoặc chưa có database
    return await _databaseHelper.listEmployeesByBranch();
  }

  // String query = '';
  // void onQueryChanged(String newQuery) {
  //   setState(() {
  //     query = newQuery;
  //   });
  // }

  // List<Employee> employees = [];
  // List<Employee> filteredEmployees = [];
  // late Future<List<Employee>> listEmployee;

  @override
  void initState() {
    super.initState();
    _getlistEmployeesByBranch();
    // try {
    //   listEmployee = ReadDataEmployee().loadData().then((employees) {
    //     setState(() {
    //       this.employees = employees;
    //       filteredEmployees = employees; // Initialize filteredEmployees
    //     });
    //     return employees;
    //   });
    // } catch (e) {
    //   print('Error in initState: $e');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        child: SafeArea(
          child: Column(
            // Use Column for overall layout
            children: <Widget>[
              // Search Bar
              SizedBox(
                height: 50,
                child: TextFormField(
                  controller: _searchController,
                  onChanged: (newQuery) {
                    setState(() {
                      _isSearching = newQuery.isNotEmpty;
                    });
                    _searchEmployee(newQuery);
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 5),
                    hintText: "Tìm kiếm...",
                    labelStyle: TextStyle(
                      color: branchColor80,
                      fontStyle: FontStyle.italic,
                    ), // Replace with branchColor
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(16.0),
                      ),
                      borderSide: BorderSide(color: branchColor, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(16.0),
                      ),
                      borderSide: BorderSide(color: branchColor, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(16.0),
                      ),
                      borderSide: BorderSide(color: branchColor, width: 2),
                    ),
                    prefixIcon: Icon(Icons.search_outlined),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              //DANH SACH NHAN VIEN
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    flex: 3,
                    child: Text(
                      "Danh sách nhân viên",
                      style: headingStyle,
                    ),
                  ),

                  //nút thêm.................
                  Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const EmployeeAddwidget()),
                            ).then((_) {
                              setState(() {});
                            });
                          },
                          icon: const Icon(Icons.add_circle_outline_outlined),
                        ),
                      )),
                ],
              ),
              const Divider(
                color: branchColor,
                height: 10,
                thickness: 2,
              ),
              _isSearching
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final employee = _searchResults[index];
                          return ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            separatorBuilder: (context, index) =>
                                const DottedLine(
                              dashColor: branchColor20,
                              dashLength: 5,
                              dashGapLength: 2,
                              dashRadius: 8,
                            ),
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              return Dismissible(
                                  key: ValueKey<int>(employee.id!),
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    color: Colors.red,
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: const Icon(Icons.delete,
                                        color: Colors.white),
                                  ),
                                  onDismissed: (direction) {
                                    setState(() {
                                      DatabaseHelper()
                                          .deleteEmployee(employee.id!);
                                    });
                                  },
                                  child: ItemEmployeeAd(
                                    employee: employee,
                                    index: index,
                                  ));
                              // ItemEmployeeAd(
                              //   employee: employee,
                              //   index: index,
                              // );
                            },
                          );
                        },
                      ),
                    )
                  : Expanded(
                      // Expanded to allow ListView to take available space
                      child: FutureBuilder<Map<String, List<Employee>>>(
                        // Gọi phương thức để lấy Future
                        future: _getlistEmployeesByBranch(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child:
                                    CircularProgressIndicator()); // Hiển thị vòng tròn tải dữ liệu
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text(
                                    'Lỗi: ${snapshot.error}')); // Hiển thị thông báo lỗi
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(
                                child: Text(
                                    'Không có dữ liệu')); // Hiển thị thông báo không có dữ liệu
                          } else {
                            final employeesByBranch = snapshot.data!;
                            return ListView(
                              children: employeesByBranch.entries.map((entry) {
                                final branchName = entry.key;
                                //final employees = entry.value;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      branchName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    ListView.separated(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      separatorBuilder: (context, index) =>
                                          const DottedLine(
                                        dashColor: branchColor20,
                                        dashLength: 5,
                                        dashGapLength: 2,
                                        dashRadius: 8,
                                      ),
                                      itemCount: entry.value.length,
                                      itemBuilder: (context, index) {
                                        final employee = entry.value[index];

                                        return Dismissible(
                                            key: ValueKey<int>(employee.id!),
                                            direction:
                                                DismissDirection.endToStart,
                                            background: Container(
                                              color: Colors.red,
                                              alignment: Alignment.centerRight,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              child: const Icon(Icons.delete,
                                                  color: Colors.white),
                                            ),
                                            onDismissed: (direction) {
                                              setState(() {
                                                DatabaseHelper()
                                                    .deleteEmployeeAdmin(
                                                        employee.id!);
                                              });
                                            },
                                            child: ItemEmployeeAd(
                                              employee: employee,
                                              index: index,
                                            ));
                                        // ItemEmployeeAd(
                                        //   employee: employee,
                                        //   index: index,
                                        // );
                                      },
                                    ),
                                  ],
                                );

                                //   ExpansionTile(
                                //     title: Text(branchName),
                                //     children: employees.map((employee) {
                                //       return ListTile(
                                //         title: Text(employee.name ?? 'Không có tên'),
                                //         subtitle:
                                //             Text(employee.email ?? 'Không có email'),
                                //       );
                                //     }).toList(),
                                //   );
                              }).toList(),
                            );
                          }
                        },
                      ),
                    ),
              // ElevatedButton(
              //   onPressed: () async {
              //     await _databaseHelper.deleteAllData();
              //     ScaffoldMessenger.of(context).showSnackBar(
              //       SnackBar(content: Text('All data has been deleted')),
              //     );
              //   },
              //   child: Text('Delete All Data'),
              // )
            ],
          ),
        ),
      ),
    ));
  }

  // Widget _buildEmployeeSection() {
  //   // Group employees by branch
  //   Map<String, List<Employee>> employeesByBranch = {};
  //   for (var employee in filteredEmployees) {
  //     // Use filteredEmployees
  //     if (employeesByBranch.containsKey(employee.branch)) {
  //       employeesByBranch[employee.branch]!.add(employee);
  //     } else {
  //       employeesByBranch[employee.branch!] = [employee];
  //     }
  //   }

  //   return SingleChildScrollView(
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         ...employeesByBranch.entries.map((entry) {
  //           return
  // Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.symmetric(vertical: 8.0),
  //                 child: Text(
  //                   entry.key,
  //                   style: const TextStyle(
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: 16,
  //                   ),
  //                 ),
  //               ),
  //               ListView.separated(
  //                 physics: const NeverScrollableScrollPhysics(),
  //                 shrinkWrap: true,
  //                 separatorBuilder: (context, index) => const DottedLine(
  //                   dashColor: branchColor20,
  //                   dashLength: 5,
  //                   dashGapLength: 2,
  //                   dashRadius: 8,
  //                 ),
  //                 itemCount: entry.value.length,
  //                 itemBuilder: (context, index) {
  //                   final employee = entry.value[index];

  //                   return Dismissible(
  //                       key: Key(employee.id!.toString()),
  //                       direction: DismissDirection.endToStart,
  //                       background: Container(
  //                         color: Colors.red,
  //                         alignment: Alignment.centerRight,
  //                         padding: const EdgeInsets.symmetric(horizontal: 20),
  //                         child: const Icon(Icons.delete, color: Colors.white),
  //                       ),
  //                       onDismissed: (direction) {
  //                         _deleteEmployee(entry.key, employee.id!.toString());
  //                       },
  //                       child: ItemEmployeeAd(
  //                         employee: employee,
  //                         index: index,
  //                       ));
  //                 },
  //               ),
  //             ],
  //           );
  //         })
  //       ],
  //     ),
  //   );
  // }
}
