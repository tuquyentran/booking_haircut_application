import 'package:booking_haircut_application/config/const.dart';
import 'package:booking_haircut_application/data/model/receiptmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReceiptDetailWidget extends StatefulWidget {
  final Receipt receipt;

  const ReceiptDetailWidget({Key? key, required this.receipt})
      : super(key: key);

  @override
  State<ReceiptDetailWidget> createState() => _ReceiptDetailWidgetState();
}

class _ReceiptDetailWidgetState extends State<ReceiptDetailWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Thông tin hóa đơn', style: headingStyle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow("Mã hóa đơn:", widget.receipt.id.toString()),
            _buildDetailRow(
                "Mã khách hàng:", widget.receipt.customer as String?),
            _buildDetailRow("Tên khách hàng:", widget.receipt.name),
            _buildDetailRow("Số điện thoại:", widget.receipt.phone),
            _buildDetailRow("Chi nhánh cắt:", widget.receipt.branch as String?),
            _buildDetailRow("Thợ cắt:", widget.receipt.employee.toString()),
            _buildDetailRow("Ngày cắt:", widget.receipt.dateCreate),
            _buildDetailRow("Tiền típ:",
                NumberFormat("#,### đ").format(widget.receipt.tip)),
            _buildDetailRow("Tổng tiền:",
                NumberFormat("#,### đ").format(widget.receipt.total)),
            _buildDetailRow("Ngày tạo đơn:", widget.receipt.dateCreate),

            // Service List Section (using _buildDetailRow)
            const SizedBox(height: 20),
            const Text("Danh sách dịch vụ:", style: headingStyle),
            const Divider(
              color: branchColor,
              height: 10,
              thickness: 2,
            ),
            const SizedBox(height: 5),
            // Display services using _buildDetailRow
            ...widget.receipt.services?.map((service) {
                  int index = widget.receipt.services!
                      .indexOf(service); // Get the index
                  return Column(
                    children: [
                      _buildDetailRow("     ${index + 1}. ${service.name}",
                          NumberFormat("#,### đ").format(service.price)),
                      const SizedBox(
                        height: 5,
                      )
                    ],
                  );
                }).toList() ??
                [], // Display services or an empty list if null
          ],
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
              value ?? '', // Handle null values
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
