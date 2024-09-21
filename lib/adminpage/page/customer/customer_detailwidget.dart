import 'dart:io';

import 'package:booking_haircut_application/adminpage/page/customer/customer_editwidget.dart';
import 'package:booking_haircut_application/config/const.dart';
import 'package:booking_haircut_application/config/photo_view.dart';
import 'package:booking_haircut_application/data/model/customermodel.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../config/list/receipt_body.dart';
import '../../../data/api/sqlite.dart';
import '../../../data/model/receiptmodel.dart';

class CustomerDetailwidget extends StatefulWidget {
  final Customer customer;

  const CustomerDetailwidget({super.key, required this.customer});

  @override
  State<CustomerDetailwidget> createState() => _CustomerDetailwidgetState();
}

class _CustomerDetailwidgetState extends State<CustomerDetailwidget> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  late Customer selectedCustomer;
  String? _imagePath;
  List<Receipt> lstReceipt = [];

  Future<List<Receipt>> _getReceipt() async {
    return _databaseHelper.getReceiptsByCustomer(widget.customer.id);
  }

  @override
  void initState() {
    super.initState();
    selectedCustomer = widget.customer;
    _imagePath = widget.customer.image;
  }

  @override
  Widget build(BuildContext context) {
    // Calculate total bills, total bill amount, and total tip amount
    final totalBills = selectedCustomer.receipts?.length ?? 0;
    final totalBillAmount = selectedCustomer.receipts?.fold<double>(
          0,
          (previousValue, bill) => previousValue + (bill.total ?? 0),
        ) ??
        0;
    final totalTipAmount = selectedCustomer.receipts?.fold<double>(
          0,
          (previousValue, bill) => previousValue + (bill.tip ?? 0),
        ) ??
        0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCustomerImage(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Thông tin khách hàng', style: headingStyle),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CustomerEditwidget(customer: selectedCustomer),
                      ),
                    );
                  },
                  child: const Icon(Icons.edit_note_rounded),
                ),
              ],
            ),
            const Divider(
              color: branchColor,
              height: 10,
              thickness: 2,
            ),
            const SizedBox(height: 5),
            _buildDetailRow("Mã khách hàng:", selectedCustomer.id.toString()),
            _buildDetailRow("Tên khách hàng:", selectedCustomer.name),
            _buildDetailRow("Số điện thoại:", selectedCustomer.phone),
            _buildDetailRow("Email:", selectedCustomer.email),
            _buildDetailRow(
                "Mật khẩu:", "*" * (selectedCustomer.password?.length ?? 0)),

            // Hóa đơn liên quan Section
            const SizedBox(height: 10),
            const Text("Hóa đơn liên quan", style: headingStyle),
            const Divider(
              color: branchColor,
              height: 10,
              thickness: 2,
            ),
            const SizedBox(
              height: 5,
            ),
            // Total bill amount
            _buildBillSummaryRow("Tổng tiền:", totalBills, totalBillAmount),

            // Total tip amount
            _buildBillSummaryRow("Tiền tip:", totalBills, totalTipAmount),
            const SizedBox(
              height: 16,
            ),
            const DottedLine(
              dashColor: branchColor,
              dashLength: 5,
              dashGapLength: 2,
              dashRadius: 8,
            ),
            // Bill Listview
            // ListView.separated(
            //   physics: const NeverScrollableScrollPhysics(),
            //   shrinkWrap: true,
            //   separatorBuilder: (context, index) => const DottedLine(
            //     dashColor: branchColor20,
            //     dashLength: 5,
            //     dashGapLength: 2,
            //     dashRadius: 8,
            //   ),
            //   itemCount: selectedCustomer.receipts?.length ?? 0,
            //   itemBuilder: (context, index) {
            //     final bill = selectedCustomer.receipts?[index];
            //     return ListTile(
            //       minTileHeight: 10,
            //       title: Row(
            //         children: [
            //           Expanded(
            //             flex: -1,
            //             child: Text('${index + 1}', style: serialStyle),
            //           ),
            //           Expanded(
            //             flex: 2,
            //             child: Text(""),
            //           ),
            //           Expanded(
            //             flex: 9,
            //             child: Text(bill?.id.toString() ?? '',
            //                 style: infoListStyle),
            //           ),
            //           Expanded(
            //             flex: 2,
            //             child: Text(""),
            //           ),
            //           Expanded(
            //             flex: 8,
            //             child: Text(bill?.name ?? '', style: infoListStyle3),
            //           ),
            //           Expanded(
            //             flex: 2,
            //             child: Text(""),
            //           ),
            //           Expanded(
            //             flex: -1,
            //             child:
            //                 Text(bill?.dateCreate ?? '', style: infoListStyle2),
            //           ),
            //         ],
            //       ),
            //     );
            //   },
            // ),
            FutureBuilder(
                future: _getReceipt(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    lstReceipt = snapshot.data!;
                    return lstReceipt.isEmpty
                        ? const Text(
                            'Không có hóa đơn nào!',
                            style: nullStyle,
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: lstReceipt.length,
                            itemBuilder: (context, index) {
                              return itemReceiptViewForEmployee(
                                  lstReceipt[index], index, context);
                            },
                          );
                    // Hóa đơn liên quan ------------------End
                  }
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerImage() {
    return Center(
      child: Align(
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => ImageZoomScreen(
            //         imagePath: selectedEmployee.image!),
            //   ),
            // );
          },
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFF000000), width: 1),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: selectedCustomer.image == ''
                  ? Container(
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD9D9D9),
                      ),
                      // child:
                      // const Icon(Icons.add_a_photo_outlined),
                    )
                  : Image.file(
                      File(selectedCustomer.image!),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Text(title, style: subtitleDetailStyle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title == "Mã khách hàng:"
                  ? "KH${value.toString().padLeft(6, '0')}"
                  : value ?? '', // Handle null values
              style: infoDetailStyle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to build a bill summary row
  Widget _buildBillSummaryRow(String title, int billCount, double totalAmount) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Text(
              title,
              style: subtitleDetailStyle,
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          Expanded(
            child: Text(
              "($billCount)",
              style: infoTempStyle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Text(
              NumberFormat('###,###,### đ').format(totalAmount),
              style: infoDetailStyle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
