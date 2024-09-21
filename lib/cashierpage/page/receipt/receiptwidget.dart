import 'dart:convert';

import 'package:booking_haircut_application/data/provider/receiptprovider.dart';
import 'package:flutter/material.dart';
import 'package:booking_haircut_application/config/const.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/list/receipt_body.dart';
import '../../../data/api/sqlite.dart';
import '../../../data/model/branchmodel.dart';
import '../../../data/model/customermodel.dart';
import '../../../data/model/employeemodel.dart';
import '../../../data/model/receiptmodel.dart';

class ReceiptWidget extends StatefulWidget {
  const ReceiptWidget({super.key});

  @override
  State<ReceiptWidget> createState() => _ReceiptWidgetState();
}

class _ReceiptWidgetState extends State<ReceiptWidget> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Receipt> lstReceipt = [];
  List<Receipt> filteredReceipt = [];
  List<Receipt> receiptToday = [];
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
      lstReceipt = await _getListReceipt(branch.id);
      if (lstReceipt.isNotEmpty) {
        print(lstReceipt.first.name.toString());
      } else {
        print("Không tìm thấy danh sách");
      }
      print("Branch ID: ${branch.id.toString()}");
      print("Branch: ${branch.name.toString()}");
    }
    filterReceiptsToday();
    searchingReceipt(query);
    setState(() {});
  }

  Future<List<Receipt>> _getListReceipt(int? id) async {
    return await _databaseHelper.getReceiptsByBranch(id) ?? [];
  }

  Future<Employee?> _getEmployee(int id) async {
    return await _databaseHelper.getEmployeeById(id);
  }

  Future<Customer?> _getCustomer(int id) async {
    return await _databaseHelper.getCustomerById(id);
  }

  void filterReceiptsToday() {
    DateTime now = DateTime.now();
    String todayString = DateFormat('dd/MM/yyyy').format(now);

    receiptToday = lstReceipt.where((receipt) {
      String dateString = receipt.dateCreate!.split(', ')[1].trim();
      bool isToday = dateString == todayString;

      return isToday;
    }).toList();
  }

  void searchingReceipt(String query) async {
    if (query.isEmpty) {
      setState(() {
        filteredReceipt = List.from(lstReceipt);
      });
      return;
    }

    List<Receipt> results = [];

    for (var order in lstReceipt) {
      final idLower = order.id?.toString().toLowerCase();
      final employee = await _getEmployee(order.employee!);
      final employeeLower = employee?.name?.toLowerCase();
      final customer = await _getCustomer(order.employee!);
      final customerLower = customer?.name?.toLowerCase();
      final searchLower = query.toLowerCase();

      if ((idLower != null && idLower.contains(searchLower)) ||
          (employeeLower != null && employeeLower.contains(searchLower)) ||
          (customerLower != null && customerLower.contains(searchLower))) {
        results.add(order);
      }
    }

    setState(() {
      filteredReceipt = results;
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
                      child: Container(
                        constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height),
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
                                    searchingReceipt(query);
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
                                    borderSide: BorderSide(
                                        color: branchColor, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(16.0),
                                    ),
                                    borderSide: BorderSide(
                                        color: branchColor, width: 2),
                                  ),
                                  prefixIcon: Icon(Icons.search_rounded),
                                ),
                                cursorColor: branchColor,
                              ),
                            ),
                            // Thanh tìm kiếm -------------- End
                            const SizedBox(
                              height: 10,
                            ),
                            const Row(
                              children: <Widget>[
                                Text(
                                  "Danh sách hóa đơn",
                                  style: headingStyle,
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
                            // Danh sách hóa đơn trong ngày ----------End
                            receiptToday.isEmpty
                                ? const Text(
                                    'Không có hóa đơn nào trong ngày!',
                                    style: nullStyle,
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: receiptToday.length > 5
                                        ? 5
                                        : receiptToday.length,
                                    itemBuilder: (context, index) {
                                      return itemReceiptViewForEmployee(
                                          receiptToday[index], index, context);
                                    },
                                  ),
                            // Danh sách hóa đơn trong ngày ----------End
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Của chi nhánh",
                              style: subtitleStyle20b80,
                            ),
                            // Danh sách hóa đơn
                            filteredReceipt.isEmpty
                                ? const Text(
                                    'Không có hóa đơn nào!',
                                    style: nullStyle,
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: filteredReceipt.length > 5
                                        ? 5
                                        : filteredReceipt.length,
                                    itemBuilder: (context, index) {
                                      return itemReceiptViewForEmployee(
                                          filteredReceipt[index],
                                          index,
                                          context);
                                    },
                                  ),
                            // Danh sách hóa đơn ----------End
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
