import 'dart:io';

import 'package:booking_haircut_application/config/const.dart';
import 'package:booking_haircut_application/data/model/customermodel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../../../data/api/sqlite.dart';

class CustomerAddwidget extends StatefulWidget {
  const CustomerAddwidget({super.key});
  @override
  State<CustomerAddwidget> createState() => _CustomerAddwidgetState();
}

class _CustomerAddwidgetState extends State<CustomerAddwidget> {
  final DatabaseHelper _database = DatabaseHelper();
  final _fullName = TextEditingController();
  final _dob = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  String? _imagePath;

  @override
  void dispose() {
    _fullName.dispose();
    _dob.dispose();
    _phone.dispose();
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      File file = File(image.path);

      // Lưu hình ảnh vào thư mục nội bộ của ứng dụng
      String newFileName = basename(file.path);
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      String assetDirPath = '$appDocPath/images';

      // Kiểm tra và tạo thư mục images nếu nó không tồn tại
      Directory assetDir = Directory(assetDirPath);
      if (!await assetDir.exists()) {
        await assetDir.create(recursive: true);
      }

      String newPath = '$assetDirPath/$newFileName';
      await file.copy(newPath);

      setState(() {
        _imagePath = newPath;
      });

      // Xác nhận rằng tệp đã được sao chép thành công
      print('Tệp đã được sao chép vào $newPath');
    }
  }

  Future<void> _onSave(BuildContext context) async {
    // if (_fullName.text.isEmpty ||
    //     _gender == null ||
    //     _phoneController.text.isEmpty ||
    //     _selectedRoleIndex == null ||
    //     _selectedStateIndex == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin.')),
    //   );
    //   return; // Ngừng thực hiện hàm nếu có lỗi
    // }
    await _database.insertCustomer(Customer(
      image: _imagePath ?? '',
      name: _fullName.text,
      phone: _phone.text,
      email: _email.text,
      password: _pass.text,
    ));

    setState(() {});
    Navigator.pop(context);
  }

  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dob.text = DateFormat('dd/MM/yyyy').format(_selectedDate!);
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Thêm khách hàng', style: headingStyle),
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
                              onTap: _pickImage,
                              child: Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color(0xFF000000), width: 1),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.4),
                                      spreadRadius: 0,
                                      blurRadius: 4,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: _imagePath == null
                                      ? Container(
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFBABABA),
                                          ),
                                          child: const Icon(
                                              Icons.add_a_photo_outlined),
                                        )
                                      : Image.file(
                                          File(_imagePath!),
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildRow('Tên khách hàng', _fullName,
                                'Nhập tên khách hàng'),
                            _buildRow('Ngày sinh', _dob, 'Chọn ngày sinh',
                                onTap: () {
                              _selectDate(context);
                            }),
                            _buildRow(
                                'Số điện thoại', _phone, 'Nhập số điện thoại'),
                            _buildRow('Email', _email, 'Nhập email'),
                            _buildRow('Mật khẩu', _pass, 'Nhập mật khẩu'),
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
                      _onSave(context);
                      // final String fullname = _fullName.text;
                      // final String dob = _dob.text;
                      // final String phone = _phone.text;
                      // final String email = _email.text;
                      // final String pass = _pass.text;

                      // if (fullname.isNotEmpty &&
                      //     dob.isNotEmpty &&
                      //     phone.isNotEmpty &&
                      //     email.isNotEmpty &&
                      //     pass.isNotEmpty) {
                      //   Navigator.pop(context);
                      // } else {
                      //   showDialog(
                      //     context: context,
                      //     builder: (context) => AlertDialog(
                      //       title: const Text('Lỗi'),
                      //       content:
                      //           const Text('Vui lòng điền đầy đủ thông tin.'),
                      //       actions: [
                      //         TextButton(
                      //           onPressed: () => Navigator.pop(context),
                      //           child: const Text('Đóng'),
                      //         ),
                      //       ],
                      //     ),
                      //   );
                      // }
                    },
                    style: buttonForServiceStyle(),
                    child: const Text(
                      'Thêm khách hàng',
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
  String hint, {
  VoidCallback? onTap,
}) =>
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
                  suffixIcon: onTap != null
                      ? IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: onTap,
                        )
                      : null,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
