import 'package:booking_haircut_application/config/const.dart';
import 'package:booking_haircut_application/config/custom_input.dart';
import 'package:booking_haircut_application/data/api/sqlite.dart';
import 'package:booking_haircut_application/data/model/customermodel.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class RepassCuswidget extends StatefulWidget {
  final Customer customer;

  const RepassCuswidget({Key? key, required this.customer}) : super(key: key);

  @override
  State<RepassCuswidget> createState() => _DoiMatKhauState();
}

class _DoiMatKhauState extends State<RepassCuswidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _newPasswordError;
  String? _renewPasswordError;
  String? _oldPasswordError;
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _renewPasswordController =
      TextEditingController();

  final DatabaseHelper _databaseCustomer = DatabaseHelper();

  Future<void> _onUpdate() async {
    final _oldPass = _oldPasswordController.text;
    final _newPass = _newPasswordController.text;
    final _reNewPass = _renewPasswordController.text;

    // Validate the old password
    final currentCustomer = widget.customer;
    if (currentCustomer.password != _oldPass) {
      setState(() {
        _oldPasswordError = 'Mật khẩu cũ không đúng';
      });
      return;
    }

    // Check if new passwords match
    if (_newPass != _reNewPass) {
      setState(() {
        _newPasswordError = 'Mật khẩu mới không trùng khớp';
        _renewPasswordError = 'Mật khẩu mới không trùng khớp';
      });
      return;
    }

    // Check if new password is different from old password
    if (_oldPass == _newPass) {
      setState(() {
        _newPasswordError = 'Mật khẩu mới phải khác mật khẩu cũ';
        _renewPasswordError = 'Mật khẩu mới phải khác mật khẩu cũ';
      });
      return;
    }

    // Update the password
    final updatedPass = Customer(
      id: widget.customer.id,
      password: _newPass,
    );

    await _databaseCustomer.updatePassword(updatedPass);

    Navigator.pop(context, updatedPass);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Thay đổi mật khẩu thành công')),
    );
  }

  void _validateAndSubmit() {
    if (_formKey.currentState!.validate()) {
      _onUpdate();
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Current password: ${widget.customer.password}');
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(urlBackground),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 45, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BackButton(
                    color: branchColor,
                    style: ButtonStyle(alignment: Alignment.topLeft),
                  ),
                  Center(
                    child: const Text("Đổi mật khẩu", style: headingStyle),
                  ),
                  const SizedBox(height: 7),
                  const Row(
                    children: [
                      SizedBox(width: 55),
                      Expanded(
                        child: Divider(
                          color: Colors.black,
                          thickness: 1,
                        ),
                      ),
                      SizedBox(width: 55)
                    ],
                  ),
                  const SizedBox(height: 15),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        buildPasswordInput("Nhập mật khẩu cũ",
                            _oldPasswordController, _oldPasswordError),
                        const SizedBox(height: 15),
                        buildPasswordInput("Nhập mật khẩu mới",
                            _newPasswordController, _newPasswordError),
                        const SizedBox(height: 15),
                        buildPasswordInput("Nhập lại mật khẩu mới",
                            _renewPasswordController, _renewPasswordError),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: branchColor,
                            foregroundColor: Colors.white,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(10),
                          ),
                          onPressed: _validateAndSubmit,
                          child: const Text(
                            "Đổi mật khẩu",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPasswordInput(String label,
      [TextEditingController? controller, String? error]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 2,
                  offset: Offset(1, 1),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 2),
        TextFormField(
          controller: controller,
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Vui lòng nhập mật khẩu';
            }
            return null;
          },
          onChanged: (value) {
            setState(() {
              _newPasswordError = null;
              _renewPasswordError = null;
              _oldPasswordError = null;
            });
          },
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            border: myOutlineInputBorder1(),
            enabledBorder: myOutlineInputBorder1(),
            focusedBorder: myOutlineInputBorder3(),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            labelStyle: const TextStyle(
              fontStyle: FontStyle.italic,
              fontFamily: 'Inter',
            ),
            filled: true,
            fillColor: Colors.white,
            errorText: error,
          ),
        ),
      ],
    );
  }
}
