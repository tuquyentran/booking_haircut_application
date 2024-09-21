import 'dart:convert';

import 'package:booking_haircut_application/clientpage/page/booking/bookingwidget.dart';
import 'package:booking_haircut_application/clientpage/page/branch/branch_employeewidget.dart';
import 'package:booking_haircut_application/clientpage/page/branch/branch_servicewidget.dart';
import 'package:booking_haircut_application/config/const.dart';
import 'package:booking_haircut_application/config/list/employee_body.dart';
import 'package:booking_haircut_application/data/model/branchmodel.dart';
import 'package:booking_haircut_application/data/model/servicemodel.dart';
import 'package:booking_haircut_application/loginwidget.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/list/service_body.dart';
import '../../../data/model/employeemodel.dart';
import '../../../data/model/selectedCusmodel.dart';

class BranchDetailwidget extends StatefulWidget {
  final Branch branch;
  const BranchDetailwidget({super.key, required this.branch});

  @override
  State<BranchDetailwidget> createState() => _BranchDetailwidgetState();
}

class _BranchDetailwidgetState extends State<BranchDetailwidget> {
  @override
  Widget build(BuildContext context) {
    final selectedProvider = Provider.of<SelectedCusModel>(context);

    List<Employee> lstEmp = widget.branch.employees!;
    lstEmp.removeWhere((employee) => employee.role == 1);
    List<Service> lstSer = widget.branch.services!;

    Future<bool> saveBranch(Branch obj) async {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String strBranch = jsonEncode(obj);
        prefs.setString('branch', strBranch);
        return true;
      } catch (e) {
        print(e);
        return false;
      }
    }

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: Stack(
          children: [
            Image.asset(
              urlImgShop + widget.branch.image!,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BackButton(
                    color: whiteColor,
                  ),
                ),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 220),
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(urlBackground),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(28),
                                topRight: Radius.circular(28),
                              ),
                            ),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 20, 20, 10),
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          child: Text(
                                            widget.branch.name!,
                                            style: titleStyle30,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.location_on_outlined,
                                              size: 30,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                widget.branch.address!,
                                                style: subtitleStyle17n,
                                                softWrap: true,
                                                maxLines: 2,
                                                overflow: TextOverflow.clip,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.star_border_outlined,
                                              size: 30,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "5.0",
                                              style: subtitleStyle17n,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Danh sách nhân viên',
                                              style: headingStyle,
                                              textAlign: TextAlign.start,
                                            ),
                                            const Spacer(),
                                            GestureDetector(
                                              onTap: () async {
                                                var obj = widget.branch;
                                                if (await saveBranch(obj) ==
                                                    true) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const BranchEmployeewidget(),
                                                    ),
                                                  );
                                                } else {
                                                  print(
                                                      "Không lấy được branch");
                                                }
                                              },
                                              child: const Expanded(
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text('Xem thêm',
                                                        style:
                                                            textButtonStyle2),
                                                    SizedBox(
                                                      width: 2,
                                                    ),
                                                    Icon(
                                                      Icons
                                                          .arrow_forward_ios_outlined,
                                                      size: 15,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        // Danh sách nhân viên
                                        ListView.builder(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: lstEmp.length < 2
                                              ? lstEmp.length
                                              : 2,
                                          itemBuilder: (context, index) {
                                            var employee = lstEmp[index];
                                            return itemEmployeeCus(
                                                employee, context);
                                          },
                                        ),
                                        // -------------------
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Dịch vụ cung cấp',
                                              style: headingStyle,
                                              textAlign: TextAlign.start,
                                            ),
                                            const Spacer(),
                                            GestureDetector(
                                              onTap: () async {
                                                var obj = widget.branch;
                                                if (await saveBranch(obj) ==
                                                    true) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const BranchServicewidget(),
                                                    ),
                                                  );
                                                } else {
                                                  print(
                                                      "Không lấy được branch");
                                                }
                                              },
                                              child: const Expanded(
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text('Xem thêm',
                                                        style:
                                                            textButtonStyle2),
                                                    SizedBox(
                                                      width: 2,
                                                    ),
                                                    Icon(
                                                      Icons
                                                          .arrow_forward_ios_outlined,
                                                      size: 15,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        // Danh sách dịch vụ
                                        ListView.builder(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: lstSer.length < 5
                                              ? lstSer.length
                                              : 5,
                                          itemBuilder: (context, index) {
                                            var service = lstSer[index];
                                            return itemServiceBranch(
                                                service, context);
                                          },
                                        ),
                                        // -------------------
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        const Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Đánh giá',
                                              style: headingStyle,
                                              textAlign: TextAlign.start,
                                            ),
                                            const Spacer(),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        const SizedBox(height: 15),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                            height: 50,
                                            decoration: const BoxDecoration(),
                                            child: Padding(
                                              padding: const EdgeInsets.all(0),
                                              child: Stack(
                                                clipBehavior: Clip.none,
                                                alignment: Alignment.center,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          onPressed: () async {
                                                            selectedProvider
                                                                .Selected(widget
                                                                    .branch);
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          const BookingCuswidget()),
                                                            );
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                            backgroundColor:
                                                                branchColor,
                                                          ),
                                                          child: const Text(
                                                            "Đặt lịch cắt tóc",
                                                            style:
                                                                textButtonStyle17w,
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          // Thanh tạm tính
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
