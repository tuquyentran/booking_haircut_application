import 'dart:convert';

import 'package:booking_haircut_application/adminpage/page/employee/employee_detailwidget.dart';
import 'package:booking_haircut_application/config/const.dart';
import 'package:booking_haircut_application/data/model/employeemodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../../../config/dropdownAD.dart';
import '../../../config/photo_view.dart';
import '../../../data/api/sqlite.dart';
import '../../../data/model/branchmodel.dart';
import '../../../data/provider/employeeprovider.dart';

class EmployeeEditwidget extends StatefulWidget {
  final Employee employee;
  final ValueChanged<Employee> onEmployeeUpdated;
  const EmployeeEditwidget({
    super.key,
    required this.employee,
    required this.onEmployeeUpdated, // Thêm dòng này
  });

  @override
  State<EmployeeEditwidget> createState() => _EmployeeEditwidgetState();
}

class _EmployeeEditwidgetState extends State<EmployeeEditwidget> {
  final DatabaseHelper _database = DatabaseHelper();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _nicknameController = TextEditingController();

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  int? _gender;

  int? _selectedBranch;
  List<Branch> _branchs = [];
  int? _selectedRoleIndex;
  int? _selectedStateIndex;
  String formattedDate = '';
  DateTime? _selectedDate;
  String? _imagePath;

