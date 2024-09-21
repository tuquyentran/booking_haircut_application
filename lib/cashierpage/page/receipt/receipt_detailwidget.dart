import 'package:flutter/material.dart';
import '../../../config/list/service_body.dart';
import '../../../data/api/sqlite.dart';
import '../../../data/model/branchmodel.dart';
import '../../../data/model/employeemodel.dart';
import '../../../data/model/receipt_service.dart';
import '../../../data/model/receiptmodel.dart';
import 'package:dotted_line/dotted_line.dart';
import '../../../data/model/servicemodel.dart';
import 'package:intl/intl.dart';
import '../../../config/const.dart';

class ReceiptDetail extends StatefulWidget {
  final Receipt receipt;
  const ReceiptDetail({Key? key, required this.receipt}) : super(key: key);

  @override
  State<ReceiptDetail> createState() => _ReceiptDetailState();
}

class _ReceiptDetailState extends State<ReceiptDetail> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  double subtotalAmount = 0;
  List<ReceiptService> lstSer = [];

  Future<List<ReceiptService>> _getListReceiptService() async {
    return await _databaseHelper.getServiceByReceipt(widget.receipt.id);
  }

  Future<Service?> _getService(int? item) async {
    return await _databaseHelper.getServiceById(item);
  }

  Future<Employee?> _getEmployee(int? id) async {
    return await _databaseHelper.getEmployeeById(id!);
  }

  Future<Branch?> _getBranch(int? id) async {
    return await _databaseHelper.getBranchById(id);
  }

  void calculateSubtotal() async {
    lstSer = await _getListReceiptService();
    for (var item in lstSer) {
      subtotalAmount += item.price ?? 0;
    }
    int? id = lstSer.first.service;
    Service service = (await _getService(id)) as Service;
    print(service.name);

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    calculateSubtotal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Tiêu đề
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
                            alignment: Alignment.center,
                            child: Text(
                              "Chi tiết hóa đơn",
                              style: headingStyle,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(""),
                        ),
                      ],
                    ),
                    // Tiêu đề ------------------End
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
                    const SizedBox(
                      height: 10,
                    ),
                    // Mã hóa đơn
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Expanded(
                            child: Text(
                              "Mã hóa đơn:",
                              style: subtitleDetailStyle,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Text(
                              "HD${widget.receipt.id.toString().padLeft(6, '0')}",
                              style: infoDetailStyle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Mã hóa đơn ----------------End
                    const SizedBox(
                      height: 5,
                    ),
                    // Ngày tạo
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Expanded(
                            child: Text(
                              "Ngày tạo:",
                              style: subtitleDetailStyle,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Text(
                              widget.receipt.dateCreate.toString(),
                              style: infoDetailStyle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Ngày tạo ----------------End
                    const SizedBox(
                      height: 5,
                    ),
                    // Chi nhánh cắt tóc
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Expanded(
                            child: Text(
                              "Chi nhánh cắt tóc:",
                              style: subtitleDetailStyle,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: FutureBuilder(
                              future: _getBranch(widget.receipt.branch),
                              builder: (context, snapshot) => Text(
                                snapshot.data?.anothername ?? "",
                                style: infoDetailStyle,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Chi nhánh cắt tóc ----------------End
                    const SizedBox(
                      height: 5,
                    ),
                    // Kỹ thuật viên
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Expanded(
                            child: Text(
                              "Kỹ thuật viên:",
                              style: subtitleDetailStyle,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: FutureBuilder(
                              future: _getEmployee(widget.receipt.employee),
                              builder: (context, snapshot) => Text(
                                "Thợ tóc - ${snapshot.data?.name}",
                                style: infoDetailStyle,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Kỹ thuật viên ----------------End
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                      child: DottedLine(
                        dashColor: branchColor40,
                        dashLength: 5,
                        dashGapLength: 2,
                        dashRadius: 8,
                      ),
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Thông tin khách hàng",
                        style: headingStyle,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    // Tên khách hàng
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Expanded(
                            child: Text(
                              "Tên khách hàng:",
                              style: subtitleDetailStyle,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Text(
                              widget.receipt.name.toString(),
                              style: infoDetailStyle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Tên khách hàng ----------------End
                    const SizedBox(
                      height: 5,
                    ),
                    // Số điện thoại
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Expanded(
                            child: Text(
                              "Số điện thoại:",
                              style: subtitleDetailStyle,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Text(
                              widget.receipt.phone.toString(),
                              style: infoDetailStyle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Số điện thoại ----------------End
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                      child: DottedLine(
                        dashColor: branchColor40,
                        dashLength: 5,
                        dashGapLength: 2,
                        dashRadius: 8,
                      ),
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Dịch vụ",
                        style: headingStyle,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    // DANH SÁCH DỊCH VỤ
                    lstSer.isEmpty
                        ? const Text(
                            'Không có dịch vụ nào!',
                            style: nullStyle,
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: lstSer.length,
                            itemBuilder: (context, index) {
                              return itemServiceReceiptNEW(
                                  lstSer[index], index, context);
                            },
                          ),
                    // DANH SÁCH DỊCH VỤ ----------------End
                    const SizedBox(
                      height: 5,
                    ),
                    // Tạm tính
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Row(
                        children: <Widget>[
                          const Expanded(
                            child: Text(
                              "Tạm tính:",
                              style: subtitleTempStyle,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Text(
                              NumberFormat('###,###.### đ')
                                  .format(subtotalAmount),
                              style: infoTempStyle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Tạm tính ----------------End
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                      child: DottedLine(
                        dashColor: branchColor40,
                        dashLength: 5,
                        dashGapLength: 2,
                        dashRadius: 8,
                      ),
                    ),
                    // Tiền tip
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Expanded(
                            child: Text(
                              "Tiền tip:",
                              style: subtitleTempStyle,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Text(
                              NumberFormat('###,###.### đ')
                                  .format(widget.receipt.tip),
                              style: infoTempStyle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Tiền tip ----------------End
                    const SizedBox(
                      height: 5,
                    ),
                    // Tổng tiền
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Expanded(
                            child: Text(
                              "Tổng tiền:",
                              style: infoDetailStyle,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Text(
                              NumberFormat('###,###.### đ')
                                  .format(widget.receipt.total),
                              style: subtitleDetailStyle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Tổng tiền ----------------End
                    const SizedBox(
                      height: 10,
                    ),
                    // Thanh toán
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Expanded(
                            child: Text(
                              "Thanh toán:",
                              style: headingStyle,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Text(
                              NumberFormat('###,###.### đ')
                                  .format(widget.receipt.total),
                              style: headingStyle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Thanh toán ----------------End
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
