import 'dart:io';
import 'dart:ui';
import 'package:booking_haircut_application/config/const.dart';
import 'package:booking_haircut_application/data/api/sqlite.dart';
import 'package:booking_haircut_application/data/model/customermodel.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChangeInfoCuswidget extends StatefulWidget {
  final Customer customer;

  const ChangeInfoCuswidget({Key? key, required this.customer})
      : super(key: key);

  @override
  State<ChangeInfoCuswidget> createState() => _ThayDoiTTState();
}

class _ThayDoiTTState extends State<ChangeInfoCuswidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final DatabaseHelper _databaseCustomer = DatabaseHelper();

  Future<void> _onUpdate() async {
    final _name = _nameController.text;
    final _email = _emailController.text;
    final _phone = _phoneController.text;

    // Tạo đối tượng Customer mới để cập nhật thông tin
    final updatedCustomer = Customer(
      id: widget.customer.id, // ID không thay đổi
      name: _name,
      phone: _phone,
      email: _email,
      // Chỉ cập nhật các trường cần thiết
    );

    // Gọi phương thức updateCustomer để thực hiện cập nhật
    await _databaseCustomer.updateCustomerEPN(updatedCustomer);

    // Cập nhật trạng thái của widget với thông tin mới
    setState(() {
      widget.customer.name = _name;
      widget.customer.phone = _phone;
      widget.customer.email = _email;
    });
    Navigator.pop(context, updatedCustomer);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Thay đổi thông tin thành công')),
    );
  }

  File? _image;
  final picker = ImagePicker();

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      print('không có ảnh nào.');
    }
  }

  @override
  void initState() {
    super.initState();

    _nameController.text = widget.customer.name ?? '';
    _emailController.text = widget.customer.email ?? '';
    _phoneController.text = widget.customer.phone ?? '';
  }

  void showImageSourceDialog() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (builder) => bottomSheet(),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          const Text("Chọn ảnh đại diện",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.camera_alt, color: branchColor),
                onPressed: () {
                  Navigator.pop(context);
                  getImage(ImageSource.camera);
                },
                label:
                    const Text('Camera', style: TextStyle(color: branchColor)),
              ),
              const SizedBox(width: 30),
              TextButton.icon(
                icon: const Icon(Icons.image, color: branchColor),
                onPressed: () {
                  Navigator.pop(context);
                  getImage(ImageSource.gallery);
                },
                label: const Text('Thư viện',
                    style: TextStyle(color: branchColor)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: Stack(fit: StackFit.expand, children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(urlBackground),
                fit: BoxFit.cover,
              ),
            ),
          ),
          LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 45, 16, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            BackButton(
                              color: branchColor,
                              style: ButtonStyle(alignment: Alignment.topLeft),
                            ),
                          ],
                        ),
                        const Text("Thay đổi thông tin người dùng",
                            style: headingStyle),
                        const SizedBox(height: 7),
                        const Row(
                          children: [
                            SizedBox(
                              width: 55,
                            ),
                            Expanded(
                                child: Divider(
                              color: Colors.black,
                              thickness: 1,
                            )),
                            SizedBox(
                              width: 55,
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: showImageSourceDialog,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                    Colors.black, // Vòng ngoài màu đen
                                radius:
                                    70, // Bán kính lớn hơn hình ảnh để tạo vòng ngoài
                                child: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 68,
                                  child: ClipOval(
                                    child: Stack(
                                      children: [
                                        // Hình ảnh mờ
                                        Positioned.fill(
                                          child: _image != null
                                              ? Image.file(_image!,
                                                  fit: BoxFit.cover)
                                              : Image.asset(
                                                  'assets/images/avatar.jpg',
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                        Positioned.fill(
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 0.5, sigmaY: 0.5),
                                            child: Container(
                                              color: branchColor20.withOpacity(
                                                  0.1), // Màu trong suốt
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // Icon đè lên hình ảnh
                              const Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 40,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              "Họ và tên",
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
                        ),
                        const SizedBox(height: 2),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: Offset(
                                      0, 2), // changes position of shadow
                                ),
                              ],
                              borderRadius: BorderRadius.circular(12)),
                          child: TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.person),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 2, color: Colors.black),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                labelStyle: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontFamily: 'Inter',
                                )),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              "Email",
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
                        ),
                        const SizedBox(height: 2),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: Offset(
                                      0, 2), // changes position of shadow
                                ),
                              ],
                              borderRadius: BorderRadius.circular(12)),
                          child: TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.mail),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 2, color: Colors.black),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                labelStyle: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontFamily: 'Inter',
                                )),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              "Số điện thoại",
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
                        ),
                        const SizedBox(height: 2),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: Offset(
                                      0, 2), // changes position of shadow
                                ),
                              ],
                              borderRadius: BorderRadius.circular(12)),
                          child: TextFormField(
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            controller: _phoneController,
                            decoration: InputDecoration(
                                counterText: '',
                                prefixIcon: const Icon(Icons.phone),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 2, color: Colors.black),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                labelStyle: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontFamily: 'Inter',
                                )),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
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
                                      borderRadius: BorderRadius.circular(8)),
                                  padding: EdgeInsets.all(10),
                                ),
                                onPressed: () {
                                  _onUpdate();
                                },
                                child: const Text(
                                  "Thay đổi",
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
                ),
              ),
            );
          }),
        ]),
      ),
    );
  }
}
