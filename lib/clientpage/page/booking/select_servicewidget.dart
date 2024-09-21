import 'package:provider/provider.dart';

import '../../../config/list/service_body.dart';
import 'package:flutter/material.dart';
import '../../../config/const.dart';
import '../../../config/list/servicetype_body.dart';
import '../../../data/model/servicemodel.dart';
import 'package:intl/intl.dart';
import '../../../data/model/selectedCusmodel.dart';
import '../../../data/model/servicetypemodel.dart';

class SelectServiceCuswidget extends StatefulWidget {
  // final List<Service> lstService;
  const SelectServiceCuswidget({Key? key}) : super(key: key);

  @override
  State<SelectServiceCuswidget> createState() => SelectServiceCuswidgetState();
}

class SelectServiceCuswidgetState extends State<SelectServiceCuswidget> {
  List<Service> list = [];
  List<ServiceType> listType = [];
  List<int?> uniqueTypes = [];
  List<Service> selectedServices = [];

  @override
  Widget build(BuildContext context) {
    final selectedServicesProvider = Provider.of<SelectedCusModel>(context);
    list = selectedServicesProvider.lstBranchSer;
    uniqueTypes = list.map((service) => service.type).toSet().toList();
    print(uniqueTypes);

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
                    list.isEmpty
                        ? const Text(
                            'Không có dịch vụ nào!',
                            style: nullStyle,
                          )
                        : ListViewServiceCus(uniqueTypes, list),
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
