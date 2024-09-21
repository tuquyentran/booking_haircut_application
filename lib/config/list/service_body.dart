import 'package:booking_haircut_application/data/model/branch_servicemodel.dart';
import 'package:booking_haircut_application/data/model/selectedCusmodel.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../adminpage/page/service/service_editwidget.dart';
import '../../data/api/sqlite.dart';
import '../../data/model/order_servicemodel.dart';
import '../../data/model/receipt_service.dart';
import '../../data/model/selectedCashiermodel.dart';
import '../../data/model/servicemodel.dart';
import 'package:flutter/material.dart';
import '../const.dart';

Widget itemServiceOrder(Service item, int index, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text(
            (index + 1).toString(),
            style: serialStyle2,
          ),
        ),
        Expanded(
          flex: 5,
          child: Text(
            item.name.toString(),
            style: subtitleDetailStyle,
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          flex: 4,
          child: Text(
            NumberFormat('###,###.### đ').format(item.price),
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

Widget itemServiceCusBooking(Service item, BuildContext context) {
  return Consumer<SelectedCusModel>(
    builder: (context, value, child) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name.toString(),
                      style: subtitleStyle17,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      NumberFormat('###,###.### đ').format(item.price),
                      style: labelStyle17n,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Icon(
                          Icons.timer_outlined,
                          color: branchColor60,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          "${item.time.toString()} phút",
                          style: subtitleStyle4,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const Spacer(),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.center,
                  child: IconButton(
                    onPressed: () {
                      value.Delete(item);
                    },
                    icon: const Icon(
                      Icons.remove_circle_outline_rounded,
                      color: Colors.red,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          // DottedLine
          const DottedLine(
            dashColor: branchColor20,
            dashLength: 5,
            dashGapLength: 2,
            dashRadius: 8,
          ),
          // DottedLine ------END
          const SizedBox(
            height: 5,
          ),
        ],
      );
    },
  );
}

Widget itemServiceCashierBooking(Service item, BuildContext context) {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  return Consumer<SelectedCashierModel>(
    builder: (context, value, child) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name.toString(),
                      style: subtitleStyle17,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    FutureBuilder(
                        future: _databaseHelper.getBranchServiceByIdService(
                            item.id!, value.branch!.id!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return Text(
                              NumberFormat('###,###.### đ')
                                  .format(snapshot.data?.price),
                              style: labelStyle17n,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                            );
                          }
                        }),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Icon(
                          Icons.timer_outlined,
                          color: branchColor60,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          "${item.time.toString()} phút",
                          style: subtitleStyle4,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const Spacer(),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.center,
                  child: IconButton(
                    onPressed: () async {
                      BranchService? myService =
                          await _databaseHelper.getBranchServiceByIdService(
                              item.id!, value.branch!.id!);

                      value.Delete(myService!);
                    },
                    icon: const Icon(
                      Icons.remove_circle_outline_rounded,
                      color: Colors.red,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          // DottedLine
          const DottedLine(
            dashColor: branchColor20,
            dashLength: 5,
            dashGapLength: 2,
            dashRadius: 8,
          ),
          // DottedLine ------END
          const SizedBox(
            height: 5,
          ),
        ],
      );
    },
  );
}

// Detail Branch
Widget itemServiceBranch(Service item, BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            item.name.toString(),
            style: labelStyle17n,
          ),
          const Spacer(),
          Text(
            NumberFormat('###,###.### đ').format(item.price),
            style: labelStyle17n,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
          ),
        ],
      ),
      const SizedBox(
        height: 5,
      ),
      // DottedLine
      const DottedLine(
        dashColor: branchColor20,
        dashLength: 5,
        dashGapLength: 2,
        dashRadius: 8,
      ),
      // DottedLine ------END
      const SizedBox(
        height: 5,
      ),
    ],
  );
}

