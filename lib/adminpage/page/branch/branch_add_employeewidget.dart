import 'package:booking_haircut_application/adminpage/page/employee/employee_detailwidget.dart';
import 'package:booking_haircut_application/config/const.dart';
import 'package:booking_haircut_application/data/model/branchmodel.dart';
import 'package:booking_haircut_application/data/model/employeemodel.dart';
import 'package:booking_haircut_application/data/provider/employeeprovider.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

class BranchAddEmployeeWidget extends StatefulWidget {
  final Branch branch;

  const BranchAddEmployeeWidget({super.key, required this.branch});

  @override
  State<BranchAddEmployeeWidget> createState() =>
      _BranchAddEmployeeWidgetState();
}

class _BranchAddEmployeeWidgetState extends State<BranchAddEmployeeWidget> {
  List<Employee> allEmployees = [];
  List<Employee> filteredEmployees = [];
  late Future<List<Employee>> listEmployee;
  List<Employee> selectedEmployee = [];

  @override
  void initState() {
    super.initState();
    try {
      listEmployee = ReadDataEmployee().loadData().then((allEmployees) {
        setState(() {
          this.allEmployees = allEmployees;
          _filterEmployees(); // Filter employees based on branch
        });
        return allEmployees;
      });
    } catch (e) {
      print('Error in initState: $e');
    }
  }

  // Function to filter employees
  void _filterEmployees() {
    filteredEmployees = allEmployees.where((employee) {
      return employee.branch == widget.branch.anothername ||
          employee.state == 0;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Thêm nhân viên', style: headingStyle),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              // Expanded to allow ListView to take available space
              child: FutureBuilder<List<Employee>>(
                future: listEmployee,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No employees found.'));
                  } else {
                    return _buildEmployeeSection(snapshot.data!);
                  }
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: buttonForServiceStyle(),
                        child: const Text(
                          'Xác nhận thêm nhân viên',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeSection(List<Employee> employees) {
    return ListView.separated(
      separatorBuilder: (context, index) => const DottedLine(
        dashColor: branchColor20,
        dashLength: 5,
        dashGapLength: 2,
        dashRadius: 8,
      ),
      itemCount: filteredEmployees.length,
      itemBuilder: (context, index) {
        Employee employee = filteredEmployees[index];
        bool isAssignedToBranch = employee.branch == widget.branch.anothername;
        return ListTile(
          key: ValueKey(employee.id),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => EmployeeDetailwidget(
                  employee: employee,
                ),
              ),
            );
          },
          minTileHeight: 10,
          title: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text('${index + 1}', style: serialStyle),
              ),
              Expanded(
                flex: 8,
                child: Text('${employee.nickname}', style: infoListStyle),
              ),
              Expanded(
                flex: 8,
                child: Text(
                    employee.state == 1 ? "Đang làm việc" : "Chưa có chi nhánh",
                    style: infoListStyle3),
              ),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    if (employee.state == 0) {
                      _addEmployeeToBranch(employee);
                    } else if (isAssignedToBranch) {
                      _removeEmployeeFromBranch(employee);
                    }
                  },
                  child: Icon(
                    employee.state == 0
                        ? Icons.add_circle_outline_outlined
                        : isAssignedToBranch // Check if assigned to THIS branch
                            ? Icons.do_not_disturb_on_outlined
                            : Icons
                                .circle_outlined, // Default icon if not assigned to this branch
                    color: employee.state == 0
                        ? branchColor
                        : isAssignedToBranch
                            ? Colors.red
                            : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _addEmployeeToBranch(Employee employee) {
    setState(() {
      employee.branch = widget.branch.id;
      employee.state = 1;
      widget.branch.employees!.add(employee);
    });
  }

  void _removeEmployeeFromBranch(Employee employee) {
    setState(() {
      employee.branch = null;
      employee.state = 0;
      widget.branch.employees!.remove(employee);
    });
  }
}
