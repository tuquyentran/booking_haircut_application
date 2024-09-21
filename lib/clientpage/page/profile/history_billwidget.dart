import 'package:booking_haircut_application/config/list/receipt_body.dart';
import 'package:booking_haircut_application/data/api/sqlite.dart';
import 'package:booking_haircut_application/data/model/customermodel.dart';
import 'package:booking_haircut_application/data/model/receiptmodel.dart';
import 'package:booking_haircut_application/data/provider/receiptprovider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../config/const.dart';
import '../../../config/list/order_body.dart';
import '../../../data/model/ordermodel.dart';
import '../../../data/provider/orderprovider.dart';

class HistoryBillwidget extends StatefulWidget {
  final Customer customer;
  const HistoryBillwidget({Key? key, required this.customer}) : super(key: key);

  @override
  State<HistoryBillwidget> createState() => _HistoryOrderwidgetState();
}

class _HistoryOrderwidgetState extends State<HistoryBillwidget> {
  Customer customer = Customer(id: 0);
  List<Receipt> lstReceipt = [];

  String query = '';

  final DatabaseHelper _databaseReceipt = DatabaseHelper();
  Future<List<Receipt>> _getReceipts() async {
    return await _databaseReceipt.getReceiptsByCustomer(customer.id);
  }

  @override
  void initState() {
    super.initState();
    _loadCustomerReceipt();
  }

  Future<void> _loadCustomerReceipt() async {
    var receipt = await _databaseReceipt.getReceiptsByCustomer(customer.id);
    setState(() {
      lstReceipt = receipt;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          lstReceipt.isEmpty
              ? const Text(
                  'Không có đơn đặt nào!',
                  style: nullStyle,
                )
              : Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    itemCount: lstReceipt.length,
                    itemBuilder: (context, index) {
                      return itemReceiptView(lstReceipt[index], index, context);
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
