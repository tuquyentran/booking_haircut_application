import 'dart:io';

import 'package:booking_haircut_application/config/const.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BranchAddWidget extends StatefulWidget {
  const BranchAddWidget({Key? key}) : super(key: key);

  @override
  State<BranchAddWidget> createState() => _BranchAddWidgetState();
}

class _BranchAddWidgetState extends State<BranchAddWidget> {
  final _fullName = TextEditingController();
  final _name = TextEditingController();
  final _address = TextEditingController();
  final List<String> type = [
    'Chi nhánh chính',
    'Chi nhánh phụ',
  ];
  String? selectedValue;

  @override
  void dispose() {
    _fullName.dispose();
    _name.dispose();
    _address.dispose();
    super.dispose();
  }

  File? _image;
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Thêm chi nhánh', style: headingStyle),
        backgroundColor: Colors.white,
      ),
      body: Stack(children: [
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: SafeArea(
                child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                  Container(
                      alignment: Alignment.center,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                _pickImage(ImageSource.gallery);
                              },
                              child: Container(
                                width: double.infinity,
                                height: 170,
                                decoration: BoxDecoration(
                                    color: branchColor20,
                                    border: Border.all(
                                        color: branchColor, width: 1),
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: branchColor.withOpacity(0.5),
                                        blurRadius: 4,
                                        offset: const Offset(0,
                                            4), // Set the shadow offset to create a bottom shadow
                                      ),
                                    ]),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: _image == null
                                        ? Container(
                                            alignment: Alignment.center,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFBABABA),
                                            ),
                                            child: const Icon(
                                              Icons.add_a_photo_outlined,
                                              size: 30,
                                            ),
                                          )
                                        : Image.file(
                                            _image!,
                                            fit: BoxFit.cover,
                                          )),
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildRow('Tên chi nhánh', _fullName,
                                'Nhập tên chi nhánh'),
                            _buildRow('Tên rút gọn', _name, 'Nhập tên rút gọn'),
                            _buildRow('Địa chỉ', _address, 'Nhập địa chỉ'),
                            Row(
                              children: [
                                const Text('Loại chi nhánh',
                                    style: subtitleDetailStyle),
                                const SizedBox(width: 40),
                                Expanded(
                                  child: DropdownButton(
                                    dropdownColor: Colors.white,
                                    isExpanded: true,
                                    hint: const Text('Chọn loại chi nhánh',
                                        style: hintText),
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    items: type.map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: infoListStyle,
                                        ),
                                      );
                                    }).toList(),
                                    value: selectedValue,
                                    onChanged: (String? value) {
                                      setState(() {
                                        selectedValue = value;
                                      });
                                    },
                                  ),
                                )
                              ],
                            ),
                          ]))
                ])))),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final String fullname = _fullName.text;
                      final String name = _name.text;
                      final String address = _address.text;

                      if (fullname.isNotEmpty &&
                          name.isNotEmpty &&
                          address.isNotEmpty) {
                        Navigator.pop(context);
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Lỗi'),
                            content:
                                const Text('Vui lòng điền đầy đủ thông tin.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Đóng'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    style: buttonForServiceStyle(),
                    child: const Text(
                      'Thêm chi nhánh',
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
      ]));
}

Widget _buildRow(
  String label,
  TextEditingController controller,
  String hint,
) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 120,
              child: Text(
                label,
                style: subtitleDetailStyle,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: controller,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: hintText,
                  enabledBorder: const UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromRGBO(202, 202, 204, 100)),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
