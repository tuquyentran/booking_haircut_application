import 'package:booking_haircut_application/data/model/customermodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../config/const.dart';
import '../../../config/list/order_body.dart';
import '../../../data/model/ordermodel.dart';
import '../../../data/provider/orderprovider.dart';

class HistoryOrderwidget extends StatefulWidget {
  final Customer customer;
  const HistoryOrderwidget({Key? key, required this.customer})
      : super(key: key);

  @override
  State<HistoryOrderwidget> createState() => _HistoryOrderwidgetState();
}

class _HistoryOrderwidgetState extends State<HistoryOrderwidget> {
  List<Order> lstOrder = [];
  List<Order> ordersToday = [];

  // Future<void> loadOrderList() async {
  //   lstOrder = await ReadDataOrder().loadData();

  //   // filterOrdersToday();
  //   setState(() {});
  // }

  @override
  void initState() {
    super.initState();
    _loadCustomerOrders();
  }

  Future<void> _loadCustomerOrders() async {
    var orders = await ReadDataOrder().loadOrderByIdCus(widget.customer.id);
    setState(() {
      lstOrder = orders;
    });
  }

  // void filterOrdersToday() {
  //   DateTime now = DateTime.now();
  //   String todayString = DateFormat('dd/MM/yyyy').format(now);

  //   ordersToday = lstOrder.where((order) {
  //     String dateString = order.date!.trim();
  //     return dateString == todayString;
  //   }).toList();
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          lstOrder.isEmpty
              ? const Text(
                  'Không có đơn đặt nào!',
                  style: nullStyle,
                )
              : Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    itemCount: lstOrder.length,
                    itemBuilder: (context, index) {
                      return itemOrderView(lstOrder[index], index, context);
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
