import '../../cashierpage/page/employee/employee_detailwidget.dart';
import '../../data/model/employeemodel.dart';
import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';
import '../const.dart';

Widget itemEmployeeView(Employee item, int index, BuildContext context) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EmployeeDetail(
            id: item.id,
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
            Expanded(
              flex: 1,
              child: Text(
                (index + 1).toString(),
                style: serialStyle,
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "NV${item.id.toString().padLeft(6, '0')}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: infoListStyle,
                  ),
                  Text(
                    item.gender == 0 ? "Nam" : "Nữ",
                    style: infoListStyle2,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name.toString(),
                    style: infoListStyle,
                  ),
                  Text(
                    item.nickname.toString(),
                    style: infoListStyle2,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                item.role == 0 ? "Thợ tóc" : "Thu ngân",
                style: infoListStyle,
                textAlign: TextAlign.left,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
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
}

Widget itemEmployeeCus(Employee item, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 0),
    child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: branchColor20.withOpacity(0.6),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 4), // Thay đổi vị trí của bóng đổ
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage(urlImgEmp + item.image!),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset:
                            const Offset(0, 4), // Thay đổi vị trí của bóng đổ
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 12,
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 200,
                          child: Text(
                            "Thợ tóc - ${item.nickname}",
                            style: titleStyle17,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.star_border_outlined, size: 24),
                        const SizedBox(width: 1),
                        const Text(
                          "4.9",
                          style: TextStyle(
                            fontFamily: "Inter",
                            fontSize: 18,
                            color: branchColor80,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 0),
                    Row(
                      children: [
                        Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: AssetImage(urlImgEmp + item.image!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: AssetImage(urlImgEmp + item.image!),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 0,
                                blurRadius: 4,
                                offset: const Offset(
                                    0, 4), // Thay đổi vị trí của bóng đổ
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: AssetImage(urlImgEmp + item.image!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// Statistical
Widget itemEmployeeStatistical(Employee item, int index, BuildContext context) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EmployeeDetail(
            id: item.id,
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
            Expanded(
              flex: 1,
              child: Text(
                (index + 1).toString(),
                style: serialStyle,
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "NV${item.id.toString().padLeft(6, '0')}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: infoListStyle,
                  ),
                  Text(
                    item.gender == 0 ? "Nam" : "Nữ",
                    style: infoListStyle2,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name.toString(),
                    style: infoListStyle,
                  ),
                  Text(
                    item.nickname.toString(),
                    style: infoListStyle2,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: FutureBuilder(
                future: item.getTotalOrder(),
                builder: (context, snapshot) => Text(
                  snapshot.data.toString(),
                  style: serialStyle2,
                  textAlign: TextAlign.center,
                  // maxLines: 2,
                  // overflow: TextOverflow.ellipsis,
                ),
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
}
