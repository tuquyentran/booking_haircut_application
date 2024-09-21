import 'package:booking_haircut_application/config/const.dart';
import 'package:booking_haircut_application/data/model/branchmodel.dart';
import 'package:booking_haircut_application/data/model/servicemodel.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class BranchEditServiceWidget extends StatefulWidget {
  final Service service;
  const BranchEditServiceWidget({super.key, required this.service});

  @override
  State<BranchEditServiceWidget> createState() =>
      _BranchEditServiceWidgetState();
}

class _BranchEditServiceWidgetState extends State<BranchEditServiceWidget> {
  final _price = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Thông tin dịch vụ', style: headingStyle),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: SafeArea(
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  _buildDetailRow(
                      "Mã dịch vụ:", (widget.service.id ?? '') as String?),
                  _buildDetailRow("Tên dịch vụ:", widget.service.name),
                  _buildDetailRow(
                      "Loại dịch vụ:", widget.service.type.toString()),
                  _buildDetailRow("Giá gốc:",
                      NumberFormat("#,### đ").format(widget.service.price)),
                  _buildDetailRow("Giá khác:",
                      NumberFormat("#,### đ").format(widget.service.price)),
                  const SizedBox(
                    height: 5,
                  ),
                  const DottedLine(
                    dashColor: branchColor,
                    dashLength: 5,
                    dashGapLength: 2,
                    dashRadius: 8,
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Chỉnh sửa giá tiền',
                        style: headingStyle,
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(children: [
                    const Text(
                      'Giá khác:',
                      style: subtitleDetailStyle,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                        child: TextField(
                            controller: _price,
                            textInputAction: TextInputAction.done,
                            decoration: const InputDecoration(
                                hintText: 'Nhập giá khác',
                                hintStyle: hintText,
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: branchColor20))))),
                  ]),
                ],
              )),
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
                        String updatedPrice = _price.text;

                        if (updatedPrice.isNotEmpty) {
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
        ],
      ),
    );
  }

  Widget _buildDetailRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Text(title, style: subtitleDetailStyle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value ?? 'N/A',
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
