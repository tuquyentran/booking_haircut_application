import 'dart:convert';

import 'package:booking_haircut_application/data/model/branchmodel.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/custom_widget.dart';
import '../../../config/list/receipt_body.dart';
import '../../../data/api/sqlite.dart';
import '../../../data/model/customermodel.dart';
import '../../../data/model/employeemodel.dart';
import '../../../data/model/receiptmodel.dart';
import '../../../data/model/ordermodel.dart';
import 'package:flutter/material.dart';
import '../../../config/const.dart';
import '../receipt/receiptwidget.dart';
import '../order/orderwidget.dart';
import '../../../data/provider/orderprovider.dart';
import '../../../data/provider/receiptprovider.dart';
import '../../../config/list/order_body.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Order> lstOrder = [];
  List<Receipt> lstReceipt = [];

  Employee employee = Employee(id: 0);
  Branch branch = Branch(id: 0);

  Future<List<Order>> _getListOrder(int? id) async {
    return await _databaseHelper.getOrdersByBranch(id);
  }

  Future<List<Receipt>> _getListReceipt(int? id) async {
    return await _databaseHelper.getReceiptsByBranch(id);
  }

  Future<Employee?> _getEmployee(int id) async {
    return await _databaseHelper.getEmployeeById(id);
  }

  Future<Customer?> _getCustomer(int id) async {
    return await _databaseHelper.getCustomerById(id);
  }

  // Lấy dữ liệu nhân viên
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

  // Lấy dữ liệu Chi nhánh
  getBranch() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? strBranch = pref.getString('branchCashier');

    if (strBranch == null) {
      branch = Branch(id: 0);
      print("Không tìm thấy branch");
    } else {
      branch = Branch.fromJson(jsonDecode(strBranch));
      lstOrder = await _getListOrder(branch.id);
      lstReceipt = await _getListReceipt(branch.id);
      print("Branch: ${branch.name.toString()}");
    }
    filterListToday();
    setState(() {});
  }

  void filterListToday() {
    DateTime now = DateTime.now();
    String todayString = DateFormat('dd/MM/yyyy').format(now);

    lstReceipt = lstReceipt.where((receipt) {
      String dateString = receipt.dateCreate!.split(', ')[1].trim();
      bool isToday = dateString == todayString;

      return isToday;
    }).toList();

    lstOrder = lstOrder.where((order) {
      String dateString = order.date!.trim();
      bool isToday = dateString == todayString;

      return isToday;
    }).toList();

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
    return employee.id == 0 || branch.id == 0
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
                        children: [
                          // Thông tin nhân viên và chi nhánh
                          MyInfo(employee, branch.anothername),
                          // Thông tin nhân viên và chi nhánh --------------- End
                          // Header 1
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const OrderWidget()),
                              );
                            },
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: const Row(
                                children: [
                                  Text(
                                    "Đơn đặt mới của chi nhánh",
                                    style: titleStyle22,
                                    textAlign: TextAlign.left,
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Icon(Icons.keyboard_arrow_right_rounded),
                                ],
                              ),
                            ),
                          ),
                          // Danh sách đơn đặt
                          lstOrder.isEmpty
                              ? const Text(
                                  'Chưa có đơn đặt nào!',
                                  style: nullStyle,
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:
                                      lstOrder.length > 5 ? 5 : lstOrder.length,
                                  itemBuilder: (context, index) {
                                    return itemOrderViewCashier(
                                        lstOrder[index], index, context);
                                  },
                                ),
                          // Danh sách đơn đặt ----------End
                          const SizedBox(
                            height: 16,
                          ),
                          // Header 2
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ReceiptWidget()),
                              );
                            },
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: const Row(
                                children: [
                                  Text(
                                    "Hóa đơn mới của chi nhánh",
                                    style: titleStyle22,
                                    textAlign: TextAlign.left,
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Icon(Icons.keyboard_arrow_right_rounded),
                                ],
                              ),
                            ),
                          ),
                          // Danh sách hóa đơn
                          lstReceipt.isEmpty
                              ? const Text(
                                  'Chưa có hóa đơn nào!',
                                  style: nullStyle,
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: lstReceipt.length > 5
                                      ? 5
                                      : lstReceipt.length,
                                  itemBuilder: (context, index) {
                                    return itemReceiptViewForEmployee(
                                        lstReceipt[index], index, context);
                                  },
                                ),
                          // Danh sách hóa đơn ----------End
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
