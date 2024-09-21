import 'dart:io';
import 'dart:ui';

import 'package:booking_haircut_application/config/const.dart';
import 'package:image_picker/image_picker.dart';
import 'package:booking_haircut_application/data/model/customermodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomerEditwidget extends StatefulWidget {
  final Customer customer;
  const CustomerEditwidget({super.key, required this.customer});
  @override
  State<CustomerEditwidget> createState() => _CustomerEditwidgetState();
}

class _CustomerEditwidgetState extends State<CustomerEditwidget> {
  late final _fullName = TextEditingController();
  late final _dob = TextEditingController();
  late final _phone = TextEditingController();
  late final _email = TextEditingController();
  late final _pass = TextEditingController();

  @override
  void dispose() {
    _fullName.dispose();
    _dob.dispose();
    _phone.dispose();
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

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
  void initState() {
    super.initState();
    // Initialize the text controllers with the selected branch data
    _fullName.text = widget.customer.name ?? '';
    _phone.text = widget.customer.phone ?? '';
    _email.text = widget.customer.email ?? '';
    _pass.text = widget.customer.password ?? '';

    _imagePath = widget.customer.image;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Chỉnh sửa khách hàng', style: headingStyle),
        backgroundColor: Colors.white,
      ),
      body: Stack(children: [
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: SafeArea(
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                  Container(
                      alignment: Alignment.center,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildCustomerImage(),
                            const SizedBox(height: 20),
                            _buildRow('Tên khách hàng', _fullName,
                                widget.customer.name ?? ''),
                            _buildRow('Số điện thoại', _phone,
                                widget.customer.phone ?? ''),
                            _buildRow(
                                'Email', _email, widget.customer.email ?? ''),
                            _buildRow('Mật khẩu', _pass,
                                widget.customer.password ?? ''),
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
                      String updatedFullname = _fullName.text;
                      String updatedDob = _dob.text;
                      String updatedPhone = _phone.text;
                      String updatedEmail = _email.text;
                      String updatedPass = _pass.text;

                      if (updatedFullname.isNotEmpty &&
                          updatedDob.isNotEmpty &&
                          updatedPhone.isNotEmpty &&
                          updatedEmail.isNotEmpty &&
                          updatedPass.isNotEmpty) {
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
      ]));

  Widget _buildCustomerImage() {
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
                        image: AssetImage('assets/images/avatar.jpg'),
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
}
