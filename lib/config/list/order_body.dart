import 'package:booking_haircut_application/config/list/service_body.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ticket_widget/ticket_widget.dart';
import '../../cashierpage/page/order/order_detailwidget.dart';
import '../../data/api/sqlite.dart';
import '../../data/provider/employeeprovider.dart';
import '../const.dart';
import '../../data/model/ordermodel.dart';
import 'package:dotted_line/dotted_line.dart';

Widget itemOrderView(Order item, int index, BuildContext context) {
  return InkWell(
    onTap: () {},
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
                child: TicketData(order: item),
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
  final Order order;

  const TicketData({Key? key, required this.order}) : super(key: key);

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
              "Thông tin đơn đặt",
              style: headingStyle,
            ),
          ),
          const SizedBox(height: 5),
          _buildRow("Mã đơn đặt:", "DD${order.id.toString().padLeft(6, '0')}"),
          const SizedBox(height: 5),
          _buildRow("Ngày tạo:", order.date.toString()),
          const SizedBox(height: 5),
          _buildRow("Khách hàng:", order.name ?? "Chưa có dữ liệu"),
          const SizedBox(height: 5),
          _buildRow("Số điện thoại:", order.phone ?? "Chưa có dữ liệu"),
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
              "Chi nhánh cắt:", order.branch.toString() ?? "Chưa có dữ liệu"),
          const SizedBox(height: 5),
          _buildRow("Kỹ thuật viên:",
              "Thợ tóc - ${order.employee ?? 'Chưa có dữ liệu'}"),
          const SizedBox(height: 5),
          _buildRow("Ngày đặt:", order.date.toString()),
          const SizedBox(height: 5),
          _buildRow("Khung giờ:", order.time ?? "Chưa có dữ liệu"),
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
            itemCount: order.services?.length ?? 0,
            itemBuilder: (context, index) {
              final service = order.services![index];
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
          _buildRowBoldTitle(
            "Tổng tiền:",
            NumberFormat('###,###.### đ').format(order.total ?? 0),
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

Widget itemOrderViewCashier(Order item, int index, BuildContext context) {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderDetail(
            order: item,
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
                    "DD${item.id.toString().padLeft(6, '0')}",
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
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                    },
                  ),
                  Text(
                    // ignore: prefer_interpolation_to_compose_strings
                    item.time.toString() + ', ' + item.date.toString(),
                    style: infoListStyle2,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                item.name.toString(),
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
