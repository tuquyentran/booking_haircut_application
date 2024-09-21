import 'dart:convert';

import 'package:booking_haircut_application/clientpage/MainPageCus.dart';
import 'package:booking_haircut_application/data/model/customermodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../cashierpage/mainpage.dart';
import 'package:flutter/material.dart';
import '../../../config/const.dart';
import 'package:intl/intl.dart';
import 'package:dotted_line/dotted_line.dart';
import '../../../config/list/service_body.dart';
import '../../../data/model/ordermodel.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ticket_widget/ticket_widget.dart';

class SuccessCuswidget extends StatefulWidget {
  const SuccessCuswidget({super.key});

  @override
  State<SuccessCuswidget> createState() => _SuccessWidgetState();
}

class _SuccessWidgetState extends State<SuccessCuswidget> {
  Customer customer = Customer();
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
            padding: const EdgeInsets.fromLTRB(16, 15, 16, 0),
            child: SafeArea(
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          decoration: const BoxDecoration(),
                          child: Image.asset(urlSuccess),
                          width: 130,
                          height: 130,
                        ),
                      ),
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Hoàn tất thanh toán",
                          style: headingStyle,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      // Thông tin hóa đơn
                      Align(
                        alignment: Alignment.center,
                        child: TicketWidget(
                          color: branchColor40.withOpacity(0.3),
                          width: 350,
                          height: 550,
                          isCornerRounded: true,
                          padding: const EdgeInsets.all(20),
                          child: const TicketData(),
                        ),
                      ),
                      // Thông tin hóa đơn ------------End

                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(4, 5, 4, 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Expanded(
                                flex: 4,
                                child: Text(""),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Expanded(
                                flex: 6,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MainPageCus(
                                                customer: customer,
                                              )),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    backgroundColor: branchColor,
                                  ),
                                  child: const Text(
                                    "Xác nhận",
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TicketData extends StatefulWidget {
  const TicketData({Key? key}) : super(key: key);

  @override
  State<TicketData> createState() => _TicketDataState();
}

class _TicketDataState extends State<TicketData> {
  Order order = Order(id: 0);

  getOrder() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String strOrder = pref.getString('order')!;

    if (strOrder == null) {
      order = Order(id: 0);
    } else {
      order = Order.fromJson(jsonDecode(strOrder));
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getOrder();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 100,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Container(
                  height: 8,
                  decoration: const BoxDecoration(
                    color: branchColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(40),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Align(
            alignment: Alignment.center,
            child: Text(
              "Thông tin hóa đơn",
              style: headingStyle,
            ),
          ),
          const SizedBox(height: 5),
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
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    order.id.toString(),
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
          const SizedBox(height: 5),
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
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    order.dateCreate =
                        DateFormat('dd/MM/yyyy').format(DateTime.now()),
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
          const SizedBox(height: 5),
          // Tên khách hàng
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Expanded(
                  child: Text(
                    "Khách hàng:",
                    style: subtitleDetailStyle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    order.name.toString(),
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
          const SizedBox(height: 5),
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
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    order.phone.toString(),
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
          // Chi nhánh cắt tóc
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Expanded(
                  child: const Text(
                    "Chi nhánh cắt:",
                    style: subtitleDetailStyle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    order.branch.toString(),
                    style: infoDetailStyle,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          // Chi nhánh cắt tóc ----------------End
          const SizedBox(height: 5),
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
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Thợ tóc - ${order.employee} ",
                    style: infoDetailStyle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          // Kỹ thuật viên ----------------End
          // Ngày đặt
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Expanded(
                  child: Text(
                    "Ngày đặt:",
                    style: subtitleDetailStyle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    order.date != null
                        ? DateFormat('dd/MM/yyyy')
                            .format(DateTime.parse(order.date!))
                        : "Không có dữ liệu",
                    style: infoDetailStyle,
                    maxLines: 1,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          // Ngày đặt ----------------End
          // Khung giờ
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Expanded(
                  child: Text(
                    "Khung giờ:",
                    style: subtitleDetailStyle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    order.time.toString(),
                    style: infoDetailStyle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          // Khung giờ ----------------End
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
          const SizedBox(height: 5),
          // // DANH SÁCH DỊCH VỤ
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: order.services?.length ?? 0,
            itemBuilder: (context, index) {
              final service = order.services![index];
              return itemServiceOrder(service, index, context);
            },
          ),
          // // DANH SÁCH DỊCH VỤ ----------------End
          const SizedBox(
            height: 5,
          ),
          // Tổng tiền
          const DottedLine(
            dashColor: branchColor,
            dashLength: 5,
            dashGapLength: 2,
            dashRadius: 8,
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Expanded(
                  child: Text(
                    "Tổng tiền:",
                    style: headingStyle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    NumberFormat('###,###.### đ').format(order.total ?? 0),
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
        ],
      ),
    );
  }
}
