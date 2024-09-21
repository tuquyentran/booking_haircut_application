import 'package:booking_haircut_application/data/model/servicetypemodel.dart';
import 'package:flutter/material.dart';

import '../../../config/const.dart';
import '../../../data/api/sqlite.dart';

class ServiceAddTypewidget extends StatefulWidget {
  const ServiceAddTypewidget({super.key});

  @override
  State<ServiceAddTypewidget> createState() => _ServiceAddTypewidgetState();
}

class _ServiceAddTypewidgetState extends State<ServiceAddTypewidget> {
  final TextEditingController _nameTypeController = TextEditingController();

  final DatabaseHelper _databaseService = DatabaseHelper();
  Future<void> _onSave() async {
    final name = _nameTypeController.text;

    await _databaseService.insertServicetypeAdmin(ServiceType(name: name));

    setState(() {});

    Navigator.pop(context);
  }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   if (widget.serviceTypeModel != null && widget.isUpdate) {
  //     _nameTypeController.text = widget.serviceTypeModel!.name!;
  //   }
  //   if (widget.isUpdate) {
  //     titleText = "Chỉnh sửa loại dịch vụ";
  //   } else
  //     titleText = ;
  // }

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
                          flex: 6,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Thêm loại dịch vụ",
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

                    //NOI DUNG
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          const Expanded(
                            flex: 2,
                            child: Text(
                              "Tên loại dịch vụ:",
                              style: subtitleDetailStyle,
                            ),
                          ),
                          Expanded(
                            flex: 3,
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
                  ],
                ),
              ),
            ),
          ),
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
                        _onSave();
                      },
                      style: buttonForServiceStyle(),
                      child: const Text(
                        "Thêm loại dịch vụ",
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
