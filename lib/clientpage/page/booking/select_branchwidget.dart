import 'package:booking_haircut_application/data/model/branchmodel.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../../config/const.dart';
import '../../../data/model/selectedCusmodel.dart';
import '../../../data/provider/branchprovider.dart';

class SelectBranchCuswidget extends StatefulWidget {
  const SelectBranchCuswidget({Key? key}) : super(key: key);

  @override
  State<SelectBranchCuswidget> createState() => SelectServiceCuswidgetState();
}

class SelectServiceCuswidgetState extends State<SelectBranchCuswidget> {
  List<Branch> list = [];
  List<Branch> listClub = [];
  Branch? selectedBranch = null;

  Future<void> LoadData() async {
    list = await ReadDataBranch().loadData();
    list.removeWhere((branch) => branch.type == 0);
    listClub = await ReadDataBranch().loadData();
    listClub.removeWhere((branch) => branch.type == 1);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    LoadData();
  }

  @override
  Widget build(BuildContext context) {
    final selected = Provider.of<SelectedCusModel>(context);
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
                      'TIỆM TÓC CỦA CHÚ TƯ by 4RAU DELUXE',
                      style: titleStyle22,
                      textAlign: TextAlign.start,
                    ),
                    list.isEmpty
                        ? const Text(
                            'Không có chi nhánh nào!',
                            style: nullStyle,
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              return selectBranchCus(list[index], context);
                            },
                          ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      '4RAU BARBER CUTCLUB',
                      style: titleStyle22,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    listClub.isEmpty
                        ? const Text(
                            'Không có chi nhánh nào!',
                            style: nullStyle,
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: listClub.length,
                            itemBuilder: (context, index) {
                              return selectBranchCus(listClub[index], context);
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

Widget selectBranchCus(Branch? item, BuildContext context) {
  final selected = Provider.of<SelectedCusModel>(context);
  return InkWell(
    onTap: () {
      if (!selected.isSelect(item)) {
        selected.Selected(item);
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
                      width: 105,
                      height: 105,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: AssetImage(urlImgShop + item!.image!),
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
                          style: titleStyle18,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Icon(Icons.star_border_outlined, size: 20),
                            const SizedBox(width: 3),
                            const Text(
                              "4.9",
                              style: labelStyle15,
                            ),
                            const Spacer(),
                            !selected.isSelect(item)
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
        )),
  );
}
