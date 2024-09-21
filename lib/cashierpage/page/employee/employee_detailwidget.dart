import 'package:booking_haircut_application/config/list/receipt_body.dart';
import 'package:booking_haircut_application/data/api/sqlite.dart';

import '../../../data/model/receiptmodel.dart';
import '../../../data/provider/branchprovider.dart';
import '../../../data/provider/employeeprovider.dart';

import '../../../config/photo_view.dart';

import '../../../data/model/employeemodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../config/const.dart';
import 'package:dotted_line/dotted_line.dart';

class EmployeeDetail extends StatefulWidget {
  final int? id;
  const EmployeeDetail({Key? key, required this.id}) : super(key: key);

  @override
  State<EmployeeDetail> createState() => _EmployeeDetailState();
}

class _EmployeeDetailState extends State<EmployeeDetail> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  Employee? employee;
  List<Receipt> lstReceipt = [];

  Future<List<Receipt>> _getReceipt() async {
    return _databaseHelper.getReceiptsByEmployee(employee?.id);
  }

  Future<void> LoadData() async {
    employee = await _databaseHelper.getEmployeeById(widget.id!);
    if (employee != null) {
      lstReceipt = await _getReceipt();
      await employee?.init();
    } else {
      print("Employee not found");
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    LoadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: employee == null
          ? const Center(
              child: CircularProgressIndicator(
                color: branchColor,
              ),
            )
          : Stack(
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(urlBackground),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                  child: SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
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
                                          "${urlImgEmp + employee!.image!}",
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
                                      "${urlImgEmp + employee!.image!}",
                                    ),
                                    fit: BoxFit.cover,
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
                          const Text(
                            "Thông tin nhân viên",
                            style: headingStyle,
                          ),
                          const Divider(
                            color: branchColor,
                            height: 10,
                            thickness: 2,
                          ),
                          // Mã nhân viên
                          const SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Expanded(
                                  child: Text(
                                    "Mã nhân viên:",
                                    style: subtitleDetailStyle,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Text(
                                    "NV${employee!.id.toString().padLeft(6, '0')}",
                                    style: infoDetailStyle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Mã nhân viên ----------------End
                          const SizedBox(
                            height: 5,
                          ),
                          // Tên nhân viên
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Expanded(
                                  child: Text(
                                    "Tên nhân viên:",
                                    style: subtitleDetailStyle,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Text(
                                    employee!.name.toString(),
                                    style: infoDetailStyle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Tên nhân viên ----------------End
                          const SizedBox(
                            height: 5,
                          ),
                          // Biệt danh
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Expanded(
                                  child: Text(
                                    "Biệt danh:",
                                    style: subtitleDetailStyle,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Text(
                                    employee!.nickname.toString(),
                                    style: infoDetailStyle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Biệt danh ----------------End
                          const SizedBox(
                            height: 5,
                          ),
                          // Chi nhánh làm việc
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Expanded(
                                  child: Text(
                                    "Chi nhánh làm việc:",
                                    style: subtitleDetailStyle,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: FutureBuilder(
                                    future: ReadDataBranch()
                                        .loadBranchById(employee?.branch),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else {
                                        return Text(
                                          snapshot.data!.anothername.toString(),
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
                          // Chi nhánh làm việc ----------------End
                          const SizedBox(
                            height: 5,
                          ),
                          // Ngày sinh
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Expanded(
                                  child: Text(
                                    "Ngày sinh:",
                                    style: subtitleDetailStyle,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Text(
                                    employee!.birthday.toString(),
                                    style: infoDetailStyle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Ngày sinh ----------------End
                          const SizedBox(
                            height: 5,
                          ),
                          // Giới tính
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Expanded(
                                  child: Text(
                                    "Giới tính:",
                                    style: subtitleDetailStyle,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Text(
                                    employee!.gender == 0 ? "Nam" : "Nữ",
                                    style: infoDetailStyle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Giới tính ----------------End
                          const SizedBox(
                            height: 5,
                          ),
                          // Chức vụ
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Expanded(
                                  child: Text(
                                    "Chức vụ:",
                                    style: subtitleDetailStyle,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Text(
                                    employee!.role == 0
                                        ? "Thợ tóc"
                                        : "Thu ngân",
                                    style: infoDetailStyle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Chức vụ ----------------End
                          const SizedBox(
                            height: 5,
                          ),
                          // Trạng thái
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Expanded(
                                  child: Text(
                                    "Trạng thái:",
                                    style: subtitleDetailStyle,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Text(
                                    employee!.state == 1
                                        ? "Đang làm việc"
                                        : "Đã nghỉ làm",
                                    style: infoDetailStyle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Trạng thái ----------------End
                          const SizedBox(
                            height: 5,
                          ),
                          // Tổng lương
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Expanded(
                                  child: Text(
                                    "Tổng lương:",
                                    style: subtitleDetailStyle,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Text(
                                    NumberFormat('###,###.### đ')
                                        .format(employee!.salary),
                                    style: infoDetailStyle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Tổng lương ----------------End
                          // Thông tin nhân viên ------------------End
                          const SizedBox(
                            height: 10,
                          ),
                          // Hình ảnh cắt ------------------End
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
                          Row(
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
                                    fixedSize: const Size(85, 85),
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
                                    height: 85,
                                    width: 85,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                      image: const DecorationImage(
                                        image: AssetImage(
                                            "assets/images/haircut/haircut1.png"),
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
                                    height: 85,
                                    width: 85,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                      image: const DecorationImage(
                                        image: AssetImage(
                                            "assets/images/haircut/haircut2.png"),
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
                                    height: 85,
                                    width: 85,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                      image: const DecorationImage(
                                        image: AssetImage(
                                            "assets/images/haircut/haircut3.png"),
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
                          ),
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
                                  flex: 6,
                                  child: Text(
                                    "Tiền từ hóa đơn:",
                                    style: subtitleDetailStyle,
                                  ),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "(${employee!.totalReceipt})",
                                    style: infoTempStyle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  flex: 6,
                                  child: Text(
                                    NumberFormat('###,###.### đ')
                                        .format(employee!.total),
                                    style: infoDetailStyle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right,
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
                                  flex: 6,
                                  child: Text(
                                    "Tiền tip từ khách:",
                                    style: subtitleDetailStyle,
                                  ),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "(${employee!.totalReceiptwithTip})",
                                    style: infoTempStyle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  flex: 6,
                                  child: Text(
                                    NumberFormat('###,###.### đ')
                                        .format(employee!.totalTip),
                                    style: infoDetailStyle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Tiền tip từ khách ----------------End
                          // Thưởng
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                const Expanded(
                                  flex: 6,
                                  child: Text(
                                    "Thưởng:",
                                    style: subtitleDetailStyle,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  flex: 6,
                                  child: Text(
                                    NumberFormat('###,###.### đ')
                                        .format(employee!.totalBonus),
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
}
