import 'package:booking_haircut_application/config/const.dart';
import 'package:booking_haircut_application/data/model/servicetypemodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../config/dropdownAD.dart';
import '../../../data/api/sqlite.dart';
import '../../../data/model/servicemodel.dart';
import '../../../data/provider/serviceprovider.dart';

class ServiceAddwidget extends StatefulWidget {
  const ServiceAddwidget({super.key});

  @override
  State<ServiceAddwidget> createState() => _ServiceAddwidgetState();
}

class _ServiceAddwidgetState extends State<ServiceAddwidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  // String? _selectServiceType;
  int? _selectedTypeId;

  final DatabaseHelper _databaseService = DatabaseHelper();
  List<ServiceType> _servicetypes = [];

  Future<void> _fetchServicetypes() async {
    _servicetypes = await _databaseService.listservicetypes();
    setState(() {});
  }

  Future<void> _onSave() async {
    final name = _nameController.text;
    final time = int.tryParse(_timeController.text) ?? 0;
    final price = double.tryParse(_priceController.text) ?? 0;

    await _databaseService.insertServiceAdmin(Service(
      name: name,
      time: time,
      price: price,
      type: _selectedTypeId,
    ));

    setState(() {});
    Navigator.pop(context);
  }
  // Future<void> _loadServiceTypes() async {
  //   // Gọi phương thức loadBranches từ ReadDataEmployee
  //   List<String> loadedServiceTypes = await ReadDataService.loadServiceTypes();

  //   // Cập nhật danh sách chi nhánh vào state của widget
  //   setState(() {
  //     servicetypes = loadedServiceTypes;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    _fetchServicetypes();
    // _loadServiceTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.white),
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
                          flex: 5,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Thêm dịch vụ",
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
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                  controller: _nameController,
                                  style: infoDetailStyle,
                                  decoration:
                                      inputAdminStyle(hintText: 'Combo'))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
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
                        //crossAxisAlignment: CrossAxisAlignment.start,
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
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _onSave();
                      },
                      style: buttonForServiceStyle(),
                      child: const Text(
                        'Thêm dịch vụ',
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
    );
  }
}
