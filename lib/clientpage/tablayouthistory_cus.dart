import 'package:booking_haircut_application/clientpage/page/profile/history_billwidget.dart';
import 'package:booking_haircut_application/clientpage/page/profile/history_orderwidget.dart';
import 'package:booking_haircut_application/data/model/customermodel.dart';
import 'package:flutter/material.dart';
import 'package:booking_haircut_application/config/const.dart';

class TabBarHistory extends StatefulWidget {
  final Customer customer;
  const TabBarHistory({Key? key, required this.customer}) : super(key: key);

  @override
  State<TabBarHistory> createState() => _TabBarHistoryState();
}

class _TabBarHistoryState extends State<TabBarHistory> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Số lượng tabs
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(urlBackground),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 45,
                bottom: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      BackButton(
                        color: branchColor,
                      ),
                      // Khoảng cách giữa nút Back và nội dung chính
                      Align(
                        alignment: Alignment.center,
                        child: Center(
                          child: Text(
                            "Lịch sử",
                            style: headingStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TabBar(
                    dividerHeight: 1,
                    dividerColor: branchColor, // Màu sắc của divider
                    labelColor: branchColor,
                    indicatorWeight: BorderSide.strokeAlignCenter,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor: branchColor,
                    indicator: BoxDecoration(
                      color: branchColor20, // Màu nền của indicator
                      border: Border(
                        right: BorderSide(
                          color: branchColor, // Màu sắc của divider
                          width: 1, // Độ rộng của divider
                        ),
                        left: BorderSide(
                          color: branchColor, // Màu sắc của divider
                          width: 1, // Độ rộng của divider
                        ),
                      ),
                    ),
                    indicatorPadding: EdgeInsets.all(1),
                    labelPadding: EdgeInsets.all(0),
                    tabs: [
                      Tab(
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            'Đơn đặt',
                            style: titleStyle16,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Tab(
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            'Hóa đơn',
                            style: titleStyle16,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        HistoryOrderwidget(customer: widget.customer),
                        HistoryBillwidget(customer: widget.customer),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
