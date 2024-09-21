import 'package:booking_haircut_application/data/model/employeemodel.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../../config/const.dart';
import '../../../data/model/selectedCusmodel.dart';

class SelectEmployeeCuswidget extends StatefulWidget {
  final List<Employee> lstEmployee;
  const SelectEmployeeCuswidget({Key? key, required this.lstEmployee})
      : super(key: key);

  @override
  State<SelectEmployeeCuswidget> createState() => SelectServiceCuswidgetState();
}

class SelectServiceCuswidgetState extends State<SelectEmployeeCuswidget> {
  List<Employee> list = [];
  Employee? selectedEmployee = null;

  @override
  Future<void> LoadData() async {
    list = await widget.lstEmployee;
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
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.topCenter,
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
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: BackButton(
                        color: branchColor,
                      ),
                    ),
                    const Text(
                      "Hãy chọn kỹ thuật viên bạn muốn",
                      style: heading3Style,
                    ),
                    const Divider(
                      color: branchColor,
                      height: 10,
                      thickness: 2,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      'THỢ TÓC TIỆM ĐỀ XUẤT',
                      style: titleStyle22,
                      textAlign: TextAlign.start,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return selectEmployeeCus(selectedEmployee, context);
                      },
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      'THỢ TÓC',
                      style: titleStyle22,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    list.isEmpty
                        ? const Text(
                            'Không có nhân viên nào!',
                            style: nullStyle,
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              return selectEmployeeCus(list[index], context);
                            },
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
}

Widget selectEmployeeCus(Employee? item, BuildContext context) {
  final selected = Provider.of<SelectedCusModel>(context);
  return item == null
      ? InkWell(
          onTap: () {
            if (selected.chosen(item)) {
              selected.Choose(item);
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child: Container(
              height: 50,
              width: double.maxFinite,
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text("Tiệm từ đề xuất", style: titleStyle17),
                    const Spacer(),
                    selected.chosen(item)
                        ? const Icon(Icons.radio_button_off)
                        : const Icon(Icons.radio_button_on),
                  ],
                ),
              ),
            ),
          ),
        )
      : InkWell(
          onTap: () {
            if (selected.chosen(item)) {
              selected.Choose(item);
            }
          },
          child: Padding(
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
                              image: AssetImage(urlImgEmp + item!.image!),
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
                                Text(
                                  "Thợ tóc - ${item.nickname}",
                                  style: titleStyle17,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  textAlign: TextAlign.start,
                                ),
                                const Spacer(),
                                const Icon(Icons.star_border_outlined,
                                    size: 24),
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
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  width: 55,
                                  height: 55,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image:
                                          AssetImage(urlImgEmp + item.image!),
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
                                      image:
                                          AssetImage(urlImgEmp + item.image!),
                                      fit: BoxFit.cover,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 0,
                                        blurRadius: 4,
                                        offset: const Offset(0,
                                            4), // Thay đổi vị trí của bóng đổ
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
                                      image:
                                          AssetImage(urlImgEmp + item.image!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                selected.chosen(item)
                                    ? const Icon(Icons.radio_button_off)
                                    : const Icon(Icons.radio_button_on),
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
