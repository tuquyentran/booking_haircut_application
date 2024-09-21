import 'dart:io';
import 'dart:ui';

import 'package:booking_haircut_application/config/const.dart';
import 'package:booking_haircut_application/data/model/branchmodel.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BranchEditwidget extends StatefulWidget {
  final Branch branch;

  const BranchEditwidget({super.key, required this.branch});
  @override
  State<BranchEditwidget> createState() => _BranchEditwidgetState();
}

class _BranchEditwidgetState extends State<BranchEditwidget> {
  final _fullName = TextEditingController();
  final _name = TextEditingController();
  final _address = TextEditingController();
  final List<String> type = [
    'Chi nhánh chính',
    'Chi nhánh phụ',
  ];
  String? selectedValue;
  String? _imagePath;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  @override
  void dispose() {
    _fullName.dispose();
    _name.dispose();
    _address.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Initialize the text controllers with the selected branch data
    _fullName.text = widget.branch.name ?? '';
    _name.text = widget.branch.anothername ?? '';
    _address.text = widget.branch.address ?? '';

    // Set the initial selected value for the DropdownButton
    selectedValue =
        widget.branch.type == 1 ? 'Chi nhánh chính' : 'Chi nhánh phụ';
    _imagePath = widget.branch.image;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Chỉnh sửa chi nhánh', style: headingStyle),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: SafeArea(
              child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    const SizedBox(height: 16),
                    _buildBranchImage(),
                    const SizedBox(height: 20),
                    _buildRow(
                        'Tên chi nhánh', _fullName, widget.branch.name ?? ''),
                    _buildRow(
                        'Tên rút gọn', _name, widget.branch.anothername ?? ''),
                    _buildRow('Địa chỉ', _address, widget.branch.address ?? ''),
                    Row(
                      children: [
                        const Text('Loại chi nhánh',
                            style: subtitleDetailStyle),
                        const SizedBox(width: 40),
                        Expanded(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            hint: const Text('Chọn loại chi nhánh',
                                style: hintText),
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: type
                                .map<DropdownMenuItem<String>>((String value) {
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
                  ])),
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
                        String updatedFullName = _fullName.text;
                        String updatedName = _name.text;
                        String updatedAddress = _address.text;
                        int updatedType =
                            selectedValue == 'Chi nhánh chính' ? 1 : 0;

                        if (updatedFullName.isNotEmpty &&
                            updatedName.isNotEmpty &&
                            updatedAddress.isNotEmpty) {
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
      ));
  Widget _buildBranchImage() {
    return Center(
      child: InkWell(
        onTap: () {
          _pickImage(ImageSource.gallery);
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 170,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 4),
                  ),
                ],
                // Display the image from JSON data
                image: _imagePath != null
                    ? DecorationImage(
                        opacity: 0.7,
                        image: AssetImage('assets/images/shop/${_imagePath}'),
                        fit: BoxFit.cover,
                      )
                    : null, // No image if _imagePath is null
              ),
              // Blur effect
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                child: Container(
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            const Icon(
              Icons.add_a_photo_outlined,
              size: 40,
              color: branchColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(
    String label,
    TextEditingController controller,
    String hint,
  ) {
    return Column(
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
                    borderSide: BorderSide(color: branchColor20),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
