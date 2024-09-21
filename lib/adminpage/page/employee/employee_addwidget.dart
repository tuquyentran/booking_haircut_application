import 'package:booking_haircut_application/data/model/branchmodel.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../../../config/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../config/dropdownAD.dart';
import '../../../data/api/sqlite.dart';
import '../../../data/model/employeemodel.dart';
import '../../../data/provider/employeeprovider.dart';

class EmployeeAddwidget extends StatefulWidget {
  const EmployeeAddwidget({super.key});

  @override
  State<EmployeeAddwidget> createState() => _EmployeeAddwidgetState();
}

class _EmployeeAddwidgetState extends State<EmployeeAddwidget> {
  final DatabaseHelper _database = DatabaseHelper();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  int? _gender;
  String? _imagePath;
  String? _selectedDate;
  DateTime? _Date = DateTime.now();
  int? _selectedRoleIndex;
  int? _selectedStateIndex;
  String formattedDate = '';

  int? _selectedBranch;
  List<String> branches = [];
  List<String> roles = [
    'Thợ tóc',
    'Thu ngân',
  ];
  List<String> states = ['Nghỉ việc', 'Đang làm việc'];

  List<Branch> _branchs = [];
  Future<void> _fetchBranchs() async {
    _branchs = await _database.lisBranchEmployee();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _fetchBranchs();
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
    await _database.insertEmployeeAdmin(Employee(
      image: _imagePath ?? '',
      name: _nameController.text,
      nickname: _nicknameController.text ?? '',
      gender: _gender,
      birthday: _selectedDate,
      phone: _phoneController.text,
      email: '',
      branch: _selectedBranch,
      role: _selectedRoleIndex,
      state: _selectedStateIndex,
    ));

    setState(() {});
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Thêm nhân viên",
          style: headingStyle,
        ),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    Container(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //THEM ANH NHAN VIEN

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

                          //NOI DUNG CHINH SUA THONG TIN.......................................
                          //MA NHAN VIEN
                          const SizedBox(height: 20),

                          const SizedBox(height: 20),
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
                          //NGAY SINH
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
                                    onTap: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime(2100),
                                      );
                                      if (pickedDate != null &&
                                          pickedDate != _Date) {
                                        setState(() {
                                          _Date = pickedDate;
                                        });
                                      }
                                    },
                                    child: InputDecorator(
                                      decoration: inputAdminStyle(),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            _selectedDate =
                                                "${_Date!.day}/${_Date!.month}/${_Date!.year}"
                                                    '',
                                            style: infoDetailStyle,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                bottom: 3, right: 10),
                                            child: Icon(Icons.calendar_today),
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
                          //SO DIEN THOAI
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
                          //CHUC VU
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                                    decoration: inputAdminStyleAdd(
                                      hintText: 'Chọn chức vụ',
                                    ),
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
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                                    style: infoDetailStyle,
                                    decoration: inputAdminStyleAdd(
                                      hintText: 'Chọn trạng thái',
                                    ),
                                    dropdownColor: Colors.white,
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
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        _onSave(context);
                                      },
                                      style: buttonForServiceStyle(),
                                      child: const Text(
                                        'Thêm nhân viên',
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // void _refreshEmployeeList() {
  //   setState(() {
  //     listEmployee = ReadDataEmployee().loadData().then((employees) {
  //       setState(() {
  //         this.employees = employees;
  //         filteredEmployees = employees;
  //       });
  //       return employees;
  //     });
  //   });
  // }
}
