import 'dart:convert';
import 'dart:ui';
import 'package:booking_haircut_application/adminpage/page/statistical/statisticalwidget.dart';
import 'package:booking_haircut_application/cashierpage/mainpage.dart';

import 'package:booking_haircut_application/config/custom_input.dart';
import 'package:booking_haircut_application/data/api/sqlite.dart';
import 'package:booking_haircut_application/data/model/customermodel.dart';
import 'package:booking_haircut_application/data/model/employeemodel.dart';
import 'package:booking_haircut_application/data/provider/customerprovider.dart';
import 'package:booking_haircut_application/data/provider/employeeprovider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'adminpage/AD_main_page.dart';
import 'clientpage/MainPageCus.dart';
import 'data/api/sqlite.dart';
import 'registerwidget.dart';
import 'config/const.dart';
import 'package:flutter/material.dart';

import 'youtube.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginState();
}

class _LoginState extends State<LoginWidget> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  static Color _selectedColor = branchColor;
  static Color _unSelectedColor = branchColor80;
  String? _passwordError;
  String? _emailError;

  Color _emailTFColor = _unSelectedColor;
  Color _passwordColor = _unSelectedColor;

  final FocusNode _emailTFFocusNode = FocusNode();
  final FocusNode _passwordTFFocusNode = FocusNode();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<bool> saveUser(Customer customer) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String strUser = jsonEncode(customer);
      prefs.setString('customer', strUser);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _emailTFFocusNode.addListener(_onEmailTFFocusChange);
    _passwordTFFocusNode.addListener(_onPasswordTFFocusChange);
  }

  @override
  void dispose() {
    _emailTFFocusNode.removeListener(_onEmailTFFocusChange);
    _emailTFFocusNode.dispose();
    _passwordTFFocusNode.removeListener(_onPasswordTFFocusChange);
    _passwordTFFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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

  Future<bool> saveEmployee(Employee employee) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String strEmployee = jsonEncode(employee);
      prefs.setString('employee', strEmployee);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<Employee>> _getEmployees() async {
    return await _databaseHelper.getAllEmployee();
  }

  // Future<bool> saveCustomer(Customer customer) async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String strCustomer = jsonEncode(customer);
  //     prefs.setString('customer', strCustomer);
  //     return true;
  //   } catch (e) {
  //     print(e);
  //     return false;
  //   }
  // }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      // Get email and password from text controllers
      String email = _emailController.text;
      String password = _passwordController.text;

      List<Employee> employees = await _getEmployees();
      List<Customer> customers = await DatabaseHelper().getAllCustomers();

      // Validate customer credentials
      Customer? customer = customers.isNotEmpty
          ? customers.firstWhere(
              (c) =>
                  c.email == _emailController.text &&
                  c.password == _passwordController.text,
              orElse: () => Customer(id: -1))
          : Customer(id: -1);

      // Validate employee credentials
      Employee? employee = employees.isNotEmpty
          ? employees.firstWhere(
              (e) => e.email == email && e.phone == password && e.role == 1,
              orElse: () => Employee(id: -1))
          : Employee(id: -1);

      // Navigate based on user type
      if (customer.id != -1) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MainPageCus(
                    customer: customer,
                  )),
        );
      } else if (email == 'admin@123' && password == 'admin123') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ADMainPage()),
        );
      } else if (employee.id != -1) {
        if (await saveEmployee(employee) == true) {
          print(employee);
        }
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        );
      } else {
        setState(() {
          _passwordError = 'Email hoặc mật khẩu không chính xác';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: Stack(
          children: [
            Image.asset(
              'assets/images/backgroundlogin.png',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            Positioned(
              top: screenHeight / 4.5 - screenHeight / 7,
              left: (screenWidth - 250) / 2,
              child: Image.asset(
                'assets/images/logologinpage.png',
                width: 250, // Đặt chiều rộng của logo
                height: 250, // Đặt chiều cao của logo
                fit: BoxFit.cover,
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
                        padding: EdgeInsets.only(top: screenHeight / 2.55),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(28),
                              topRight: Radius.circular(28),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(25),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const SizedBox(
                                    width: double.infinity,
                                    child: Text(
                                      'Chào mừng bạn trở lại, ',
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
                                                myOutlineInputBorder1(),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 14),
                                            filled: true,
                                            fillColor: Colors.white,
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
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
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5, left: 5),
                                              child: Text(
                                                _emailError!,
                                                style: errorInput,
                                              ),
                                            ),
                                          ),
                                        const SizedBox(height: 15),
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
                                                myOutlineInputBorder1(),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 14),
                                            filled: true,
                                            fillColor: Colors.white,
                                          ),

                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
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
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5, left: 5),
                                              child: Text(
                                                _passwordError!,
                                                style: errorInput,
                                              ),
                                            ),
                                          ),
                                        const SizedBox(height: 0),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    RegisterWidget(),
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            'Bạn quên mật khẩu?',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          _login();
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
                                      child: const Text('Đăng nhập',
                                          style: textButtonStyle17w),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Bạn chưa có tài khoản?',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: branchColor,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const RegisterWidget(),
                                            ),
                                          );
                                        },
                                        child: Stack(
                                          alignment: Alignment.centerLeft,
                                          children: <Widget>[
                                            const Text(
                                              'Đăng ký',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 0,
                                              left: 0,
                                              right: 0,
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    top: 2),
                                                height: 1,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const Youtube(),
                                        ),
                                      );
                                    },
                                    child: Text("Hướng dẫn sử dụng"),
                                  )
                                ],
                              ),
                            ),
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
    );
  }
}
