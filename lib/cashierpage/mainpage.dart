import 'dart:async';
import 'dart:convert';
import 'package:booking_haircut_application/data/model/employeemodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../cashierpage/page/booking/bookingwidget.dart';
import '../cashierpage/page/home/homewidget.dart';
import '../cashierpage/page/employee/employeewidget.dart';
import '../cashierpage/page/statistical/statisticalwidget.dart';
import '../config/const.dart';
import '../data/api/sqlite.dart';
import '../data/model/branchmodel.dart';
import '../data/model/selectedCashiermodel.dart';
import '../data/provider/branchprovider.dart';
import '../loginwidget.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  int _selectedIndex = 0;
  Branch branch = Branch(id: 0);
  Employee employee = Employee(id: 0);

  static final List<Widget> _widgetOptions = <Widget>[
    HomeWidget(),
    EmployeeWidget(),
    StatisticalWidget(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      if (index == 3) {
        Provider.of<SelectedCashierModel>(context, listen: false).Logout();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginWidget()),
        );
      } else {
        _selectedIndex = index;
      }
    });
  }

  // Lấy dữ liệu chi nhánh
  // Future<void> LoadBranch(int? id) async {
  //   if (await ReadDataBranch().loadBranchById(id) != null) {
  //     branch = (await ReadDataBranch().loadBranchById(id))!;
  //     if (branch.id == 0) {
  //       print('Branch not found');
  //     }
  //     print("Branch: ${branch.id}");
  //   } else {
  //     print('Branch not found');
  //   }

  //   setState(() {});
  // }

  Future<bool> saveBranch(Branch br) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String strBranch = jsonEncode(br);
      prefs.setString('branchCashier', strBranch);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  getEmployee() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? strEmployee = pref.getString('employee');

    if (strEmployee == null) {
      employee = Employee(id: 0);
      print("Không tìm thấy employee");
    } else {
      employee = Employee.fromJson(jsonDecode(strEmployee));
      branch = (await _getBranch(employee.branch))!;

      if (branch != null) {
        if (await saveBranch(branch)) {
          print(branch);
        }
        print("Branch: ${branch.name}");
      } else {
        branch = Branch(id: 0);
        print("Không tìm thấy branch");
      }
      print("Employee: ${employee.name}");
    }

    setState(() {});
  }

  Future<Branch?> _getBranch(int? id) async {
    return await _databaseHelper.getBranchById(id);
  }

  @override
  void initState() {
    super.initState();
    getEmployee();
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
              alignment: Alignment.topCenter,
              children: [
                _widgetOptions.elementAt(_selectedIndex),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage(urlBarBackground),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(50),
                          blurRadius: 20,
                          spreadRadius: 10,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(16),
                      // border: Border.all(color: branchColor, width: 2.0),
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    margin: const EdgeInsets.all(10),
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            _buildNavItem(Icons.home_rounded, 0),
                            _buildNavItem(Icons.group_rounded, 1),
                            const SizedBox(
                                width:
                                    60), // Chỗ trống cho FloatingActionButton
                            _buildNavItem(Icons.line_axis_rounded, 2),
                            _buildNavItem(Icons.logout_rounded, 3,
                                color: Colors.red),
                          ],
                        ),
                        Positioned(
                          child: Transform.scale(
                            scale:
                                1.3, // Điều chỉnh giá trị này để tăng kích thước
                            child: FloatingActionButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const BookingWidget()),
                                );
                              },
                              backgroundColor: Colors.black,
                              shape: const CircleBorder(), // Đảm bảo hình tròn
                              child: const Icon(
                                Icons.calendar_view_week_rounded,
                                size: 26,
                                color: Colors.white,
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
          );
  }

  Widget _buildNavItem(IconData icon, int index, {Color? color}) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        decoration: const BoxDecoration(),
        padding: const EdgeInsets.all(10),
        child: Icon(
          icon,
          color:
              color ?? (_selectedIndex == index ? branchColor : branchColor40),
          size: 26,
        ),
      ),
    );
  }
}
