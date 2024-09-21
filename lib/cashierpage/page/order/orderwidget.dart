import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/const.dart';
import '../../../config/list/order_body.dart';
import '../../../data/api/sqlite.dart';
import '../../../data/model/branchmodel.dart';
import '../../../data/model/employeemodel.dart';
import '../../../data/model/ordermodel.dart';
import '../../../data/provider/orderprovider.dart';

class OrderWidget extends StatefulWidget {
  const OrderWidget({super.key});

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Order> lstOrder = [];
  List<Order> filteredOrders = [];
  List<Order> ordersToday = [];
  String query = '';
  Branch branch = Branch(id: 0);

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
      print(lstOrder);
      if (lstOrder.isNotEmpty) {
        print(lstOrder.first.name.toString());
      } else {
        print("Không tìm thấy danh sách");
      }
      print("Branch ID: ${branch.id.toString()}");
      print("Branch: ${branch.name.toString()}");
    }
    filterOrdersToday(); // Lọc dữ liệu đơn hàng hôm nay
    searchingOrders(query); // Tìm kiếm đơn hàng với từ khóa
    setState(() {});
  }

  Future<List<Order>> _getListOrder(int? id) async {
    return await _databaseHelper.getOrdersByBranch(id);
  }

  Future<Employee?> _getEmployee(int id) async {
    return await _databaseHelper.getEmployeeById(id);
  }

  void filterOrdersToday() {
    DateTime now = DateTime.now();
    String todayString = DateFormat('dd/MM/yyyy').format(now);

    ordersToday = lstOrder.where((order) {
      String dateString = order.date!.trim();
      bool isToday = dateString == todayString;
      return isToday;
    }).toList();
  }

  void searchingOrders(String query) async {
    if (query.isEmpty) {
      setState(() {
        filteredOrders = List.from(lstOrder);
      });
      return;
    }

    List<Order> results = [];

    for (var order in lstOrder) {
      final idLower = order.id?.toString().toLowerCase();
      final employee = await _getEmployee(order.employee!);
      final employeeLower = employee?.name?.toLowerCase();
      final customerLower = order.name?.toLowerCase();
      final dateLower = order.date?.toLowerCase();
      final timeLower = order.time?.toLowerCase();
      final searchLower = query.toLowerCase();

      if ((idLower != null && idLower.contains(searchLower)) ||
          (employeeLower != null && employeeLower.contains(searchLower)) ||
          (customerLower != null && customerLower.contains(searchLower)) ||
          (dateLower != null && dateLower.contains(searchLower)) ||
          (timeLower != null && timeLower.contains(searchLower))) {
        results.add(order);
      }
    }

    setState(() {
      filteredOrders = results;
    });
  }

  @override
  void initState() {
    super.initState();
    getBranch();
  }

  @override
  Widget build(BuildContext context) {
    return branch.id == 0
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
            resizeToAvoidBottomInset: false,
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
                  child: SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: BackButton(
                              color: branchColor,
                            ),
                          ),
                          // Thanh tìm kiếm
                          Container(
                            height: 50,
                            decoration: const BoxDecoration(),
                            child: TextField(
                              onChanged: (text) {
                                setState(() {
                                  query = text;
                                  searchingOrders(query);
                                });
                              },
                              decoration: const InputDecoration(
                                labelText: "Tìm kiếm...",
                                labelStyle: TextStyle(color: branchColor),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(16.0),
                                  ),
                                  borderSide: BorderSide(color: branchColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(16.0),
                                  ),
                                  borderSide:
                                      BorderSide(color: branchColor, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(16.0),
                                  ),
                                  borderSide:
                                      BorderSide(color: branchColor, width: 2),
                                ),
                                prefixIcon: Icon(Icons.search_rounded),
                              ),
                              cursorColor: branchColor,
                            ),
                          ),
                          // Thanh tìm kiếm --------------------- End
                          const SizedBox(
                            height: 10,
                          ),
                          const Row(
                            children: <Widget>[
                              Text(
                                "Danh sách đơn đặt",
                                style: titleStyle30,
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
                          const Text(
                            "Hôm nay",
                            style: subtitleStyle20b80,
                          ),
                          ordersToday.isEmpty
                              ? const Text(
                                  'Không có đơn đặt nào trong ngày!',
                                  style: nullStyle,
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: ordersToday.length,
                                  itemBuilder: (context, index) {
                                    return itemOrderViewCashier(
                                        ordersToday[index], index, context);
                                  },
                                ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Của chi nhánh",
                            style: subtitleStyle20b80,
                          ),
                          filteredOrders.isEmpty
                              ? const Text(
                                  'Không có đơn đặt nào!',
                                  style: nullStyle,
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: filteredOrders.length,
                                  itemBuilder: (context, index) {
                                    return itemOrderViewCashier(
                                        filteredOrders[index], index, context);
                                  },
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
