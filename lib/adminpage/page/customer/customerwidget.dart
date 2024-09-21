import 'package:booking_haircut_application/adminpage/page/customer/customer_addwidget.dart';
import 'package:booking_haircut_application/adminpage/page/customer/customer_deletewidget.dart';
import 'package:booking_haircut_application/adminpage/page/customer/customer_detailwidget.dart';
import 'package:booking_haircut_application/config/const.dart';
import 'package:booking_haircut_application/data/model/customermodel.dart';
import 'package:booking_haircut_application/data/provider/customerprovider.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

import '../../../data/api/sqlite.dart';

class Customerwidget extends StatefulWidget {
  const Customerwidget({super.key});

  @override
  State<Customerwidget> createState() => _CustomerwidgetState();
}

class _CustomerwidgetState extends State<Customerwidget> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final controller = TextEditingController();
  // List<Customer> customers = [];
  // List<Customer> filteredCustomers = [];
  // late Future<List<Customer>> listCustomer;
  Future<List<Customer>> _getlistEmployeesByBranch() async {
    // thêm vào 1 dòng dữ liệu nếu getdata không có hoặc chưa có database
    return await _databaseHelper.getAllCustomers();
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
  // @override
  // void initState() {
  //   super.initState();
  //   try {
  //     listCustomer = ReadDataCustomer().loadData().then((customers) {
  //       setState(() {
  //         this.customers = customers;
  //         filteredCustomers = customers;
  //       });
  //       return customers;
  //     });
  //   } catch (e) {
  //     print('Error in initState: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Tìm kiếm',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: branchColor),
                ),
              ),
              // onChanged: searchCustomer,
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Text(
                  "Danh sách khách hàng",
                  style: headingStyle,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CustomerAddwidget(),
                      ),
                    ).then((_) {
                      setState(() {});
                    });
                    ;
                  },
                  icon: const Icon(Icons.add_circle_outline_outlined),
                  iconSize: 25,
                  color: branchColor,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CustomerDeletewidget(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.delete_outline_outlined),
                  iconSize: 25,
                  color: branchColor,
                ),
              ],
            ),
            const Divider(
              color: branchColor,
              height: 10,
              thickness: 2,
            ),
            Expanded(
              child: FutureBuilder<List<Customer>>(
                future: _getlistEmployeesByBranch(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No customers found.'));
                  } else {
                    return ListView.separated(
                      separatorBuilder: (context, index) => const DottedLine(
                        dashColor: branchColor20,
                        dashLength: 5,
                        dashGapLength: 2,
                        dashRadius: 8,
                      ),
                      itemCount: snapshot
                          .data!.length, // Use filteredCustomers for search
                      itemBuilder: (context, index) {
                        // Customer customer = filteredCustomers[index];

                        // // Get dateCreate from the first order or display "N/A"
                        // String orderDate = customer.orders != null &&
                        //         customer.orders!.isNotEmpty
                        //     ? customer.orders![0].dateCreate ?? 'N/A'
                        //     : 'N/A';
                        final itemType = snapshot.data![index];
                        return ListTile(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    CustomerDetailwidget(customer: itemType),
                              ),
                            );
                          },
                          minTileHeight: 10,
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Expanded(
                              //   flex: -1,
                              //   child: Text('${index + 1}', style: serialStyle),
                              // ),
                              // const Expanded(
                              //   flex: 3,
                              //   child: Text(""),
                              // ),
                              Expanded(
                                flex: 2,
                                child: Text('${itemType.id}',
                                    style: infoListStyle),
                              ),
                              const Expanded(
                                flex: 3,
                                child: Text(""),
                              ),
                              Expanded(
                                flex: 11,
                                child: Text('${itemType.name}',
                                    style: infoListStyle),
                              ),
                              const Expanded(
                                flex: 3,
                                child: Text(""),
                              ),
                              // Expanded(
                              //   flex: -1,
                              //   child: Text(
                              //     orderDate,
                              //     style: infoListStyle2,
                              //   ),
                              // ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // void searchCustomer(String query) {
  //   setState(() {
  //     filteredCustomers = customers
  //         .where((customer) =>
  //             customer.name!.toLowerCase().contains(query.toLowerCase()) ||
  //             customer.id!
  //                 .toString()
  //                 .toLowerCase()
  //                 .contains(query.toLowerCase()))
  //         .toList();
  //   });
  // }
}