// Select Service Widget
Widget serviceForSelectCus(Service item, BuildContext context) {
  return Consumer<SelectedCusModel>(
    builder: (context, value, child) {
      return Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: branchColor20.withOpacity(0.6),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name.toString(),
                        style: subtitleDetailStyle,
                      ),
                      Text(
                        NumberFormat('###,###.### đ').format(item.price),
                        style: infoDetailStyle,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.timer_outlined,
                            color: branchColor60,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            "${item.time.toString()} phút",
                            style: subtitleStyle4,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: IconButton(
                    onPressed: () {
                      if (!value.serviceSelected(item)) {
                        value.Add(item);
                      } else {
                        value.Delete(item);
                      }
                    },
                    icon: !value.serviceSelected(item)
                        ? const Icon(
                            Icons.add_circle_outline_rounded,
                            size: 30,
                          )
                        : const Icon(
                            Icons.remove_circle_outline_rounded,
                            color: Colors.red,
                            size: 30,
                          ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      );
    },
  );
}

// REMAKE
Widget serviceForSelectCashier(BranchService item, BuildContext context) {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  print(item.price);
  return Consumer<SelectedCashierModel>(
    builder: (context, value, child) {
      return Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: branchColor20.withOpacity(0.6),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder(
                          future: _databaseHelper.getServiceById(item.service),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return Text(
                                snapshot.data!.name.toString(),
                                style: subtitleDetailStyle,
                              );
                            }
                          }),
                      Text(
                        NumberFormat('###,###.### đ').format(item.price),
                        style: infoDetailStyle,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.timer_outlined,
                            color: branchColor60,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          FutureBuilder(
                              future:
                                  _databaseHelper.getServiceById(item.service),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  return Text(
                                    "${snapshot.data!.time.toString()} phút",
                                    style: infoDetailStyle,
                                  );
                                }
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: IconButton(
                    onPressed: () {
                      if (!value.serviceSelected(item)) {
                        value.Add(item);
                      } else {
                        value.Delete(item);
                      }
                    },
                    icon: !value.serviceSelected(item)
                        ? const Icon(
                            Icons.add_circle_outline_rounded,
                            size: 30,
                          )
                        : const Icon(
                            Icons.remove_circle_outline_rounded,
                            color: Colors.red,
                            size: 30,
                          ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      );
    },
  );
}

Widget itemServiceOrderNEW(OrderService item, int index, BuildContext context) {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text(
            (index + 1).toString(),
            style: serialStyle2,
          ),
        ),
        Expanded(
          flex: 5,
          child: FutureBuilder(
            future: databaseHelper.getServiceById(item.service),
            builder: (context, snapshot) => Text(
              snapshot.data?.name ?? '',
              style: subtitleDetailStyle,
            ),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          flex: 4,
          child: Text(
            NumberFormat('###,###.### đ').format(item.price),
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

Widget itemServiceReceiptNEW(
    ReceiptService item, int index, BuildContext context) {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text(
            (index + 1).toString(),
            style: serialStyle2,
          ),
        ),
        Expanded(
          flex: 5,
          child: FutureBuilder(
            future: databaseHelper.getServiceById(item.service),
            builder: (context, snapshot) => Text(
              snapshot.data?.name ?? 'Không tìm thấy',
              style: subtitleDetailStyle,
            ),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          flex: 4,
          child: Text(
            NumberFormat('###,###.### đ').format(item.price),
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

Widget itemService(Service item, int index, BuildContext context) {
  return
      // InkWell(
      // onTap: () {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => ServiceEditwidget(
      //          service: item,
      //         onServiceUpdated: (value) {
      //           setState(() {
      //            item.id!; // Cập nhật Future
      //           });
      //         },
      //       ),
      //     ),
      //   ).then((_) {
      //     setState(() {});
      //   });
      // },

      InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ServiceEditwidget(
            service: item,
            onServiceUpdated: (value) {},
          ),
        ),
      );
    },
    child: Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            // Expanded(
            //   // flex: 1,
            //   child: Text(
            //     (index + 1).toString(),
            //     style: serialStyle,
            //   ),
            // ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.id.toString(),
                    style: infoListStyle,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),
            Expanded(
              flex: 4,
              child: Text(
                item.name.toString(),
                style: infoListStyle,
                textAlign: TextAlign.left,
              ),
            ),
            Expanded(
              flex: 2,
              child:
                  // Text(
                  //   item.type.toString(),
                  //   style: infoListStyle,
                  //   textAlign: TextAlign.right,
                  // ),
                  FutureBuilder<String>(
                future: DatabaseHelper().getServicetypeName(item.type!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text('Loading...');
                  } else if (snapshot.hasError) {
                    return Text(snapshot.hasError.toString());
                  } else {
                    return Text(
                      snapshot.data ?? '',
                      style: infoListStyle,
                    );
                  }
                },
              ),
            ),

            // Expanded(
            //   flex: 1,
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         items.id.toString(),
            //         style: infoListStyle,
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        const DottedLine(
          dashColor: branchColor20,
          dashLength: 5,
          dashGapLength: 2,
          dashRadius: 8,
        ),
      ],
    ),
  );
}
