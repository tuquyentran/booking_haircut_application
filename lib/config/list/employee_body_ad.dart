// lib/itemEmployeeAd.dart

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

import '../../adminpage/page/employee/employee_detailwidget.dart';
import '../../data/api/sqlite.dart';
import '../../data/model/employeemodel.dart';
import '../const.dart'; // Đường dẫn đến EmployeeDetailwidget

class ItemEmployeeAd extends StatelessWidget {
  final Employee employee;
  final int index;

  const ItemEmployeeAd({
    Key? key,
    required this.employee,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmployeeDetailwidget(employee: employee),
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
              //   flex: 1,
              //   child: Text(
              //     (index + 1).toString(),
              //     style: serialStyle,
              //   ),
              // ),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employee.name.toString(),
                      style: infoListStyle,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FutureBuilder<String>(
                      future: DatabaseHelper().getBranchName(employee.branch!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text('Loading...');
                        } else if (snapshot.hasError) {
                          return Text(snapshot.hasError.toString());
                        } else {
                          return Text(
                            snapshot.data ?? '',
                            style: infoListStyle3,
                          );
                        }
                      },
                    ),
                    // Text(
                    //   employee.branch.toString(),
                    //   style: infoListStyle3,
                    // ),
                  ],
                ),
              ),
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
    // ListTile(
    //   onTap: () {
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => EmployeeDetailwidget(employee: employee),
    //       ),
    //     );
    //   },
    //   key: ValueKey(employee.id),

    //   leading: Text('${index + 1}', style: infoListStyle),
    //   title: Text('${employee.nickname}', style: infoListStyle),
    //   trailing: Text('${employee.branch}', style: trailing),
    // );
  }
}
