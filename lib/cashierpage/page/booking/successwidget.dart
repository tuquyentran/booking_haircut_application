import 'dart:convert';

import 'package:booking_haircut_application/clientpage/MainPageCus.dart';
import 'package:booking_haircut_application/config/list/service_body.dart';
import 'package:booking_haircut_application/data/model/customermodel.dart';
import 'package:booking_haircut_application/data/model/employeemodel.dart';
import 'package:booking_haircut_application/data/model/receipt_service.dart';
import 'package:booking_haircut_application/data/model/receiptmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../cashierpage/mainpage.dart';
import 'package:flutter/material.dart';
import '../../../config/const.dart';

import 'package:intl/intl.dart';
import 'package:dotted_line/dotted_line.dart';
import '../../../config/custom_widget.dart';
import '../../../data/api/sqlite.dart';
import '../../../data/model/branchmodel.dart';
import '../../../data/model/ordermodel.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class SuccessWidget extends StatefulWidget {
  final Receipt? receipt;
  const SuccessWidget({
    super.key,
    this.receipt,
  });

  @override
  State<SuccessWidget> createState() => _SuccessWidgetState();
}

class _SuccessWidgetState extends State<SuccessWidget> {
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseHelper _databaseHelper = DatabaseHelper();

    Future<List<ReceiptService>> _getListService() async {
      return await _databaseHelper.getServiceByReceipt(widget.receipt?.id);
    }

    Future<Employee?> _getEmployee(int? id) async {
      return await _databaseHelper.getEmployeeById(id!);
    }

    Future<Branch?> _getBranch(int? id) async {
      return await _databaseHelper.getBranchById(id);
    }

    return Scaffold(
      body: widget.receipt?.id == 0
          ? LoadingScreen()
          : Stack(
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
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              decoration: const BoxDecoration(),
                              child: Image.asset(urlSuccess),
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
                            height: 10,
                          ),
                          // Thông tin hóa đơn
                          Container(
                            width: double.maxFinite,
                            padding: const EdgeInsets.fromLTRB(4, 10, 4, 10),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(40.0),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 0,
                                  blurRadius: 4,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              color: branchColor20.withOpacity(0.3),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                    width: 100,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 5,
                                        bottom: 5,
                                      ),
                                      child: Container(
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color:
                                              branchColor, // Thay thế bằng màu branchColor của bạn
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
                                const SizedBox(
                                  height: 5,
                                ),
                                // Mã hóa đơn
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          "HD${widget.receipt?.id.toString().padLeft(6, '0')}",
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
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          widget.receipt!.dateCreate!,
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
                                // Tên khách hàng
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      const Expanded(
                                        child: Text(
                                          "Khách hàng:",
                                          style: subtitleDetailStyle,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                        child: Text(
                                          widget.receipt!.name!,
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
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          widget.receipt!.phone!,
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
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      const Expanded(
                                        child: Text(
                                          "Chi nhánh cắt:",
                                          style: subtitleDetailStyle,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                        child: FutureBuilder(
                                          future: _getBranch(
                                              widget.receipt!.branch),
                                          builder: (context, snapshot) => Text(
                                            snapshot.data?.anothername ?? "",
                                            style: infoDetailStyle,
                                            maxLines: 4,
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
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          future: _getEmployee(
                                              widget.receipt!.employee),
                                          builder: (context, snapshot) => Text(
                                            "Thợ tóc - ${snapshot.data?.name}",
                                            style: infoDetailStyle,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Kỹ thuật viên ----------------End
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
                                // // DANH SÁCH DỊCH VỤ
                                FutureBuilder(
                                    future: _getListService(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else {
                                        List<ReceiptService> lstSer =
                                            snapshot.data!;
                                        return ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: lstSer.length,
                                          itemBuilder: (context, index) {
                                            return itemServiceReceiptNEW(
                                                lstSer[index], index, context);
                                          },
                                        );
                                      }
                                    }),

                                // // DANH SÁCH DỊCH VỤ ----------------End
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                                  child: DottedLine(
                                    dashColor: branchColor40,
                                    dashLength: 5,
                                    dashGapLength: 2,
                                    dashRadius: 8,
                                  ),
                                ),
                                // Số tiếp tip
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      const Expanded(
                                        child: Text(
                                          "Tiền tip:",
                                          style: subtitleDetailStyle,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                        child: Text(
                                          NumberFormat('###,###.### đ')
                                              .format(widget.receipt!.tip),
                                          style: infoDetailStyle,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Số tiếp tip ----------------End
                                const SizedBox(
                                  height: 5,
                                ),
                                // Tổng tiền
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 16, 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              .format(widget.receipt!.total),
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
                          ),
                          // Thông tin hóa đơn ------------End
                          const SizedBox(
                            height: 10,
                          ),
                          // Đánh giá
                          const Text(
                            "Đánh giá dịch vụ",
                            style: headingStyle,
                          ),
                          RatingBar.builder(
                            initialRating: 4,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 2),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star_rounded,
                              color: starColor,
                            ),
                            onRatingUpdate: (rating) => {},
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextField(
                            controller: _contentController,
                            maxLines: 2,
                            maxLength: 60,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide(color: branchColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16.0),
                                ),
                                borderSide:
                                    BorderSide(color: branchColor, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16.0),
                                ),
                                borderSide:
                                    BorderSide(color: branchColor, width: 2),
                              ),
                              hintText: 'Nhập đánh giá của bạn',
                            ),
                            cursorColor: branchColor,
                          ),
                          // Đánh giá ------------End
                          // Button
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(4, 16, 4, 16),
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
                                    child: FilledButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => MainPage()),
                                        );
                                      },
                                      style: FilledButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
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
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
