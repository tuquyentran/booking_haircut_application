import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../../config/const.dart';
import '../../../config/list/servicetype_body.dart';
import '../../../data/api/sqlite.dart';
import '../../../data/model/branch_servicemodel.dart';
import '../../../data/model/selectedCashiermodel.dart';
import '../../../data/model/servicemodel.dart';
import '../../../data/model/servicetypemodel.dart';

class SelectWidget extends StatefulWidget {
  const SelectWidget({Key? key}) : super(key: key);

  @override
  State<SelectWidget> createState() => SelectWidgetState();
}

class SelectWidgetState extends State<SelectWidget> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<BranchService> list = [];
  List<ServiceType> listType = [];
  List<int?> uniqueTypes = [];
  List<Service> selectedServices = [];

  Future<Service?> _getService(int? id) async {
    return await _databaseHelper.getServiceById(id);
  }

  Future<List<int?>> getUnitype(List<BranchService> list) async {
    List<int?> lstType = [];
    for (var item in list) {
      var ser = await _getService(item.service);
      lstType.add(ser?.type);
    }
    // print("Số loại dịch vụ: ${lstType.length}");
    return lstType.toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    final selectedServicesProvider = Provider.of<SelectedCashierModel>(context);
    list = selectedServicesProvider.lstBranchSer;
    if (list.isEmpty) {
      print("Rỗng");
    } else {
      print("Services: ${list.length}");
    }

    // uniqueTypes =
    //     list.map((service) => service.getType()).toSet().cast<int?>().toList();
    // print(uniqueTypes);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.topCenter,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: BackButton(
                        color: branchColor,
                      ),
                    ),
                    const Text(
                      "Hãy chọn dịch vụ bạn muốn",
                      style: heading3Style,
                    ),
                    const Divider(
                      color: branchColor,
                      height: 10,
                      thickness: 2,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    FutureBuilder(
                        future: getUnitype(list),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            uniqueTypes = snapshot.data!;
                            return list.isEmpty
                                ? const Text(
                                    'Không có dịch vụ nào!',
                                    style: nullStyle,
                                  )
                                : ListViewServiceCashier(uniqueTypes, list);
                          }
                        }),
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
