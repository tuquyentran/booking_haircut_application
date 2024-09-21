import 'package:flutter/material.dart';
import '../../../config/const.dart';
import '../../../config/list/order_body.dart';
import '../../../data/model/ordermodel.dart';
import '../../../data/provider/orderprovider.dart';

class OrderWidget extends StatefulWidget {
  const OrderWidget({super.key});

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  List<Order> lstOrder = [];
  String query = '';

  void onQueryChanged(String newQuery) {
    setState(() {
      query = newQuery;
    });
  }

  Future<void> loadOrderList() async {
    lstOrder = (await ReadDataOrder().loadData());
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadOrderList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: Center(
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
                        // Thanh tìm kiếm
                        const SizedBox(
                          height: 10,
                        ),
                        const Row(
                          children: <Widget>[
                            Text(
                              "Danh sách đơn đặt",
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
                        // Danh sách đơn đặt
                        lstOrder.isEmpty
                            ? const Text(
                                'Không có đơn đặt nào!',
                                style: nullStyle,
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: lstOrder.length,
                                itemBuilder: (context, index) {
                                  return itemOrderView(
                                      lstOrder[index], index, context);
                                },
                              ),
                        // Danh sách đơn đặt ----------End
                      ],
                    ),
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
