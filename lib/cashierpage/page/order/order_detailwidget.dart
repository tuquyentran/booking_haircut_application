import 'package:booking_haircut_application/data/model/branchmodel.dart';
import 'package:booking_haircut_application/data/model/employeemodel.dart';
import 'package:booking_haircut_application/data/model/order_servicemodel.dart';

import '../../../config/list/service_body.dart';
import '../../../data/api/sqlite.dart';
import '../../../data/model/ordermodel.dart';
import '../../../data/model/servicemodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../config/const.dart';
import 'package:dotted_line/dotted_line.dart';
import '../booking/bookingwidget.dart';

class OrderDetail extends StatefulWidget {
  final Order order;
  const OrderDetail({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  double subtotalAmount = 0;
  List<OrderService> lstSer = [];

  Future<List<OrderService>> _getListOrderService() async {
    return await _databaseHelper.getServiceByOrder(widget.order.id);
  }

  Future<Service?> _getService(int? id) async {
    return await _databaseHelper.getServiceById(id);
  }

  Future<Employee?> _getEmployee(int? id) async {
    return await _databaseHelper.getEmployeeById(id!);
  }

  Future<Branch?> _getBranch(int? id) async {
    return await _databaseHelper.getBranchById(id);
  }

  void calculateSubtotal() async {
    lstSer = await _getListOrderService();
    if (lstSer != null) {
      for (var item in lstSer) {
        subtotalAmount += item.price ?? 0;
      }
    }
    int? id = lstSer.first.service;
    Service service = (await _getService(id)) as Service;
    print(service.name);

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    calculateSubtotal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Tiêu đề
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: BackButton(
                              color: branchColor,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Chi tiết đơn đặt",
                              style: headingStyle,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(""),
                        ),
                      ],
                    ),
                    // Tiêu đề ------------------End
                    const Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 250,
                        child: Divider(
                          color: branchColor,
                          height: 10,
                          thickness: 2,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // Mã hóa đơn
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Expanded(
                            child: Text(
                              "Mã hóa đơn:",
                              style: subtitleDetailStyle,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Text(
                              "DD${widget.order.id.toString().padLeft(6, '0')}",
                              style: infoDetailStyle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Mã hóa đơn ----------------End
                    const SizedBox(
                      height: 5,
                    ),
                    // Ngày tạo
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Expanded(
                            child: Text(
                              "Ngày tạo:",
                              style: subtitleDetailStyle,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Text(
                              widget.order.dateCreate.toString(),
                              style: infoDetailStyle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Ngày tạo ----------------End
                    const SizedBox(
                      height: 5,
                    ),
                    // Chi nhánh cắt tóc
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Expanded(
                            child: Text(
                              "Chi nhánh cắt tóc:",
                              style: subtitleDetailStyle,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: FutureBuilder(
                              future: _getBranch(widget.order.branch),
                              builder: (context, snapshot) => Text(
                                snapshot.data?.anothername ?? "",
                                style: infoDetailStyle,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Chi nhánh cắt tóc ----------------End
                    const SizedBox(
                      height: 5,
                    ),
                    // Kỹ thuật viên
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Expanded(
                            child: Text(
                              "Kỹ thuật viên:",
                              style: subtitleDetailStyle,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: FutureBuilder(
                              future: _getEmployee(widget.order.employee),
                              builder: (context, snapshot) => Text(
                                "Thợ tóc - ${snapshot.data?.name}",
                                style: infoDetailStyle,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Kỹ thuật viên ----------------End
                    const SizedBox(
                      height: 5,
                    ),
                    // Trạng thái đơn đặt
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const Expanded(
                            child: Text(
                              "Trạng thái đơn đặt:",
                              style: subtitleDetailStyle,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Text(
                              widget.order.state == 1
                                  ? "Đã xác nhận"
                                  : "Đã hủy",
                              style: infoDetailStyle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Trạng thái đơn đặt ----------------End
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                      child: DottedLine(
                        dashColor: branchColor40,
                        dashLength: 5,
                        dashGapLength: 2,
                        dashRadius: 8,
                      ),
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Thông tin khách hàng",
                        style: headingStyle,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    // Tên khách hàng
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Expanded(
                            child: Text(
                              "Tên khách hàng:",
                              style: subtitleDetailStyle,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Text(
                              widget.order.name.toString(),
                              style: infoDetailStyle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Tên khách hàng ----------------End
                    const SizedBox(
                      height: 5,
                    ),
                    // Số điện thoại
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Expanded(
                            child: Text(
                              "Số điện thoại:",
                              style: subtitleDetailStyle,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Text(
                              widget.order.phone.toString(),
                              style: infoDetailStyle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Số điện thoại ----------------End
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                      child: DottedLine(
                        dashColor: branchColor40,
                        dashLength: 5,
                        dashGapLength: 2,
                        dashRadius: 8,
                      ),
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Dịch vụ",
                        style: headingStyle,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    // DANH SÁCH DỊCH VỤ
                    lstSer.isEmpty
                        ? const Text(
                            'Không có dịch vụ nào!',
                            style: nullStyle,
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: lstSer.length,
                            itemBuilder: (context, index) {
                              return itemServiceOrderNEW(
                                  lstSer[index], index, context);
                            },
                          ),
                    // DANH SÁCH DỊCH VỤ ----------------End
                    const SizedBox(
                      height: 5,
                    ),
                    // Tạm tính
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Expanded(
                            child: Text(
                              "Tạm tính:",
                              style: subtitleTempStyle,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Text(
                              NumberFormat('###,###.### đ')
                                  .format(subtotalAmount),
                              style: infoTempStyle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Tạm tính ----------------End
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                      child: DottedLine(
                        dashColor: branchColor40,
                        dashLength: 5,
                        dashGapLength: 2,
                        dashRadius: 8,
                      ),
                    ),
                    // Tổng tiền
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Expanded(
                            child: Text(
                              "Tổng tiền:",
                              style: headingStyle,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Text(
                              NumberFormat('###,###.### đ')
                                  .format(widget.order.total),
                              style: headingStyle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Tổng tiền ----------------End
                    // Button
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              flex: 4,
                              child: OutlinedButton(
                                onPressed: widget.order.state == 0
                                    ? null
                                    : () async {
                                        try {
                                          await _databaseHelper
                                              .updateOrderStatus(
                                                  widget.order.id!);
                                          setState(() {
                                            widget.order.state = 0;
                                          });
                                        } catch (e) {
                                          print(
                                              'Error updating order status: $e');
                                        }
                                      },
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                      color: widget.order.state == 0
                                          ? Colors.grey
                                          : branchColor),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  "Hủy đơn",
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: widget.order.state == 0
                                        ? Colors.grey
                                        : branchColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Expanded(
                              flex: 6,
                              child: FilledButton(
                                onPressed: widget.order.state == 0
                                    ? null
                                    : () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const BookingWidget()),
                                        );
                                      },
                                style: FilledButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  backgroundColor: branchColor,
                                ),
                                child: const Text(
                                  "Thanh toán đơn",
                                  style: textButtonStyle17w,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Button ----------------End
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
