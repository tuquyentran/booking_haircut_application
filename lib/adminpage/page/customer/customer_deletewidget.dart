import 'package:booking_haircut_application/adminpage/page/customer/customer_addwidget.dart';
import 'package:booking_haircut_application/adminpage/page/customer/customer_detailwidget.dart';
import 'package:booking_haircut_application/config/const.dart';
import 'package:booking_haircut_application/data/model/customermodel.dart';
import 'package:booking_haircut_application/data/provider/customerprovider.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

class CustomerDeletewidget extends StatefulWidget {
  const CustomerDeletewidget({super.key});
  @override
  State<CustomerDeletewidget> createState() => _CustomerDeletewidgetState();
}

class _CustomerDeletewidgetState extends State<CustomerDeletewidget> {
  final controller = TextEditingController();
  List<Customer> customers = [];
  List<Customer> filteredCustomers = []; // Add filteredBranches
  late Future<List<Customer>> listCustomer;

  @override
  void initState() {
    super.initState();
    try {
      listCustomer = ReadDataCustomer().loadData().then((customers) {
        setState(() {
          this.customers = customers;
          filteredCustomers = customers; // Initialize filteredBranches
        });
        return customers;
      });
    } catch (e) {
      print('Error in initState: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Column(
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Tìm kiếm',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                ),
                onChanged: searchCustomer,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text(
                    "Danh sách các chi nhánh",
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
                        // Refresh the branch list after adding a branch
                        _refreshCustomerList();
                      });
                    },
                    icon: const Icon(Icons.add_circle_outline_outlined),
                    iconSize: 25,
                    color: branchColor,
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
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
                  future: listCustomer,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No branches found.'));
                    } else {
                      return ListView.separated(
                        separatorBuilder: (context, index) => const DottedLine(
                          dashColor: branchColor20,
                          dashLength: 5,
                          dashGapLength: 2,
                          dashRadius: 8,
                        ),
                        itemCount:
                            filteredCustomers.length, // Use filteredBranches
                        itemBuilder: (context, index) {
                          Customer customer = filteredCustomers[index];
                          return Dismissible(
                              // Use Dismissible for swipe-to-delete
                              key: Key(customer.id!
                                  .toString()), // Unique key for each item
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: const Icon(Icons.delete,
                                    color: Colors.white),
                              ),
                              onDismissed: (direction) {
                                _deletedCustomer(index);
                              },
                              child: ListTile(
                                minTileHeight: 10,
                                title: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text('${index + 1}',
                                          style: serialStyle),
                                    ),
                                    Expanded(
                                      flex: 8,
                                      child: Text('${customer.id}',
                                          style: infoListStyle),
                                    ),
                                    Expanded(
                                      flex: 8,
                                      child: Text('${customer.name}',
                                          style: infoListStyle3),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: InkWell(
                                        onTap: () {
                                          _deletedCustomer(index);
                                        },
                                        child: const Icon(
                                          Icons.do_not_disturb_on_outlined,
                                          color: Colors.red,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          CustomerDetailwidget(
                                              customer: customer),
                                    ),
                                  );
                                },
                              ));
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deletedCustomer(int index) {
    setState(() {
      Customer deletedCustomer = filteredCustomers.removeAt(index);
      customers.remove(deletedCustomer);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã xóa khách hàng ${customers[index].name}')),
    );
  }

  // Function to refresh the branch list (e.g., after adding or deleting)
  void _refreshCustomerList() {
    setState(() {
      listCustomer = ReadDataCustomer().loadData().then((customers) {
        setState(() {
          this.customers = customers;
          filteredCustomers = customers;
        });
        return customers;
      });
    });
  }

  void searchCustomer(String query) {
    setState(() {
      filteredCustomers = customers
          .where((customer) =>
              customer.name!.toLowerCase().contains(query.toLowerCase()) ||
              customer.id!
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
    });
  }
}
