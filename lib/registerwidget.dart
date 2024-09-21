import 'dart:ui';
import 'package:booking_haircut_application/adminpage/AD_main_page.dart';
import 'package:booking_haircut_application/cashierpage/mainpage.dart';
import 'package:booking_haircut_application/clientpage/MainPageCus.dart';
import 'package:booking_haircut_application/config/const.dart';
import 'package:booking_haircut_application/config/custom_input.dart';
import 'package:booking_haircut_application/data/api/sqlite.dart';
import 'package:booking_haircut_application/data/model/customermodel.dart';
import 'package:booking_haircut_application/loginwidget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterWidget extends StatefulWidget {
  const RegisterWidget({Key? key}) : super(key: key);

  @override
  State<RegisterWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<RegisterWidget> {
  bool _checkvalue_1 = false;

  static const Color _selectedColor = branchColor;
  static const Color _unSelectedColor = branchColor80;

  Color _emailTFColor = _unSelectedColor;
  Color _passwordColor = _unSelectedColor;
  Color _nameColor = _unSelectedColor;
  Color _phoneColor = _unSelectedColor;
  Color _repassColor = _unSelectedColor;

  final FocusNode _emailTFFocusNode = FocusNode();
  final FocusNode _passwordTFFocusNode = FocusNode();
  final FocusNode _nameTFFocusNode = FocusNode();
  final FocusNode _repasswordTFFocusNode = FocusNode();
  final FocusNode _phoneTFFocusNode = FocusNode();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _repasswordController = TextEditingController();
  String? _passwordError;
  String? _emailError;
  String? _phoneError;
  String? _nameError;
  String? _repasswordError;

  final DatabaseHelper _databaseCustomer = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _emailTFFocusNode.addListener(_onEmailTFFocusChange);
    _passwordTFFocusNode.addListener(_onPasswordTFFocusChange);
    _nameTFFocusNode.addListener(_onNameTFFocusChange);
    _phoneTFFocusNode.addListener(_onPhoneTFFocusChange);
    _repasswordTFFocusNode.addListener(_onRePasswordTFFocusChange);
  }

  Future<void> _register() async {
    final _name = _nameController.text;
    final _email = _emailController.text;
    final _password = _passwordController.text;
    final _phone = _phoneController.text;

    if (_formKey.currentState!.validate()) {
      if (!_checkvalue_1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Vui lòng đồng ý với điều khoản của chúng tôi.')),
        );
        return;
      }

      _formKey.currentState!.save();

      try {
        // Insert the customer into the database
        await _databaseCustomer.insertCustomer(Customer(
          name: _name,
          password: _password,
          phone: _phone,
          email: _email,
        ));

        // Save login details into SharedPreferences

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng ký thành công!')),
        );

        // Navigate to the login screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginWidget()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng ký thất bại!')),
        );
        print('Error during registration: $e'); // Log the error
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng kiểm tra các trường nhập liệu.')),
      );
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailTFFocusNode.removeListener(_onEmailTFFocusChange);
    _passwordTFFocusNode.removeListener(_onPasswordTFFocusChange);
    _nameTFFocusNode.removeListener(_onNameTFFocusChange);
    _phoneTFFocusNode.removeListener(_onPhoneTFFocusChange);
    _repasswordTFFocusNode.removeListener(_onRePasswordTFFocusChange);

    _emailTFFocusNode.dispose();
    _passwordTFFocusNode.dispose();
    _nameTFFocusNode.dispose();
    _phoneTFFocusNode.dispose();
    _repasswordTFFocusNode.dispose();

    super.dispose();
  }

  void _onEmailTFFocusChange() {
    setState(() {
      _emailTFFocusNode.hasFocus
          ? _emailTFColor = _selectedColor
          : _emailTFColor = _unSelectedColor;
    });
  }

  void _onPasswordTFFocusChange() {
    setState(() {
      _passwordTFFocusNode.hasFocus
          ? _passwordColor = _selectedColor
          : _passwordColor = _unSelectedColor;
    });
  }

  void _onNameTFFocusChange() {
    setState(() {
      _nameTFFocusNode.hasFocus
          ? _nameColor = _selectedColor
          : _nameColor = _unSelectedColor;
    });
  }

  void _onRePasswordTFFocusChange() {
    setState(() {
      _repasswordTFFocusNode.hasFocus
          ? _repassColor = _selectedColor
          : _repassColor = _unSelectedColor;
    });
  }

  void _onPhoneTFFocusChange() {
    setState(() {
      _phoneTFFocusNode.hasFocus
          ? _phoneColor = _selectedColor
          : _phoneColor = _unSelectedColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    BoxDecoration _buildShadowDecoration(Color borderColor) {
      return BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset:
                const Offset(0, 3), // Điều chỉnh vị trí đổ bóng theo yêu cầu
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: Center(
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(urlBackground),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    'Tạo tài khoản',
                                    textAlign: TextAlign.left,
                                    style: textStyle45,
                                  ),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                const SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    'Rất vui khi gặp lại bạn. Hãy đăng nhập để có thể sử dụng ứng dụng nhé!',
                                    textAlign: TextAlign.left,
                                    style: subtitleStyle16,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: _nameController,
                                        style: const TextStyle(fontSize: 16),
                                        obscureText: false,
                                        focusNode: _nameTFFocusNode,
                                        decoration: InputDecoration(
                                          labelText: "Họ và tên...",
                                          prefixIcon: const Icon(Icons.person),
                                          iconColor: branchColor,
                                          labelStyle: TextStyle(
                                            color: _nameColor,
                                            fontSize: 16,
                                          ),
                                          border: myOutlineInputBorder3(),
                                          focusedBorder:
                                              myOutlineInputBorder3(),
                                          enabledBorder:
                                              myOutlineInputBorder3(),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 12, vertical: 14),
                                          filled: true,
                                          fillColor: Colors.white,
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Vui lòng nhập họ tên';
                                          }

                                          return null;
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            _nameError = null;
                                          });
                                        },
                                      ),
                                      if (_nameError != null)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Text(
                                            _nameError!,
                                            style: errorInput,
                                          ),
                                        ),
                                      const SizedBox(height: 20),
                                      TextFormField(
                                        controller: _emailController,
                                        style: const TextStyle(fontSize: 16),
                                        obscureText: false,
                                        focusNode: _emailTFFocusNode,
                                        decoration: InputDecoration(
                                          labelText: "Email...",
                                          prefixIcon: const Icon(Icons.email),
                                          iconColor: branchColor,
                                          labelStyle: TextStyle(
                                            color: _emailTFColor,
                                            fontSize: 16,
                                          ),
                                          border: myOutlineInputBorder3(),
                                          focusedBorder:
                                              myOutlineInputBorder3(),
                                          enabledBorder:
                                              myOutlineInputBorder3(),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 12, vertical: 14),
                                          filled: true,
                                          fillColor: Colors.white,
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Vui lòng nhập email';
                                          }

                                          return null;
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            _emailError = null;
                                          });
                                        },
                                      ),
                                      if (_emailError != null)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Text(
                                            _emailError!,
                                            style: errorInput,
                                          ),
                                        ),
                                      const SizedBox(height: 20),
                                      TextFormField(
                                        keyboardType: TextInputType.phone,
                                        maxLength: 10,
                                        controller: _phoneController,
                                        style: const TextStyle(fontSize: 16),
                                        obscureText: false,
                                        focusNode: _phoneTFFocusNode,
                                        decoration: InputDecoration(
                                          labelText: "Số điện thoại...",
                                          prefixIcon: const Icon(Icons.phone),
                                          iconColor: branchColor,
                                          labelStyle: TextStyle(
                                            color: _phoneColor,
                                            fontSize: 16,
                                          ),
                                          border: myOutlineInputBorder3(),
                                          focusedBorder:
                                              myOutlineInputBorder3(),
                                          enabledBorder:
                                              myOutlineInputBorder3(),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 12, vertical: 14),
                                          filled: true,
                                          fillColor: Colors.white,
                                          counterText: '',
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Vui lòng nhập số điện thoại';
                                          }

                                          return null;
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            _phoneError = null;
                                          });
                                        },
                                      ),
                                      if (_phoneError != null)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Text(
                                            _phoneError!,
                                            style: errorInput,
                                          ),
                                        ),
                                      const SizedBox(height: 20),
                                      TextFormField(
                                        controller: _passwordController,
                                        style: const TextStyle(fontSize: 16),
                                        obscureText:
                                            true, // Để ẩn ký tự mật khẩu
                                        focusNode: _passwordTFFocusNode,
                                        decoration: InputDecoration(
                                          labelText: "Mật khẩu...",
                                          prefixIcon: const Icon(Icons.lock),
                                          iconColor: branchColor,
                                          labelStyle: TextStyle(
                                            color: _passwordColor,
                                            fontSize: 16,
                                          ),
                                          border: myOutlineInputBorder3(),
                                          focusedBorder:
                                              myOutlineInputBorder3(),
                                          enabledBorder:
                                              myOutlineInputBorder3(),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 12, vertical: 14),
                                          filled: true,
                                          fillColor: Colors.white,
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Vui lòng nhập mật khẩu';
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            _passwordError = null;
                                          });
                                        },
                                      ),
                                      if (_passwordError != null)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Text(
                                            _passwordError!,
                                            style: errorInput,
                                          ),
                                        ),
                                      const SizedBox(height: 20),
                                      TextFormField(
                                        controller: _repasswordController,
                                        style: const TextStyle(fontSize: 16),
                                        obscureText:
                                            true, // Để ẩn ký tự mật khẩu
                                        focusNode: _repasswordTFFocusNode,
                                        decoration: InputDecoration(
                                          labelText: "Nhập lại mật khẩu...",
                                          prefixIcon: const Icon(Icons.lock),
                                          iconColor: branchColor,
                                          labelStyle: TextStyle(
                                            color: _repassColor,
                                            fontSize: 16,
                                          ),
                                          border: myOutlineInputBorder3(),
                                          focusedBorder:
                                              myOutlineInputBorder3(),
                                          enabledBorder:
                                              myOutlineInputBorder3(),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 12, vertical: 14),
                                          filled: true,
                                          fillColor: Colors.white,
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Vui lòng nhập lại mật khẩu';
                                          }
                                          if (value !=
                                              _passwordController.text) {
                                            return 'Mật khẩu không trùng nhau';
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            _repasswordError = null;
                                          });
                                        },
                                      ),
                                      if (_repasswordError != null)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Text(
                                            _repasswordError!,
                                            style: errorInput,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          bottom:
                                              10), // Điều chỉnh khoảng cách giữa Checkbox và Button ở đây
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: _checkvalue_1,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                _checkvalue_1 = value!;
                                              });
                                            },
                                            activeColor: Colors
                                                .black, // Màu của checkbox khi được chọn
                                            checkColor: Colors
                                                .white, // Màu của dấu check khi được chọn
                                          ),
                                          const Expanded(
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Bạn đồng ý với ",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  'Điều khoản của chúng tôi',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _register();
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: branchColor,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          shadowColor:
                                              Colors.black.withOpacity(0.5),
                                          elevation: 8,
                                        ),
                                        child: const Text('Đăng ký',
                                            style: textButtonStyle17w),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Bạn đã có tài khoản?',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16, color: branchColor),
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Stack(
                                        alignment: Alignment.centerLeft,
                                        children: <Widget>[
                                          const Text(
                                            'Đăng nhập',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              // Xóa bỏ gạch chân mặc định
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            left: 0,
                                            right: 0,
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  top:
                                                      2), // Điều chỉnh khoảng cách ở đây
                                              height: 1,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
