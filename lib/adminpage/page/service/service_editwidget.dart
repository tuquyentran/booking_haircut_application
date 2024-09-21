import 'package:booking_haircut_application/config/dropdownAD.dart';
import 'package:booking_haircut_application/data/model/servicetypemodel.dart';
import 'package:booking_haircut_application/data/provider/serviceprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../config/const.dart';
import '../../../data/api/sqlite.dart';
import '../../../data/model/servicemodel.dart';

class ServiceEditwidget extends StatefulWidget {
  final Service service;
  final ValueChanged<Service> onServiceUpdated;
  const ServiceEditwidget({
    Key? key,
    required this.service,
    required this.onServiceUpdated,
  }) : super(key: key);

  @override
  State<ServiceEditwidget> createState() => _ServiceEditwidgetState();
}

class _ServiceEditwidgetState extends State<ServiceEditwidget> {
  TextEditingController _namServiceController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  int? _selectedTypeId;

  final DatabaseHelper _databaseService = DatabaseHelper();
  List<ServiceType> _servicetypes = [];

  Future<void> _fetchServicetypes() async {
    _servicetypes = await _databaseService.listservicetypes();
    setState(() {});
  }

  Future<void> _onUpdate() async {
    final name = _namServiceController.text;
    final time = int.tryParse(_timeController.text) ?? 0;
    final price = double.tryParse(_priceController.text) ?? 0;
    Service updatedService = Service(
      id: widget.service.id,
      name: name,
      type: _selectedTypeId ?? widget.service!.type,
      time: time,
      price: price,
    );
    await _databaseService.updateServiceAdmin(updatedService);
    widget.onServiceUpdated(updatedService);
    Navigator.pop(context);
    setState(() {});
    // Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _fetchServicetypes();
    _namServiceController.text = widget.service.name ?? '';
    _timeController.text = widget.service.time.toString() ?? '0';
    _priceController.text = widget.service.price.toString() ?? '0';
    _selectedTypeId = widget.service.type!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(color: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: BackButton(
                              color: branchColor,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Chỉnh sửa dịch vụ",
                              style: headingStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 250,
                        child: Divider(
                          color: branchColor,
                          height: 10,
                          thickness: 2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Row(
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "Tên dịch vụ:",
                              style: subtitleDetailStyle,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              // maxLines: 2,
                              // textAlign: TextAlign.right,
                              controller: _namServiceController,
                              style: infoDetailStyle,
                              decoration: inputAdminStyle(hintText: 'Combo'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "Loại dịch vụ:",
                              style: subtitleDetailStyle,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: DropdownButtonFormField<int>(
                              icon: const Icon(Icons.keyboard_arrow_down),
                              dropdownColor: Colors.white,
                              style: infoDetailStyle,
                              value: _selectedTypeId,
                              items: _servicetypes.map((servicetype) {
                                return DropdownMenuItem<int>(
                                  value: servicetype.id,
                                  child: Text(
                                    servicetype.name!,
                                    style: infoDetailStyle,
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedTypeId = value;
                                });
                              },
                              decoration: inputAdminStyleAdd(
                                  hintText: 'Chọn loại dịch vụ'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "Thời gian dự kiến:",
                              style: subtitleDetailStyle,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _timeController,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter
                                    .digitsOnly // Chỉ cho phép nhập số
                              ],
                              style: infoDetailStyle,
                              decoration: inputAdminStyle(
                                  hintText: 'Nhập thời gian dự kiến(phút)....'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "Giá gốc:",
                              style: subtitleDetailStyle,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _priceController,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter
                                    .digitsOnly // Chỉ cho phép nhập số
                              ],
                              style: infoDetailStyle,
                              decoration:
                                  inputAdminStyle(hintText: 'Nhập giá gốc....'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    //Thông tin dịch vụ ban đầu
                    const Text(
                      "Thông tin dịch vụ ban đầu",
                      style: headingStyle,
                    ),
                    const Divider(
                      color: branchColor,
                      height: 10,
                      thickness: 2,
                    ),
                    const SizedBox(height: 10),
                    //NOI DUNG Thông tin dịch vụ ban đầu
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Expanded(
                            child: Text(
                              "Mã dịch vụ:",
                              style: subtitleDetailStyle,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Text(
                              widget.service.id.toString(),
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

                    //
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                            child: FutureBuilder<String>(
                              future: DatabaseHelper()
                                  .getServicetypeName(widget.service.type!),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Text('Loading...');
                                } else if (snapshot.hasError) {
                                  return const Text('Error');
                                } else {
                                  return Text(
                                    snapshot.data ?? '',
                                    style: infoDetailStyle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right,
                                  );
                                }
                              },
                            ),
                            // Text(
                            //   widget.service.type.toString(),
                            //   style: infoDetailStyle,
                            //   maxLines: 2,
                            //   overflow: TextOverflow.ellipsis,
                            //   textAlign: TextAlign.right,
                            // ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),

                    //
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Expanded(
                            child: Text(
                              "Thời gian dự kiến:",
                              style: subtitleDetailStyle,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Text(
                              NumberFormat('###,###,###')
                                  .format(widget.service.time),
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

                    //
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Expanded(
                            child: Text(
                              "Giá gốc:",
                              style: subtitleDetailStyle,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Text(
                              NumberFormat('###,###,###')
                                  .format(widget.service.price),
                              style: infoDetailStyle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 230),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  _onUpdate();
                                },
                                style: buttonForServiceStyle(),
                                child: const Text(
                                  'Thay đổi',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          //BUTTON
        ],
      ),
    );
  }
  // Future<void> updateServiceData(ServiceType servicetype) async {
  //   final String dataPath = "assets/jsonfiles/employeelist.json";
  //   final data = await rootBundle.loadString(dataPath);
  //   List<dynamic> jsonData = json.decode(data)['employee'];
  //   int index = jsonData.indexWhere((emp) => emp['id'] == employee.id);
  //   if (index != -1) {
  //     jsonData[index] = employee.toJson();
  //     Map<String, dynamic> updatedData = {'employee': jsonData};
  //     await rootBundle
  //         .loadString(dataPath)
  //         .then((value) => updatedData.toString());
  //   }
  // }
}
