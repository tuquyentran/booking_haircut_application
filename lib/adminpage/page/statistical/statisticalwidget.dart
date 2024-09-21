import 'package:flutter/material.dart';
import 'package:booking_haircut_application/config/const.dart';
import 'package:intl/intl.dart';

class Statisticalwidget extends StatefulWidget {
  const Statisticalwidget({super.key});

  @override
  State<Statisticalwidget> createState() => _StatisticalwidgetState();
}

class _StatisticalwidgetState extends State<Statisticalwidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        child: Center(
          child: SafeArea(
            child: ListView(
              children: [
                Column(
                  children: [
                    // Box 1
                    Row(
                      children: [
                        // Box - Số đơn đặt
                        Expanded(
                          flex: 5,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(16.0),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 0,
                                  blurRadius: 4,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              color: branchColor20.withOpacity(0.6),
                            ),
                            child: const Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "60",
                                      style: numberStatisticalStyle,
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Icon(Icons.receipt_rounded)
                                  ],
                                ),
                                Text(
                                  "Số đơn đặt lịch cắt tóc",
                                  maxLines:
                                      2, // Đặt maxLines thành 2 để wrap text nếu quá dài
                                  overflow: TextOverflow.ellipsis,
                                  style: textStatisticalStyle,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Box - Số đơn đặt ------------End
                        const SizedBox(
                          width: 10,
                        ),
                        // Box - Số hóa đơn
                        Expanded(
                          flex: 5,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(16.0),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 0,
                                  blurRadius: 4,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              color: branchColor20.withOpacity(0.6),
                            ),
                            child: const Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "157",
                                      style: numberStatisticalStyle,
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Icon(Icons.receipt_long_rounded)
                                  ],
                                ),
                                Text("Số hóa đơn cắt tóc",
                                    maxLines:
                                        2, // Đặt maxLines thành 2 để wrap text nếu quá dài
                                    overflow: TextOverflow.ellipsis,
                                    style: textStatisticalStyle),
                              ],
                            ),
                          ),
                        ),

                        // Box - Số hóa đơn ------------End
                      ],
                    ),
                    // Box 1 --------End
                    const SizedBox(
                      height: 10,
                    ),
                    // Box 2
                    Row(
                      children: [
                        // Box - Số đơn đặt trong ngày
                        Expanded(
                          flex: 5,
                          child: Container(
                            width: 160,
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(16.0),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 0,
                                  blurRadius: 4,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              color: branchColor20.withOpacity(0.6),
                            ),
                            child: const Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "20",
                                      style: numberStatisticalStyle,
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Icon(Icons.pending_actions_rounded)
                                  ],
                                ),
                                Text("Số đơn đặt trong ngày",
                                    maxLines:
                                        2, // Đặt maxLines thành 2 để wrap text nếu quá dài
                                    overflow: TextOverflow.ellipsis,
                                    style: textStatisticalStyle),
                              ],
                            ),
                          ),
                        ),
                        // Box - Số đơn đặt trong ngày ------------End
                        const SizedBox(
                          width: 10,
                        ),
                        // Box - Số nhân viên cắt tóc
                        Expanded(
                          flex: 5,
                          child: Container(
                            width: 160,
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(16.0),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 0,
                                  blurRadius: 4,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              color: branchColor20.withOpacity(0.6),
                            ),
                            child: const Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "8",
                                      style: numberStatisticalStyle,
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Icon(Icons.groups_rounded)
                                  ],
                                ),
                                Text("Số hóa đơn cắt tóc",
                                    maxLines:
                                        2, // Đặt maxLines thành 2 để wrap text nếu quá dài
                                    overflow: TextOverflow.ellipsis,
                                    style: textStatisticalStyle),
                              ],
                            ),
                          ),
                        ),
                        // Box - Số nhân viên cắt tóc ------------End
                      ],
                    ),
                    // Box 2 --------End
                    const SizedBox(
                      height: 10,
                    ),
                    // Box - Tổng doanh thu
                    Container(
                      width: double.maxFinite,
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(16.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 0,
                            blurRadius: 4,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        color: branchColor20.withOpacity(0.6),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text("Tổng doanh thu",
                              maxLines:
                                  2, // Đặt maxLines thành 2 để wrap text nếu quá dài
                              overflow: TextOverflow.ellipsis,
                              style: textStatisticalStyle),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            NumberFormat('###,###,### đ').format(1520000),
                            style: numberStatisticalStyle,
                          ),
                        ],
                      ),
                    ),
                    // Box - Tổng doanh thu ------------End
                    const SizedBox(
                      height: 30,
                    ),
                    //title doanh thu cac chi nhanh
                    Container(
                      child: const Column(
                        children: [
                          Row(
                            children: <Widget>[
                              Text(
                                "Doanh thu của các chi nhánh",
                                style: titleStyle22,
                              ),
                              Spacer(),
                              Icon(Icons.filter_list_rounded),
                            ],
                          ),
                          Divider(
                            color: branchColor,
                            height: 10,
                            thickness: 2,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 100,
                      child: ListView(
                        children: [
                          for (int i = 1; i <= 3; i++)
                            Container(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "$i",
                                        style: infoDetailStyle,
                                      ),
                                      const SizedBox(width: 10),
                                      const Text(
                                        "4R Quan 1",
                                        style: infoDetailStyle,
                                      ),
                                      const Spacer(),
                                      Text(
                                        NumberFormat('###,###,### đ')
                                            .format(1000000000),
                                        style: infoDetailStyle,
                                      ),
                                    ],
                                  ),
                                  const Divider(
                                    color: branchColor,
                                    height: 10,
                                    thickness: 2,
                                  ),
                                ],
                              ),
                            )
                        ],
                      ),
                    ),
                    //title nhân viên có nhiều đơn đặt
                    Container(
                      child: const Column(
                        children: [
                          Row(
                            children: <Widget>[
                              Text(
                                "Nhân viên có nhiều đơn đặt",
                                style: titleStyle22,
                              ),
                              Spacer(),
                              Icon(Icons.filter_list_rounded),
                            ],
                          ),
                          Divider(
                            color: branchColor,
                            height: 10,
                            thickness: 2,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 100,
                      child: ListView(
                        children: [
                          for (int i = 1; i <= 3; i++)
                            Container(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "$i",
                                        style: infoDetailStyle,
                                      ),
                                      const SizedBox(width: 10),
                                      const Text(
                                        "Kiem",
                                        style: infoDetailStyle,
                                      ),
                                      const Spacer(),
                                      const Text(
                                        "4R Quan 1",
                                        style: infoDetailStyle,
                                      ),
                                      const Spacer(),
                                      Text(
                                        NumberFormat('###,###,###').format(169),
                                        style: infoDetailStyle,
                                      ),
                                    ],
                                  ),
                                  const Divider(
                                    color: branchColor,
                                    height: 10,
                                    thickness: 2,
                                  ),
                                ],
                              ),
                            )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
