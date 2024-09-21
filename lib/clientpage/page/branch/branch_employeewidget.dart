import 'dart:convert';

import 'package:booking_haircut_application/clientpage/page/booking/bookingwidget.dart';
import 'package:booking_haircut_application/config/const.dart';
import 'package:booking_haircut_application/data/api/sqlite.dart';
import 'package:booking_haircut_application/data/model/branchmodel.dart';
import 'package:booking_haircut_application/loginwidget.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../../../config/list/employee_body.dart';
import '../../../data/model/employeemodel.dart';

class BranchEmployeewidget extends StatefulWidget {
  const BranchEmployeewidget({super.key});

  @override
  State<BranchEmployeewidget> createState() => _BranchDetailwidgetState();
}

class _BranchDetailwidgetState extends State<BranchEmployeewidget> {
  Branch branch = Branch(id: 0);
  List<Employee> lstEmp = [];

  final DatabaseHelper _databaseEmployee = DatabaseHelper();

  Future<List<Employee>> _getEmployees() async {
    return await _databaseEmployee.getEmployeesByBranch(branch.id);
  }

  getBranch() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String strBranch = pref.getString('branch')!;

    if (strBranch == null) {
      branch = Branch(id: 0);
    } else {
      branch = Branch.fromJson(jsonDecode(strBranch));
      lstEmp =
          await _getEmployees(); // Cập nhật danh sách nhân viên từ chi nhánh
      lstEmp.removeWhere((employee) => employee.role == 1);
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getBranch();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: branch.name == null
            ? Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(urlBackground),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const Center(
                    child: CircularProgressIndicator(
                      color: branchColor,
                      backgroundColor: branchColor20,
                    ),
                  )
                ],
              )
            : Stack(
                children: [
                  Image.asset(
                    urlImgShop + branch.image!,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image),
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
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 20, 20, 10),
                                        child: Center(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                child: Text(
                                                  branch.name!,
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
                                                      branch.address!,
                                                      style: subtitleStyle17n,
                                                      softWrap: true,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.clip,
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
                                              const Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Danh sách nhân viên',
                                                    style: headingStyle,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ],
                                              ),

                                              FutureBuilder<List<Employee>>(
                                                future: _getEmployees(),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const Center(
                                                        child:
                                                            CircularProgressIndicator());
                                                  }
                                                  return SizedBox(
                                                    height:
                                                        350.0, // Chiều cao cụ thể
                                                    child: ListView.builder(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10),
                                                      itemCount:
                                                          snapshot.data!.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        final employee =
                                                            snapshot
                                                                .data![index];
                                                        return itemEmployeeCus(
                                                            employee, context);
                                                      },
                                                    ),
                                                  );
                                                },
                                              ),

                                              // -------------------
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Positioned(
                                                bottom: 0,
                                                left: 0,
                                                right: 0,
                                                child: Container(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(0),
                                                    child: Stack(
                                                      clipBehavior: Clip.none,
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed: () {
                                                                  Navigator
                                                                      .push(
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
                                                                            .circular(8),
                                                                  ),
                                                                  backgroundColor:
                                                                      branchColor,
                                                                ),
                                                                child:
                                                                    const Text(
                                                                  "Đặt lịch cắt tóc",
                                                                  style:
                                                                      textButtonStyle17w,
                                                                  textAlign:
                                                                      TextAlign
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
