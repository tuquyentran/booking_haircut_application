import 'dart:ffi';

import 'package:booking_haircut_application/config/const.dart';
import 'package:booking_haircut_application/data/model/branchmodel.dart';
// import 'package:booking_haircut_application/data/model/data/branchdata.dart';
import 'package:flutter/material.dart';

import '../../../config/list/branch_body.dart';
import '../../../data/provider/branchprovider.dart';

class BranchCuswidget extends StatefulWidget {
  const BranchCuswidget({super.key});

  @override
  State<BranchCuswidget> createState() => _BranchpageState();
}

class _BranchpageState extends State<BranchCuswidget> {
  List<Branch> listBranch1 = [];
  List<Branch> listBranch2 = [];
  String query = '';
  static const Color _selectedColor = branchColor;
  static const Color _unSelectedColor = branchColor80;

  Color _searchColor = _unSelectedColor;

  FocusNode _searchTFFocusNode = FocusNode();

  Future<void> loadBracnhList() async {
    listBranch1 = await ReadDataBranch().loadData();
    listBranch1.removeWhere((branch) => branch.type == 0);
    listBranch2 = await ReadDataBranch().loadData();
    listBranch2.removeWhere((branch) => branch.type == 1);
    setState(() {});
  }

  void onQueryChanged(String newQuery) {
    setState(() {
      query = newQuery;
    });
  }

  @override
  void initState() {
    super.initState();
    _searchTFFocusNode.addListener(_onSearchTFFocusChange);
    loadBracnhList();
  }

  @override
  void dispose() {
    _searchTFFocusNode.removeListener(_onSearchTFFocusChange);
    _searchTFFocusNode.dispose();
    super.dispose();
  }

  void _onSearchTFFocusChange() {
    setState(() {
      _searchTFFocusNode.hasFocus
          ? _searchColor = _selectedColor
          : _searchColor = _unSelectedColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
          body: Stack(children: <Widget>[
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(urlBackground),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 55, 16, 20),
            child: Center(
              child: Column(
                children: [
                  // Thanh tìm kiếm
                  Container(
                    height: 50,
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
                          borderSide: BorderSide(color: branchColor, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(16.0),
                          ),
                          borderSide: BorderSide(color: branchColor, width: 2),
                        ),
                        prefixIcon: Icon(Icons.search_rounded),
                      ),
                      cursorColor: branchColor,
                    ),
                  ),
                  // Thanh tìm kiếm -------------- End
                  const SizedBox(
                    height: 15,
                  ),
                  const SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'TIỆM TÓC CỦA CHÚ TƯ by 4RAU DELUXE',
                          style: titleStyle22,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                  // ListView branch type 1
                  ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: listBranch1.length,
                    itemBuilder: (context, index) => itemBranchView(
                      listBranch1[index],
                      index,
                      context,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '4RAU BARBER CUTCLUB',
                          style: titleStyle22,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                  // ListView branch type 0
                  ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: listBranch2.length,
                    itemBuilder: (context, index) => itemBranchView(
                      listBranch2[index],
                      index,
                      context,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ])),
    );
  }
}

// Widget itemListView(Branchmodel branchmodel) {
//   return Container(
//     margin: const EdgeInsets.only(bottom: 20),
//     decoration: BoxDecoration(
//       color: branchColor20,
//       borderRadius: BorderRadius.circular(15),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black.withOpacity(0.25),
//           spreadRadius: 2,
//           blurRadius: 1,
//           offset: Offset(0, 1), // Thay đổi vị trí của bóng đổ
//         ),
//       ],
//     ),
//     child: Row(
//       children: [
//         Expanded(
//           flex: 2,
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Container(
//               width: 80,
//               height: 95,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8),
//                 image: DecorationImage(
//                   image: AssetImage(branchmodel.pic),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//           ),
//         ),
//         Expanded(
//           flex: 4,
//           child: SizedBox(
//             width: double.infinity,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.start,
//               mainAxisSize: MainAxisSize.max,
//               children: [
//                 Text(
//                   branchmodel.nameBranch,
//                   style: titleStyle14,
//                   overflow: TextOverflow.ellipsis,
//                   maxLines: 2,
//                   textAlign: TextAlign.start,
//                 ),
//                 const SizedBox(height: 2),
//                 Row(
//                   children: [
//                     const Icon(Icons.location_on_outlined, size: 16),
//                     const SizedBox(width: 3),
//                     Expanded(
//                       child: Text(
//                         branchmodel.address,
//                         style: labelStyle12,
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 2),
//                 Row(
//                   children: [
//                     const Icon(Icons.star_border_outlined, size: 16),
//                     const SizedBox(width: 3),
//                     Text(
//                       branchmodel.star.toString(),
//                       style: labelStyle12,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }
