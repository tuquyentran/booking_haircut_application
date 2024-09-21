import 'package:booking_haircut_application/adminpage/page/service/service_edit_typewidget.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

import '../../../config/const.dart';
import '../../../data/api/sqlite.dart';
import '../../../data/model/servicemodel.dart';
import '../../../data/model/servicetypemodel.dart';

class ServiceDetailTypewidget extends StatefulWidget {
  final int serviceTypeId;
  const ServiceDetailTypewidget({Key? key, required this.serviceTypeId})
      : super(key: key);

  @override
  State<ServiceDetailTypewidget> createState() =>
      _ServiceDetailTypewidgetState();
}

class _ServiceDetailTypewidgetState extends State<ServiceDetailTypewidget> {
  Future<ServiceType>? _typeFuture;

  @override
  void initState() {
    super.initState();
    _typeFuture = getTypeById(widget.serviceTypeId);
    _getServiceByType();
  }

  Future<ServiceType> getTypeById(int id) async {
    return await _databaseHelper.servicetype(id);
  }

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<List<Service>> _getServiceByType() async {
    return await _databaseHelper.getServicesByType(widget.serviceTypeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Quản lý dịch vụ",
          style: titleStyleAdmin,
        ),
        backgroundColor: branchColor,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.white),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: FutureBuilder(
                  future: _typeFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final type = snapshot.data!;
                    return SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //THONG TIN LOAI DICH VU
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Thông tin loại dịch vụ",
                                style: headingStyle,
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ServiceEditTypewidget(
                                                  serviceTypeModel: type,
                                                  onServiceTypeUpdated:
                                                      (value) {
                                                    setState(() {
                                                      _typeFuture = getTypeById(
                                                          widget
                                                              .serviceTypeId); // Cập nhật Future
                                                    });
                                                  },
                                                ))).then((_) {
                                      setState(() {});
                                    });
                                  },
                                  icon: const Icon(Icons.edit_note_rounded),
                                ),
                              )
                            ],
                          ),

                          const Divider(
                            color: branchColor,
                            height: 10,
                            thickness: 2,
                          ),
                          const SizedBox(height: 5),

                          //MA LOAI DICH VU
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Expanded(
                                  child: Text(
                                    "Mã loại dịch vụ:",
                                    style: subtitleDetailStyle,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Text(
                                    type.id.toString(),
                                    style: infoDetailStyle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),

                          //TEN LOAI DICH VU
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Expanded(
                                  child: Text(
                                    "Tên loại dịch vụ:",
                                    style: subtitleDetailStyle,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Text(
                                    type.name.toString(),
                                    style: infoDetailStyle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          //DICH VU LIEN QUAN
                          const Text(
                            "Dịch vụ liên quan",
                            style: headingStyle,
                          ),
                          const Divider(
                            color: branchColor,
                            height: 10,
                            thickness: 2,
                          ),

                          //NOI DUNG DICH VU LIEN QUAN
                          Expanded(
                            child: FutureBuilder<List<Service>>(
                                future: _getServiceByType(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  return Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: ListView.builder(
                                      itemCount: snapshot.data!.length,
                                      // itemCount: 5,
                                      itemBuilder: (context, index) {
                                        final itemservice =
                                            snapshot.data![index];
                                        return Padding(
                                          padding: const EdgeInsets.all(0),
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          itemservice.id
                                                              .toString(),
                                                          style: infoListStyle,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          type.name!,
                                                          style: infoListStyle,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Text(
                                                      itemservice.name
                                                          .toString(),
                                                      style: infoListStyle,
                                                      textAlign:
                                                          TextAlign.right,
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
                                      },
                                    ),
                                  );
                                }),
                          )
                        ],
                      ),
                    );
                  }))
        ],
      ),
    );
  }
}
