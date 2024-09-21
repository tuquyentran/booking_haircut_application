import 'package:booking_haircut_application/data/provider/receiptprovider.dart';
import 'package:flutter/material.dart';
import 'package:booking_haircut_application/config/const.dart';

import '../../../config/list/receipt_body.dart';
import '../../../data/model/receiptmodel.dart';

class BillWidget extends StatefulWidget {
  const BillWidget({super.key});

  @override
  State<BillWidget> createState() => _BillWidgetState();
}

class _BillWidgetState extends State<BillWidget> {
  List<Receipt> lstBill = [];
  String query = '';
  void onQueryChanged(String newQuery) {
    setState(() {
      query = newQuery;
    });
  }

  Future<void> loadBillList() async {
    lstBill = (await ReadDataReceipt().loadData());
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadBillList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Thanh tìm kiếm
                      Container(
                        height: 50,
                        decoration: const BoxDecoration(),
                        child: TextField(
                          onChanged: onQueryChanged,
                          decoration: const InputDecoration(
                            labelText: "Tìm kiếm...",
                            labelStyle: TextStyle(color: branchColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(16.0),
                              ),
                              borderSide: BorderSide(color: branchColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(16.0),
                              ),
                              borderSide:
                                  BorderSide(color: branchColor, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(16.0),
                              ),
                              borderSide:
                                  BorderSide(color: branchColor, width: 2),
                            ),
                            prefixIcon: Icon(Icons.search_rounded),
                          ),
                          cursorColor: branchColor,
                        ),
                      ),
                      // Thanh tìm kiếm -------------- End
                      const SizedBox(
                        height: 10,
                      ),
                      const Row(
                        children: <Widget>[
                          Text(
                            "Danh sách hóa đơn",
                            style: headingStyle,
                          ),
                          Spacer(),
                          Icon(Icons.filter_list_rounded),
                        ],
                      ),
                      const Divider(
                        color: branchColor,
                        height: 10,
                        thickness: 2,
                      ),
                      // Danh sách hóa đơn
                      lstBill.isEmpty
                          ? const Text(
                              'Không có hóa đơn nào!',
                              style: nullStyle,
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:
                                  lstBill.length > 5 ? 5 : lstBill.length,
                              itemBuilder: (context, index) {
                                return itemReceiptView(
                                    lstBill[index], index, context);
                              },
                            ),
                      // Danh sách hóa đơn ----------End
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
