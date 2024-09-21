import 'package:booking_haircut_application/config/list/service_body.dart';
import 'package:booking_haircut_application/adminpage/page/service/service_detail_typewidget.dart';
import 'package:booking_haircut_application/data/model/branch_servicemodel.dart';
import 'package:provider/provider.dart';
import 'package:dotted_line/dotted_line.dart';
import '../../data/api/sqlite.dart';
import '../../data/model/selectedCusmodel.dart';
import '../../data/model/servicemodel.dart';
import '../../data/model/servicetypemodel.dart';
import 'package:flutter/material.dart';
import '../../data/provider/servicetypeprovider.dart';
import '../const.dart';

Widget ListViewServiceCus(List<int?> uniqueTypes, List<Service> list) {
  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: uniqueTypes.length,
    itemBuilder: (context, typeIndex) {
      var serviceType = uniqueTypes[typeIndex];
      var servicesOfType =
          list.where((service) => service.type == serviceType).toList();
      return FutureBuilder(
          future: ReadDataServiceType().loadTypeById(serviceType),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(snapshot.data!.name.toString(), style: subtitleStyle17),
                  ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: servicesOfType.length,
                    itemBuilder: (context, index) {
                      return serviceForSelectCus(
                          servicesOfType[index], context);
                    },
                  ),
                ],
              );
            }
          });
    },
  );
}

Widget ListViewServiceCashier(
    List<int?> uniqueTypes, List<BranchService> list) {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<Service?> _getService(int? id) async {
    return await _databaseHelper.getServiceById(id);
  }

  Future<List<BranchService>> _getList(int? type) async {
    List<BranchService> lstService = [];
    for (var item in list) {
      var ser = await _getService(item.service);
      if (type == ser?.type) {
        lstService.add(item);
      }
    }
    print(lstService.length);
    return lstService;
  }

  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: uniqueTypes.length,
    itemBuilder: (context, typeIndex) {
      var serviceType = uniqueTypes[typeIndex];

      return FutureBuilder(
          future: _databaseHelper.getServiceTypeById(serviceType!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              var name = snapshot.data?.name.toString();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name.toString() ?? "Không tìm thấy",
                      style: subtitleStyle17),
                  FutureBuilder(
                      future: _getList(serviceType),
                      builder: (context, snap) {
                        if (snap.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          var service = snap.data;
                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snap.data?.length,
                            itemBuilder: (context, index) {
                              return serviceForSelectCashier(
                                  service![index], context);
                            },
                          );
                        }
                      }),
                ],
              );
            }
          });
    },
  );
}

Widget itemServiceType(ServiceType item, int index, BuildContext context) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ServiceDetailTypewidget(
                  serviceTypeId: item.id!,
                )),
      );
    },
    child:
        // Text(
        //   item.id.toString(),
        //   style: infoListStyle,
        // ),
        Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            // Expanded(
            //   // flex: 1,
            //   child: Text(
            //     (index + 1).toString(),
            //     style: serialStyle,
            //   ),
            // ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.id.toString(),
                    style: infoListStyle,
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

Widget ListServiceforBranch(List<int?> uniqueTypes, List<Service> list) {
  return ListView.builder(
    padding: const EdgeInsets.symmetric(vertical: 5),
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: uniqueTypes.length,
    itemBuilder: (context, typeIndex) {
      var serviceTypeId = uniqueTypes[typeIndex];
      var servicesOfType =
          list.where((service) => service.type == serviceTypeId).toList();

      // Kiểm tra nếu serviceTypeId là null
      if (serviceTypeId == null) {
        return const Text('Service type ID is null');
      }

      return FutureBuilder<ServiceType?>(
        future: ReadDataServiceType().loadTypeById(serviceTypeId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Text('No data available');
          }

          var serviceType = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(serviceType.name ?? 'Unknown', style: subtitleStyle17),
              ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 5),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: servicesOfType.length,
                itemBuilder: (context, index) {
                  return itemServiceBranch(servicesOfType[index], context);
                },
              ),
            ],
          );
        },
      );
    },
  );
}
