import 'dart:convert';
import 'dart:io';

import 'package:booking_haircut_application/adminpage/page/employee/employee_editwidget.dart';
import 'package:booking_haircut_application/config/const.dart';
import 'package:booking_haircut_application/config/photo_view.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../config/list/receipt_body.dart';
import '../../../data/api/sqlite.dart';
import '../../../data/model/employeemodel.dart';
import '../../../data/model/receiptmodel.dart';

class EmployeeDetailwidget extends StatefulWidget {
  final Employee employee;

  const EmployeeDetailwidget({super.key, required this.employee});

  @override
  State<EmployeeDetailwidget> createState() => _EmployeeDetailwidgetState();
}

class _EmployeeDetailwidgetState extends State<EmployeeDetailwidget> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Receipt> lstReceipt = [];
  double? total;
  late Employee selectedEmployee;
  Future<List<Receipt>> _getReceipt() async {
    return _databaseHelper.getReceiptsByEmployee(widget.employee.id);
  }

  Future<double> _getTotalByEmployee() async {
    // thêm vào 1 dòng dữ liệu nếu getdata không có hoặc chưa có database
    return await _databaseHelper.getTotalByEmployee(selectedEmployee.id!);
  }

  Future<double> _getTipByEmployee() async {
    // thêm vào 1 dòng dữ liệu nếu getdata không có hoặc chưa có database
    return await _databaseHelper.getTipByEmployee(selectedEmployee.id!);
  }

  void LoadList() async {
    print(widget.employee.id);
    lstReceipt = await _getReceipt();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    selectedEmployee = widget.employee; //để lấy đúng thông tin của nhân viên
    LoadList();
  }

  @override
  Widget build(BuildContext context) {
    // Tính toán số hóa đơn, tổng tiền hóa đơn, tổng tiền tip

    @override
    void initState() {
      super.initState();
    }

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(color: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // const Align(
                    //     alignment: Alignment.centerLeft,
                    //     child: BackButton(
                    //       color: branchColor,
                    //     )),
                    // Align(
                    //   alignment: Alignment.center,
                    //   child: GestureDetector(
                    //     onTap: () {
                    //       // Navigator.push(
                    //       //   context,
                    //       //   MaterialPageRoute(
                    //       //     builder: (context) => ImageZoomScreen(
                    //       //         imagePath: selectedEmployee.image!),
                    //       //   ),
                    //       // );
                    //     },
                    //     child: Container(
                    //       width: 150,
                    //       height: 150,
                    //       decoration: BoxDecoration(
                    //         border:
                    //             Border.all(color: Color(0xFF000000), width: 1),
                    //         borderRadius: BorderRadius.circular(16),
                    //         boxShadow: [
                    //           BoxShadow(
                    //             color: Colors.black.withOpacity(0.4),
                    //             spreadRadius: 0,
                    //             blurRadius: 4,
                    //             offset: const Offset(0, 4),
                    //           ),
                    //         ],
                    //       ),
                    //       child: ClipRRect(
                    //         borderRadius: BorderRadius.circular(15),
                    //         child: selectedEmployee.image == ''
                    //             ? Container(
                    //                 alignment: Alignment.center,
                    //                 decoration: const BoxDecoration(
                    //                   color: Color(0xFFD9D9D9),
                    //                 ),
                    //                 // child:
                    //                 // const Icon(Icons.add_a_photo_outlined),
                    //               )
                    //             // : Image.file(
                    //             //     File(selectedEmployee.image!),
                    //             //     fit: BoxFit.cover,
                    //             //   ),
                    //             : Image.asset(
                    //                 urlImgEmp + selectedEmployee.image!),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: BackButton(
                        color: branchColor,
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ImageZoomScreen(
                                imagePath:
                                    "${urlImgEmp + selectedEmployee.image!}",
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(16),
                            ),
                            image: DecorationImage(
                              image: AssetImage(
                                "${urlImgEmp + selectedEmployee.image!}",
                              ),
                              fit: BoxFit.cover,
                              onError: (exception, stackTrace) => Image.file(
                                File(selectedEmployee.image!),
                                fit: BoxFit.cover,
                              ),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                spreadRadius: 0,
                                blurRadius: 4,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // Thông tin nhân viên

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Thông tin nhân viên",
                          style: headingStyle,
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: IconButton(
                            onPressed: () {
                              selectedEmployee.image = '';
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EmployeeEditwidget(
                                    employee: selectedEmployee,
                                    onEmployeeUpdated: (updatedEmployee) {
                                      setState(() {
                                        selectedEmployee = updatedEmployee;
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit_note_rounded),
                          ),

                          //  IconButton(
                          //   onPressed: () {
                          //     Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //           builder: (context) => EmployeeEditwidget(
                          //             employee: selectedEmployee,
                          //           ),
                          //         )).then((_) {
                          //       setState(() {});
                          //     });
                          //   },
                          //   icon: const Icon(Icons.edit_note_rounded),
                          // ),
                        )
                      ],
                    ),
                    const Divider(
                      color: branchColor,
                      height: 10,
                      thickness: 2,
                    ),
                    //NOI DUNG
                    _buildDetailRow(
                        "Mã nhân viên:", selectedEmployee.id.toString()),
                    _buildDetailRow("Tên nhân viên:", selectedEmployee.name),
                    _buildDetailRow("Biệt danh:", selectedEmployee.nickname),

                    // _buildDetailRow(
                    //     "Chi nhánh làm việc:", selectedEmployee.branch),

                    _buildDetailRow("Ngày sinh:", selectedEmployee.birthday),
                    _buildDetailRow("Giới tính:",
                        selectedEmployee.gender == 1 ? "Nữ" : "Nam"),
                    _buildDetailRow("Chức vụ:",
                        selectedEmployee.role == 1 ? "Thu ngân" : "Thợ tóc"),
                    _buildDetailRow(
                        "Trạng thái:",
                        selectedEmployee.state == 1
                            ? "Đang làm việc"
                            : "Đã nghỉ việc"),
                    _buildDetailRow("Tổng lương:", "33,630,000"),
                    const SizedBox(
                      height: 5,
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Hình ảnh cắt",
                      style: headingStyle,
                    ),
                    const Divider(
                      color: branchColor,
                      height: 10,
                      thickness: 2,
                    ),
                    // Thông tin
                    const SizedBox(
                      height: 10,
                    ),
                    selectedEmployee.role == 0
                        ? Row(
                            children: [
                              // Button
                              Expanded(
                                flex: 2,
                                child: IconButton(
                                  iconSize: 30,
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.image_outlined,
                                    color: branchColor,
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    fixedSize: const Size(75, 75),
                                    side: const BorderSide(
                                      color: branchColor,
                                      width: 2,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              // Button --------End
                              const SizedBox(
                                width: 5,
                              ),
                              // Hình 1
                              Expanded(
                                flex: 2,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ImageZoomScreen(
                                          imagePath:
                                              'assets/images/haircut/haircut1.png',
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 75,
                                    width: 75,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                      image: const DecorationImage(
                                        image: AssetImage(
                                            'assets/images/haircut/haircut1.png'),
                                        fit: BoxFit.cover,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          spreadRadius: 0,
                                          blurRadius: 4,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // Hình 1 --------End
                              const SizedBox(
                                width: 5,
                              ),
                              // Hình 2
                              Expanded(
                                flex: 2,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ImageZoomScreen(
                                          imagePath:
                                              'assets/images/haircut/haircut2.png',
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 75,
                                    width: 75,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                      image: const DecorationImage(
                                        image: AssetImage(
                                            'assets/images/haircut/haircut2.png'),
                                        fit: BoxFit.cover,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          spreadRadius: 0,
                                          blurRadius: 4,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // Hình 2 --------End
                              const SizedBox(
                                width: 5,
                              ),
                              // Hình 3
                              Expanded(
                                flex: 2,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ImageZoomScreen(
                                          imagePath:
                                              'assets/images/haircut/haircut3.png',
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 75,
                                    width: 75,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                      image: const DecorationImage(
                                        image: AssetImage(
                                            'assets/images/haircut/haircut3.png'),
                                        fit: BoxFit.cover,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          spreadRadius: 0,
                                          blurRadius: 4,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // Hình 3 --------End
                            ],
                          )
                        : Text(''),

                    // Thông tin --------------End
                    // Hình ảnh cắt ------------------End
                    const SizedBox(
                      height: 10,
                    ),
                    // Hóa đơn liên quan ------------------End
                    const Text(
                      "Hóa đơn liên quan",
                      style: headingStyle,
                    ),
                    const Divider(
                      color: branchColor,
                      height: 10,
                      thickness: 2,
                    ),
                    // Tiền từ hóa đơn
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const Expanded(
                            child: Text(
                              "Tiền từ hóa đơn:",
                              style: subtitleDetailStyle,
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          // Expanded(
                          //   child: Text(
                          //     "11111",
                          //     style: infoTempStyle,
                          //     maxLines: 2,
                          //     overflow: TextOverflow.ellipsis,
                          //     textAlign: TextAlign.left,
                          //   ),
                          // ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: FutureBuilder<double>(
                              future: _getTotalByEmployee(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<double> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  total = snapshot.data;
                                  return Text(
                                    NumberFormat('###,###,### đ').format(total),
                                    style: infoDetailStyle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right,
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Tiền từ hóa đơn ----------------End
                    // Tiền tip từ khách
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const Expanded(
                            child: Text(
                              "Tiền tip từ khách:",
                              style: subtitleDetailStyle,
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          // Expanded(
                          //   child: Text(
                          //     "(21)",
                          //     style: infoTempStyle,
                          //     maxLines: 2,
                          //     overflow: TextOverflow.ellipsis,
                          //     textAlign: TextAlign.left,
                          //   ),
                          // ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: FutureBuilder<double>(
                              future: _getTipByEmployee(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<double> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  total = snapshot.data;
                                  return Text(
                                    NumberFormat('###,###,### đ').format(total),
                                    style: infoDetailStyle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right,
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Tiền tip từ khách ----------------End
                    // Thưởng
                    const Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const Expanded(
                            child: Text(
                              "Thưởng:",
                              style: subtitleDetailStyle,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Text(
                              "13,690,000 đ",
                              style: infoDetailStyle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Thưởng ----------------End
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: DottedLine(
                        dashColor: branchColor60,
                        dashLength: 5,
                        dashGapLength: 2,
                        dashRadius: 8,
                      ),
                    ),
                    // Hóa đơn liên quan ------------------End
                    lstReceipt.isEmpty
                        ? const Text(
                            'Không có hóa đơn nào!',
                            style: nullStyle,
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: lstReceipt.length,
                            itemBuilder: (context, index) {
                              return itemReceiptViewForEmployee(
                                  lstReceipt[index], index, context);
                            },
                          ),
                    // Hóa đơn liên quan ------------------End
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Text(
              title,
              style: subtitleDetailStyle,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Text(
              title == "Mã nhân viên:"
                  ? "NV${value.toString().padLeft(6, '0')}"
                  : value ?? '',
              style: infoDetailStyle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
