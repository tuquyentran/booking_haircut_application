import 'package:booking_haircut_application/clientpage/page/branch/branch_detailwidget.dart';
import '../../data/model/branchmodel.dart';
import 'package:flutter/material.dart';
import '../const.dart';
import 'package:dotted_line/dotted_line.dart';

Widget itemBranchView(Branch item, int index, BuildContext context) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BranchDetailwidget(
            branch: item,
          ), // Tạo trang chi tiết và truyền dữ liệu chi nhánh
        ),
      );
    },
    child: Padding(
      padding: const EdgeInsets.only(bottom: 2),
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
                    width: 105,
                    height: 105,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: AssetImage(urlImgShop + item.image!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        item.name.toString(),
                        style: titleStyle17,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Expanded(
                            flex: 0,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Icon(Icons.location_on_outlined, size: 20),
                            ),
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            flex: 9,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                item.address.toString(),
                                style: labelStyle17n,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      const Row(
                        children: [
                          Icon(Icons.star_border_outlined, size: 20),
                          SizedBox(width: 3),
                          Text(
                            "4.9",
                            style: labelStyle17n,
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
    ),
  );
}

Widget itemBranchSelected(Branch item, int index, BuildContext context) {
  return Container(
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
                width: 105,
                height: 105,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: AssetImage(urlImgShop + item.image!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 8,
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    item.name.toString(),
                    style: titleStyle17,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Expanded(
                        flex: 0,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Icon(
                            Icons.location_on_outlined,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        flex: 9,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            item.address.toString(),
                            style: labelStyle15,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  const Row(
                    children: [
                      Icon(Icons.star_border_outlined, size: 20),
                      SizedBox(width: 3),
                      Text(
                        "4.9",
                        style: labelStyle15,
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
  );
}