  List<String> roles = [
    'Thợ tóc',
    'Thu ngân',
  ];
  List<String> states = ['Nghỉ việc', 'Đang làm việc'];
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
        _dobController.text = DateFormat('dd/MM/yyyy').format(_selectedDate!);
      });
    }
  }

  Future<void> _fetchBranchs() async {
    _branchs = await _database.lisBranchEmployee();
    setState(() {});
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

  Future<void> _onUpdate(BuildContext context) async {
    if (_nameController.text.isEmpty ||
        _gender == null ||
        _phoneController.text.isEmpty ||
        _selectedRoleIndex == null ||
        _selectedStateIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin.')),
      );
      return; // Ngừng thực hiện hàm nếu có lỗi
    }
    Employee updatedEmployee = Employee(
      id: widget.employee.id,
      image: _imagePath ?? '',
      name: _nameController.text,
      nickname: _nicknameController.text ?? '',
      gender: _gender,
      birthday: _dobController.text,
      phone: _phoneController.text,
      email: '',
      branch: _selectedBranch,
      role: _selectedRoleIndex,
      state: _selectedStateIndex,
    );

    await _database.updateEmployeeAdmin(updatedEmployee);

    // Pass updated employee back to the previous screen
    widget.onEmployeeUpdated(updatedEmployee);
    Navigator.pop(context);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // Khởi tạo các controller và giá trị mặc định từ dữ liệu hiện tại của nhân viên
    _nameController.text = widget.employee.name ?? '';
    _nicknameController.text = widget.employee.nickname ?? '';
    _imagePath = widget.employee.image ?? '';
    _phoneController.text = widget.employee.phone ?? '';
    _gender = widget.employee.gender; // Đặt giới tính hiện tại
    if (widget.employee.birthday != null) {
      _selectedDate = DateFormat('dd/MM/yyyy').parse(widget.employee.birthday!);
      _dobController.text = DateFormat('dd/MM/yyyy').format(_selectedDate!);
    } // Đặt ngày sinh hiện tại nếu có // Đặt ngày sinh hiện tại nếu có
    _selectedBranch = widget.employee.branch; // Đặt chi nhánh hiện tại
    _selectedRoleIndex = widget.employee.role;
    _selectedStateIndex = widget.employee.state;
    _fetchBranchs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: const Text(
      //     "Quản lý nhân viên",
      //     style: titleStyleAdmin,
      //   ),
      //   backgroundColor: branchColor,
      // ),
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
                    //CHINH SUA THONG TIN
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
                              "Chỉnh sửa thông tin",
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

                    //THEM ANH NHAN VIEN
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
                                child: _imagePath == ''
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

                          //NOI DUNG CHINH SUA THONG TIN.......................................
                          //TEN NHAN VIEN
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                const Expanded(
                                  flex: 1,
                                  child: Text(
                                    "Tên nhân viên:",
                                    style: subtitleDetailStyle,
                                  ),
                                ),
                                Expanded(
                                    flex: 2,
                                    child: TextFormField(
                                        controller: _nameController,
                                        style: infoDetailStyle,
                                        decoration: inputAdminStyle(
                                            hintText:
                                                'Nhập tên nhân viên...'))),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          //BIET DANH
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                const Expanded(
                                  flex: 1,
                                  child: Text(
                                    "Biệt danh:",
                                    style: subtitleDetailStyle,
                                  ),
                                ),
                                Expanded(
                                    flex: 2,
                                    child: TextFormField(
                                        controller: _nicknameController,
                                        style: infoDetailStyle,
                                        decoration: inputAdminStyle(
                                            hintText: 'Nhập biệt danh...'))),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          //GIOI TINH
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Row(
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                const Expanded(
                                  flex: 1,
                                  child: Text(
                                    "Giới tính:",
                                    style: subtitleDetailStyle,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Container(
                                      width: 200,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: ListTile(
                                              contentPadding:
                                                  const EdgeInsets.all(0),
                                              title: const Text(
                                                "Nam",
                                                style: subtitleStyle20b80,
                                              ),
                                              leading: Transform.translate(
                                                offset: const Offset(16, 0),
                                                child: Radio(
                                                  activeColor: Colors.black,
                                                  value: 0,
                                                  groupValue: _gender,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _gender = value!;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: ListTile(
                                              contentPadding:
                                                  const EdgeInsets.all(0),
                                              title: const Text(
                                                "Nữ",
                                                style: subtitleStyle20b80,
                                              ),
                                              leading: Transform.translate(
                                                offset: const Offset(16, 0),
                                                child: Radio(
                                                  activeColor: Colors.black,
                                                  value: 1,
                                                  groupValue: _gender,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _gender = value!;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          // //NGAY SINH
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Row(
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                const Expanded(
                                  flex: 1,
                                  child: Text(
                                    "Ngày sinh:",
                                    style: subtitleDetailStyle,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: InkWell(
                                    onTap: () => _selectDate(
                                        context), // Call _selectDate on tap
                                    child: InputDecorator(
                                      decoration: InputDecoration(
                                        enabledBorder:
                                            const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0x9C000000)),
                                        ),
                                        suffixIcon: IconButton(
                                          icon:
                                              const Icon(Icons.calendar_today),
                                          onPressed: () => _selectDate(
                                              context), // Also call on icon press
                                        ),
                                        contentPadding:
                                            const EdgeInsets.only(bottom: -50),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            _dobController.text.isNotEmpty
                                                ? _dobController.text
                                                : 'Chọn ngày sinh', // Display selected date or hint
                                            style: infoDetailStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          // //SO DIEN THOAI
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                const Expanded(
                                  flex: 1,
                                  child: Text(
                                    "Số điện thoại:",
                                    style: subtitleDetailStyle,
                                  ),
                                ),
                                Expanded(
                                    flex: 2,
                                    child: TextFormField(
                                        controller: _phoneController,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter
                                              .digitsOnly // Chỉ cho phép nhập số
                                        ],
                                        style: infoDetailStyle,
                                        decoration: inputAdminStyle(
                                            hintText: 'Nhập số điện thoại'))),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          //CHI NHANH LAM VIEC
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                const Expanded(
                                  flex: 1,
                                  child: Text(
                                    "Chi nhánh:",
                                    style: subtitleDetailStyle,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: DropdownButtonFormField<int>(
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    dropdownColor: Colors.white,
                                    style: infoDetailStyle,
                                    value: _selectedBranch,
                                    items: _branchs.map((branch) {
                                      return DropdownMenuItem<int>(
                                        value: branch.id,
                                        child: Text(
                                          branch.anothername!,
                                          style: infoDetailStyle,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedBranch = value;
                                      });
                                    },
                                    decoration: inputAdminStyleAdd(
                                        hintText: 'Chọn chi nhánh làm việc'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          // //CHUC VU
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Row(
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                const Expanded(
                                  flex: 1,
                                  child: Text(
                                    "Chức vụ:",
                                    style: subtitleDetailStyle,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: DropdownButtonFormField<int>(
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    style: infoDetailStyle,
                                    dropdownColor: Colors.white,
                                    value: _selectedRoleIndex,
                                    onChanged: (newValue) {
                                      setState(() {
                                        _selectedRoleIndex = newValue;
                                      });
                                    },
                                    items: roles.asMap().entries.map((entry) {
                                      return DropdownMenuItem<int>(
                                        value: entry.key,
                                        child: Text(entry.value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          //TRANG THAI
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Row(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                const Expanded(
                                  flex: 1,
                                  child: Text(
                                    "Trạng thái:",
                                    style: subtitleDetailStyle,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: DropdownButtonFormField<int>(
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    dropdownColor: Colors.white,
                                    style: infoDetailStyle,
                                    value: _selectedStateIndex,
                                    onChanged: (newValue) {
                                      setState(() {
                                        _selectedStateIndex = newValue;
                                      });
                                    },
                                    items: states.asMap().entries.map((entry) {
                                      return DropdownMenuItem<int>(
                                        value: entry.key,
                                        child: Text(entry.value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
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
                                  setState(() {
                                    _onUpdate(context);
                                  });
                                  setState(() {});
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
