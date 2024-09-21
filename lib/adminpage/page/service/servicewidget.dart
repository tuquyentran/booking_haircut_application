import 'package:booking_haircut_application/adminpage/page/service/service_add_typewidget.dart';
import 'package:booking_haircut_application/adminpage/page/service/service_addwidget.dart';
import 'package:booking_haircut_application/data/model/servicetypemodel.dart';
import 'package:booking_haircut_application/data/provider/serviceprovider.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../config/const.dart';
import '../../../config/list/service_body.dart';
import '../../../config/list/servicetype_body.dart';
import '../../../data/api/sqlite.dart';
import '../../../data/model/servicemodel.dart';
import '../../../data/provider/servicetypeprovider.dart';

class Servicewidget extends StatefulWidget {
  const Servicewidget({super.key});

  @override
  State<Servicewidget> createState() => _ServicewidgetState();
}

class _ServicewidgetState extends State<Servicewidget> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  Future<List<ServiceType>> _getServiceType() async {
    // thêm vào 1 dòng dữ liệu nếu getdata không có hoặc chưa có database
    return await _databaseHelper.listservicetypes();
  }

  Future<List<Service>> _getService() async {
    // thêm vào 1 dòng dữ liệu nếu getdata không có hoặc chưa có database
    return await _databaseHelper.listservices();
  }

  @override
  void initState() {
    super.initState();
    _getServiceType();
    _getService();
  }

  @override
  Widget build(BuildContext context) {
    final ServiceType serviceType;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(color: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //BUTTON TIM KIEM
                  // SizedBox(
                  //   height: 50,
                  //   child: TextFormField(
                  //     // onChanged: onQueryChanged,
                  //     //controller: _nameController,
                  //     decoration: const InputDecoration(
                  //       contentPadding: EdgeInsets.symmetric(horizontal: 5),
                  //       hintText: "Tìm kiếm...",
                  //       labelStyle: TextStyle(
                  //         color: branchColor80,
                  //         fontStyle: FontStyle.italic,
                  //       ), // Replace with branchColor
                  //       border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.all(
                  //           Radius.circular(16.0),
                  //         ),
                  //         borderSide: BorderSide(color: branchColor, width: 1),
                  //       ),
                  //       enabledBorder: OutlineInputBorder(
                  //         borderRadius: BorderRadius.all(
                  //           Radius.circular(16.0),
                  //         ),
                  //         borderSide: BorderSide(color: branchColor, width: 1),
                  //       ),
                  //       focusedBorder: OutlineInputBorder(
                  //         borderRadius: BorderRadius.all(
                  //           Radius.circular(16.0),
                  //         ),
                  //         borderSide: BorderSide(color: branchColor, width: 2),
                  //       ),
                  //       prefixIcon: Icon(Icons.search_outlined),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 10),

                  //DANH SACH LOAI DICH VU
                  Row(
                    children: [
                      const Expanded(
                        flex: 3,
                        child: Text(
                          "Danh sách loại dịch vụ",
                          style: headingStyle,
                        ),
                      ),

                      //nút thêm.................
                      Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ServiceAddTypewidget()),
                                ).then((_) {
                                  setState(() {});
                                });
                              },
                              icon: const Icon(Icons.add_circle_outline),
                            ),
                          )),

                      const SizedBox(width: 10),
                    ],
                  ),
                  const Divider(
                    color: branchColor,
                    height: 10,
                    thickness: 2,
                  ),
                  const SizedBox(height: 10),

                  //NOI DUNG DANH SACH LOAI DICH VU

                  Expanded(
                    flex: 1,
                    child: FutureBuilder<List<ServiceType>>(
                      future: _getServiceType(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Container(
                          // width: 800,
                          // height: 100,
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final itemType = snapshot.data![index];
                              return Dismissible(
                                key: ValueKey<int>(itemType.id!),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: const Icon(Icons.delete,
                                      color: Colors.white),
                                ),
                                onDismissed: (direction) {
                                  setState(() {
                                    DatabaseHelper()
                                        .deleteServicetypeAdmin(itemType.id!);
                                  });
                                },
                                child:
                                    itemServiceType(itemType, index, context),
                              );
                              // itemServiceType(
                              //     itemType, index, context);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  //DANH SACH DICH VU
                  Container(
                    child: Row(
                      children: [
                        const Expanded(
                          flex: 3,
                          child: Text(
                            "Danh sách dịch vụ",
                            style: headingStyle,
                          ),
                        ),

                        //nút thêm.................
                        Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ServiceAddwidget()),
                                  ).then((_) {
                                    setState(() {});
                                  });
                                },
                                icon: const Icon(Icons.add_circle_outline),
                              ),
                            )),
                      ],
                    ),
                  ),
                  const Divider(
                    color: branchColor,
                    height: 10,
                    thickness: 2,
                  ),
                  const SizedBox(height: 10),

                  //NOI DUNG DANH SACH DICH VU
                  Expanded(
                    flex: 3,
                    child: FutureBuilder<List<Service>>(
                      future: _getService(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            // itemCount: 23,
                            itemBuilder: (context, index) {
                              final itemservice = snapshot.data![index];
                              return Dismissible(
                                  key: ValueKey<int>(itemservice.id!),
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    color: Colors.red,
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: const Icon(Icons.delete,
                                        color: Colors.white),
                                  ),
                                  onDismissed: (direction) {
                                    setState(() {
                                      DatabaseHelper()
                                          .deleteServiceAdmin(itemservice.id!);
                                    });
                                  },
                                  child:
                                      itemService(itemservice, index, context));
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  // ElevatedButton(
                  //   onPressed: () async {
                  //     await _databaseHelper.deleteAllData();
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //       SnackBar(content: Text('All data has been deleted')),
                  //     );
                  //   },
                  //   child: Text('Delete All Data'),
                  // )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
