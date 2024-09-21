import 'package:flutter/material.dart';

import '../../../config/const.dart';
import '../../../data/api/sqlite.dart';
import '../../../data/model/servicetypemodel.dart';

class ServiceEditTypewidget extends StatefulWidget {
  final ServiceType? serviceTypeModel;
  final ValueChanged<ServiceType> onServiceTypeUpdated;
  const ServiceEditTypewidget({
    super.key,
    required this.serviceTypeModel,
    required this.onServiceTypeUpdated,
  });

  @override
  State<ServiceEditTypewidget> createState() => _ServiceEditTypewidgetState();
}

class _ServiceEditTypewidgetState extends State<ServiceEditTypewidget> {
  final TextEditingController _nameTypeController = TextEditingController();

  final DatabaseHelper _databaseService = DatabaseHelper();

  Future<void> _onUpdate() async {
    ServiceType updatedServiceType = ServiceType(
      id: widget.serviceTypeModel!.id,
      name: _nameTypeController.text,
    );
    await _databaseService.updateServicetypeAdmin(updatedServiceType);

    // Pass updated employee back to the previous screen
    widget.onServiceTypeUpdated(updatedServiceType);
    Navigator.pop(context);
    setState(() {});
    // if (mounted) {
    //   Navigator.of(context).pop();
    // }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _nameTypeController.text = widget.serviceTypeModel!.name!;
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
                          flex: 8,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Chỉnh sửa loại dịch vụ",
                              style: headingStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      color: branchColor,
                      height: 10,
                      thickness: 2,
                    ),
                    const SizedBox(height: 15),

                    //NOI DUNG
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          const Expanded(
                            child: Text(
                              "Tên loại dịch vụ:",
                              style: subtitleDetailStyle,
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _nameTypeController,
                              style: infoDetailStyle,
                              decoration: inputAdminStyle(
                                  hintText: 'Nhập tên loại dịch vụ...'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 600),

//BUTTON
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
                                  setState(() {});
                                },
                                style: buttonForServiceStyle(),
                                child: const Text(
                                  "Chỉnh sửa loại dịch vụ",
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
                    //SizedBox(height: 600),
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
