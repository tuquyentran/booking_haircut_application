import 'package:booking_haircut_application/cashierpage/page/receipt/receipt_detailwidget.dart';
import 'package:booking_haircut_application/config/list/service_body.dart';
import 'package:booking_haircut_application/data/provider/employeeprovider.dart';
import 'package:flutter/material.dart';
import 'package:booking_haircut_application/data/model/receiptmodel.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:booking_haircut_application/config/const.dart';
import 'package:intl/intl.dart';
import 'package:ticket_widget/ticket_widget.dart';

import '../../adminpage/page/bill/receipt_detailwidget.dart';
import '../../data/api/sqlite.dart';

// Widget `itemReceiptView` cải thiện
Widget itemReceiptView(Receipt item, int index, BuildContext context) {
  return InkWell(
    onTap: () {
      // Hành động khi nhấn vào hóa đơn
    },
    child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(urlBackground),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 15, 12, 0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: TicketWidget(
                color: branchColor40.withOpacity(0.3),
                width: 360,
                height: 650,
                isCornerRounded: true,
                padding: const EdgeInsets.all(16),
                child: TicketData(receipt: item),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    ),
  );
}

class TicketData extends StatelessWidget {
  final Receipt receipt;

  const TicketData({Key? key, required this.receipt}) : super(key: key);

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
          _buildRow(
              "Mã hóa đơn:", "HD${receipt.id.toString().padLeft(6, '0')}"),
          const SizedBox(height: 5),
          _buildRow("Ngày tạo:", receipt.dateCreate.toString()),
          const SizedBox(height: 5),
          _buildRow("Khách hàng:", receipt.name ?? "Chưa có dữ liệu"),
          const SizedBox(height: 5),
          _buildRow("Số điện thoại:", receipt.phone ?? "Chưa có dữ liệu"),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: DottedLine(
              dashColor: branchColor40,
              dashLength: 5,
              dashGapLength: 2,
              dashRadius: 8,
            ),
          ),
          _buildRow(
              "Chi nhánh cắt:", receipt.branch.toString() ?? "Chưa có dữ liệu"),
          const SizedBox(height: 5),
          _buildRow("Kỹ thuật viên:",
              "Thợ tóc - ${receipt.employee ?? 'Chưa có dữ liệu'}"),
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
          ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10),
            shrinkWrap: true,
            itemCount: receipt.services?.length ?? 0,
            itemBuilder: (context, index) {
              final service = receipt.services![index];
              return itemServiceOrder(service, index, context);
            },
          ),
          const SizedBox(height: 5),
          const DottedLine(
            dashColor: branchColor,
            dashLength: 5,
            dashGapLength: 2,
            dashRadius: 8,
          ),
          const SizedBox(height: 10),
          const SizedBox(height: 5),
          _buildRow("Tiền tip:", receipt.tip.toString() ?? "Chưa có dữ liệu"),
          _buildRowBoldTitle(
            "Tổng tiền:",
            NumberFormat('###,###.### đ').format(receipt.total ?? 0),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Text(
              title,
              style: subtitleDetailStyle2,
            ),
          ),
          const SizedBox(width: 1),
          Expanded(
            child: Text(
              value,
              style: infoDetailStyle3,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowBoldTitle(String title, String value) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Text(
              title,
              style: subtitleDetailStyle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
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

Widget itemReceiptViewForEmployee(
    Receipt item, int index, BuildContext context) {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReceiptDetail(
            receipt: item,
          ),
        ),
      );
    },
    child: Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                (index + 1).toString(),
                style: serialStyle,
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "HD${item.id.toString().padLeft(6, '0')}",
                    style: infoListStyle,
                  ),
                  Text(
                    item.dateCreate.toString(),
                    style: infoListStyle2,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder(
                      future: _databaseHelper.getEmployeeById(item.employee!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return Text(
                            snapshot.data!.name.toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: infoListStyle,
                          );
                        }
                      })
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                NumberFormat('###,###.### đ').format(item.total),
                style: infoListStyle,
                textAlign: TextAlign.right,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        const DottedLine(
          dashColor: branchColor20,
          dashLength: 5,
          dashGapLength: 2,
          dashRadius: 8,
        ),
      ],
    ),
  );
}
