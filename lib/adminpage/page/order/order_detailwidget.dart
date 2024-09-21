import 'package:booking_haircut_application/config/const.dart';
import 'package:booking_haircut_application/data/model/ordermodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderDetailWidget extends StatefulWidget {
  final Order order;

  const OrderDetailWidget({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderDetailWidget> createState() => _OrderDetailWidgetState();
}

class _OrderDetailWidgetState extends State<OrderDetailWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Thông tin đơn đặt', style: headingStyle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow("Mã hóa đơn:", widget.order.id.toString()),
            _buildDetailRow("Mã khách hàng:", widget.order.customer.toString()),
            _buildDetailRow("Tên khách hàng:", widget.order.name),
            _buildDetailRow("Số điện thoại:", widget.order.phone),
            _buildDetailRow("Chi nhánh cắt:", widget.order.branch.toString()),
            _buildDetailRow("Thợ cắt:", widget.order.employee.toString()),
            _buildDetailRow("Ngày cắt:", widget.order.dateCreate),
            _buildDetailRow("Thời gian dự kiến:", widget.order.time),
            _buildDetailRow("Ghi chú:", widget.order.note),
            _buildDetailRow("Tổng tiền:",
                NumberFormat("#,### đ").format(widget.order.total)),
            _buildDetailRow("Ngày tạo đơn:", widget.order.dateCreate),
            _buildDetailRow("Trạng thái:", widget.order.state.toString()),

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
            ...widget.order.services?.map((service) {
                  int index =
                      widget.order.services!.indexOf(service); // Get the index
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
