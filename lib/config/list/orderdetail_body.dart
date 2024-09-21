import 'package:booking_haircut_application/clientpage/MainPageCus.dart';
import 'package:booking_haircut_application/data/model/customermodel.dart';

import '../../../cashierpage/mainpage.dart';
import 'package:flutter/material.dart';
import '../const.dart';

import 'package:intl/intl.dart';
import 'package:dotted_line/dotted_line.dart';
import '../../../data/model/ordermodel.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ticket_widget/ticket_widget.dart';

class itemOrderDetailView extends StatefulWidget {
  const itemOrderDetailView({super.key});

  @override
  State<itemOrderDetailView> createState() => _SuccessWidgetState();
}

class _SuccessWidgetState extends State<itemOrderDetailView> {
  Customer customer = Customer();
  final TextEditingController _contentController = TextEditingController();
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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Align(
                    //   alignment: Alignment.topRight,
                    //   child: GestureDetector(
                    //     onTap: () {
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => const Botnavcus()),
                    //       );
                    //     },
                    //     child: const Icon(
                    //       Icons.arrow_forward_rounded,
                    //       size: 26,
                    //       color: branchColor,
                    //     ),
                    //   ),
                    // ),
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
                        Container(
                            width: double.maxFinite,
                            padding: const EdgeInsets.fromLTRB(4, 10, 4, 10),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(40.0),
                              ),
                            ),
                            child: TicketWidget(
                              color: branchColor40.withOpacity(0.3),
                              width: 300,
                              height: 512,
                              isCornerRounded: true,
                              padding: const EdgeInsets.all(20),
                              child: TicketData(),
                            )),
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
          ),
        ],
      ),
    );
  }
}

class TicketData extends StatelessWidget {
  const TicketData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
            children: const <Widget>[
              Expanded(
                child: Text(
                  "Mã hóa đơn:",
                  style: subtitleDetailStyle,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "HD015242",
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
            children: const <Widget>[
              Expanded(
                child: Text(
                  "Ngày tạo:",
                  style: subtitleDetailStyle,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "16:03, 24/06/2024",
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
            children: const <Widget>[
              Expanded(
                child: Text(
                  "Khách hàng:",
                  style: subtitleDetailStyle,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Nguyễn Mạnh Hiếu",
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
            children: const <Widget>[
              Expanded(
                child: Text(
                  "Số điện thoại:",
                  style: subtitleDetailStyle,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "0918944965",
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
            children: const <Widget>[
              Expanded(
                child: Text(
                  "Chi nhánh cắt:",
                  style: subtitleDetailStyle,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "4Rau Barber Shop - Chi nhánh Vinhomes Quận 9",
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
            children: const <Widget>[
              Expanded(
                child: Text(
                  "Kỹ thuật viên:",
                  style: subtitleDetailStyle,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Thợ tóc - Minh ",
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
            children: const <Widget>[
              Expanded(
                child: Text(
                  "Ngày đặt:",
                  style: subtitleDetailStyle,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Thứ 2, 06/03/2024",
                  style: infoDetailStyle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
            children: const <Widget>[
              Expanded(
                child: Text(
                  "Khung giờ:",
                  style: subtitleDetailStyle,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "14:30",
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
        // Tổng tiền
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Expanded(
                child: Text(
                  "Tổng tiền:",
                  style: headingStyle,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "460,000 đ",
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
    );
  }
}
