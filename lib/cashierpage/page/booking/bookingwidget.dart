import 'dart:convert';

import 'package:booking_haircut_application/config/custom_widget.dart';
import 'package:booking_haircut_application/data/model/receiptmodel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../cashierpage/page/booking/select_servicewidget.dart';
import '../../../config/custom_input.dart';
import '../../../config/list/service_body.dart';
import '../../../data/api/sqlite.dart';
import '../../../data/model/customermodel.dart';
import '../../../data/model/employeemodel.dart';

import '../../../cashierpage/page/booking/successwidget.dart';
import '../../../config/list/branch_body.dart';
import '../../../data/model/selectedCashiermodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../config/const.dart';

import 'package:dotted_line/dotted_line.dart';

class BookingWidget extends StatefulWidget {
  const BookingWidget({super.key});

  @override
  State<BookingWidget> createState() => _BookingWidgetState();
}

class _BookingWidgetState extends State<BookingWidget> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _tipController = TextEditingController();
  Customer? customer = Customer(id: 0);
  Employee? _selectedEmployee;
  final NumberFormat _currencyFormat = NumberFormat('###,###.###');
  double _tip = 0;
  // Future<Branch?> _getBranch(int? id) async {
  //   return await _databaseHelper.getBranchById(id);
  // }

  Employee employee = Employee(id: 0);

  // Lấy dữ liệu nhân viên
  getEmployee() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String strEmployee = pref.getString('employee')!;

    if (strEmployee == null) {
      employee = Employee(id: 0);
      print("Không tìm thấy employee");
    } else {
      employee = Employee.fromJson(jsonDecode(strEmployee));
      await loadBranch(employee.branch);
      print("Employee branch ID: ${employee.branch}");
      print("Employee: ${employee.name.toString()}");
    }

    setState(() {});
  }

  Future<void> loadBranch(int? brandID) async {
    final selectedModel =
        Provider.of<SelectedCashierModel>(context, listen: false);

    if (selectedModel.branch == null) {
      await selectedModel.MyBranch(brandID!);
    } else {
      print('Branch: ${selectedModel.branch?.name.toString()}');
    }

    setState(() {});
  }

  // ignore: non_constant_identifier_names
  void UpdateTip(double money) {
    setState(() {
      _tip = money;
      _tipController.text = _currencyFormat.format(_tip);
    });
  }

  void updateTip(String text) {
    if (text.isEmpty) {
      setState(() {
        _tip = 0;
      });
      return;
    }
    final value = _currencyFormat.parse(text.replaceAll(',', ''));
    if (value != null) {
      setState(() {
        _tip = value.toDouble();
      });
    }
  }

  void updateCus() async {
    if (!_phoneController.text.isEmpty) {
      customer = await _getCustomer(_phoneController as String?);
      if (customer?.id == 0) {
        customer = Customer(id: 0);
      }
    }
  }

  Future<Customer?> _getCustomer(String? phone) async {
    return await _databaseHelper.getCustomerByPhone(phone!);
  }

  @override
  void initState() {
    super.initState();
    getEmployee();
    updateCus();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _tipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCashierProvider = Provider.of<SelectedCashierModel>(context);

    Receipt getReceipt() {
      print(customer?.id.toString());
      Receipt receipt = Receipt(
        name: _nameController.text,
        phone: _phoneController.text,
        branch: selectedCashierProvider.branch?.id,
        employee: _selectedEmployee?.id,
        customer: customer?.id,
        total: (selectedCashierProvider.totalPrice + _tip.toDouble()),
        tip: _tip,
        services: selectedCashierProvider.lstSelected,
        dateCreate:
            DateFormat('HH:mm, dd/MM/yyyy').format(DateTime.now()).toString(),
      );
      return receipt;
    }

    print(selectedCashierProvider.lengthBraSer);
    return Scaffold(
      body: selectedCashierProvider.branch == null
          ? LoadingScreen()
          : Stack(
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
                  child: Center(
                    child: SafeArea(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // Tiêu đề
                            const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: BackButton(
                                      color: branchColor,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 6,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Tạo hóa đơn",
                                      style: headingStyle,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(""),
                                ),
                              ],
                            ),
                            // Tiêu đề ------------------End
                            const Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: 250,
                                child: Divider(
                                  color: branchColor,
                                  height: 10,
                                  thickness: 2,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              "Đặt lịch",
                              style: titleStyle22,
                            ),
                            const Text(
                              "Quý khách vui lòng cho biết thông tin",
                              style: subtitleStyle17n,
                            ),
                            const Row(
                              children: [
                                Text(
                                  "(*)",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.red,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Vui lòng nhập thông tin bắt buộc",
                                  style: subtitleStyle17n,
                                ),
                              ],
                            ),
                            // Input
                            const SizedBox(
                              height: 10,
                            ),
                            // Nhập họ và tên
                            SizedBox(
                              height: 50,
                              child: TextFormField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  labelText: "Họ và tên...",
                                  labelStyle: const TextStyle(
                                    color: branchColor80,
                                    fontStyle: FontStyle.italic,
                                  ), // Replace with branchColor
                                  border: myOutlineInputBorder1(),
                                  enabledBorder: myOutlineInputBorder1(),
                                  focusedBorder: myOutlineInputBorder2(),
                                  prefixIcon: const Icon(Icons.person_rounded),
                                ),
                              ),
                            ),
                            // Nhập họ và tên -------------- End
                            const SizedBox(
                              height: 10,
                            ),
                            // Nhập số điện thoại
                            SizedBox(
                              height: 50,
                              child: TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.number,
                                maxLength: 10,
                                decoration: InputDecoration(
                                  labelText: "Số điện thoại...",
                                  labelStyle: const TextStyle(
                                    color: branchColor80,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  border: myOutlineInputBorder1(),
                                  enabledBorder: myOutlineInputBorder1(),
                                  focusedBorder: myOutlineInputBorder2(),
                                  prefixIcon: const Icon(Icons.phone_rounded),
                                  counterText: '',
                                ),
                                // validator: (value) {
                                //   if (value == null) {
                                //     return 'Vui lòng nhập số điện thoại';
                                //   }
                                //   return null;
                                // },
                              ),
                            ),
                            // Nhập số điện thoại -------------- End
                            // Input ------------------End
                            // DOTTED LINE
                            const SizedBox(
                              height: 15,
                            ),
                            // DottedLine
                            const DottedLine(
                              dashColor: branchColor20,
                              dashLength: 5,
                              dashGapLength: 2,
                              dashRadius: 8,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            // DOTTED LINE ------END
                            const Text(
                              "Thông tin dịch vụ",
                              style: titleStyle22,
                            ),
                            MySubtile(
                                "Chọn chi nhánh",
                                "Chọn chi nhánh cắt tóc",
                                Icons.business_rounded),
                            // Chọn chi nhánh ------------End
                            const SizedBox(
                              height: 5,
                            ),
                            // INPUT
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 1,
                              itemBuilder: (context, index) {
                                return itemBranchSelected(
                                    selectedCashierProvider.branch!,
                                    index,
                                    context);
                              },
                            ),
                            // INPUT
                            const SizedBox(
                              height: 5,
                            ),
                            // Yêu cầu kỹ thuật viên
                            MySubtile("Yêu cầu kỹ thuật viên",
                                "Yêu cầu kỹ thuật viên", Icons.person_rounded),
                            // Yêu cầu kỹ thuật viên ------------End
                            const SizedBox(
                              height: 0,
                            ),
                            // INPUT
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Expanded(
                                  flex: 4,
                                  child: Text(
                                    "Kỹ thuật viên",
                                    style: subtitleDetailStyle,
                                  ),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Expanded(
                                  flex: 6,
                                  child: DropdownButtonFormField<Employee>(
                                    icon: const Icon(
                                        Icons.keyboard_arrow_down_rounded),
                                    style: infoDetailStyle,
                                    hint: const Text(
                                      "Chọn kỹ thuật viên",
                                      style: nullStyle,
                                    ),
                                    iconDisabledColor: branchColor,
                                    iconEnabledColor: branchColor60,
                                    dropdownColor: Colors.white,
                                    isExpanded: true,
                                    decoration: const InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: branchColor60),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: branchColor, width: 2),
                                      ),
                                    ),
                                    value: null,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedEmployee = value!;
                                      });
                                    },
                                    items: selectedCashierProvider.lstBranchEmp
                                        .map(
                                          (employee) => DropdownMenuItem(
                                            value: employee,
                                            child: Text(
                                              employee.name.toString(),
                                              // style: nullStyle,
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ],
                            ),
                            // INPUT
                            const SizedBox(
                              height: 15,
                            ),
                            // Chọn dịch vụ
                            MySubtile("Chọn dịch vụ", "Chọn dịch vụ cắt tóc",
                                Icons.add_box_outlined),
                            // Chọn dịch vụ ------------End
                            const SizedBox(
                              height: 5,
                            ),
                            // DottedLine
                            const DottedLine(
                              dashColor: branchColor40,
                              dashLength: 5,
                              dashGapLength: 2,
                              dashRadius: 8,
                              // lineLength: 220,
                            ),
                            // DottedLine ------END
                            const SizedBox(
                              height: 5,
                            ),
                            // LIST
                            // DANH SÁCH DỊCH VỤ
                            Container(
                              decoration: const BoxDecoration(),
                              // Specify the height you need
                              child: selectedCashierProvider.lstSelected.isEmpty
                                  ? const Text(
                                      "Không có dịch vụ nào!",
                                      style: nullStyle,
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: selectedCashierProvider
                                          .lstSelected.length,
                                      itemBuilder: (context, index) {
                                        var service = selectedCashierProvider
                                            .lstSelected[index];
                                        return itemServiceCashierBooking(
                                          service,
                                          context,
                                        );
                                      },
                                    ),
                            ),

                            // DANH SÁCH DỊCH VỤ ----------------End
                            // LIST ------------End
                            const SizedBox(
                              height: 10,
                            ),
                            // Button
                            SizedBox(
                              height: 30,
                              width: double.maxFinite,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SelectWidget(),
                                    ),
                                  );
                                },
                                // ignore: sort_child_properties_last
                                child: const Text(
                                  "Thêm dịch vụ",
                                  style: textButtonStyle17,
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                      color: branchColor), // Viền màu đen
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(8.0), // Bo góc 8
                                  ),
                                ),
                              ),
                            ),
                            // Button ------------End
                            const SizedBox(
                              height: 10,
                            ),
                            // Tổng tiền tạm tính
                            Row(
                              children: [
                                const Text(
                                  "Tổng tiền tạm tính:",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: branchColor80,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.italic),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  NumberFormat('###,###.### đ').format(
                                      selectedCashierProvider.totalPrice),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: branchColor,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                            // Tổng tiền tạm tính ---------- End
                            const SizedBox(
                              height: 15,
                            ),
                            // Tiền tip
                            MySubtile2("Tiền tip", "Tip cho nhân viên",
                                Icons.wallet_rounded),
                            // Tiền tip ------------End
                            const SizedBox(
                              height: 10,
                            ),
                            // Nhập số muốn tip
                            SizedBox(
                              height: 50,
                              child: TextFormField(
                                controller: _tipController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: "Số tiền tip...",
                                  labelStyle: TextStyle(
                                    color: branchColor80,
                                    fontStyle: FontStyle.italic,
                                  ), // Replace with branchColor
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(16.0),
                                    ),
                                    borderSide: BorderSide(
                                        color: branchColor, width: 1),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(16.0),
                                    ),
                                    borderSide: BorderSide(
                                        color: branchColor, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(16.0),
                                    ),
                                    borderSide: BorderSide(
                                        color: branchColor, width: 2),
                                  ),
                                ),
                                onChanged: (value) {
                                  updateTip(value);
                                  if (_tip == 0) {
                                    _tipController.text == null;
                                    return;
                                  } else if (_tip >= 1000000000) {
                                    updateTip("1000000000");
                                  }
                                  _tipController.text =
                                      _currencyFormat.format(_tip);
                                },
                              ),
                            ),
                            // Nhập số muốn tip -------------- End
                            const SizedBox(
                              height: 10,
                            ),
                            // Các nút nhập số tiền
                            Column(
                              children: [
                                Row(
                                  children: [
                                    _buildTipButton(10000),
                                    const SizedBox(width: 3),
                                    _buildTipButton(20000),
                                    const SizedBox(width: 3),
                                    _buildTipButton(30000),
                                  ],
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  children: [
                                    _buildTipButton(40000),
                                    const SizedBox(width: 3),
                                    _buildTipButton(50000),
                                    const SizedBox(width: 3),
                                    _buildTipButton(100000),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(
                                    bottom: 100,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Thanh tạm tính
                Positioned(
                  bottom: 8,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage(urlBarBackground),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(50),
                          blurRadius: 20,
                          spreadRadius: 10,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(16),
                      // border: Border.all(color: branchColor, width: 2.0),
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    margin: const EdgeInsets.all(8),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(16),
                                    ),
                                    border: Border.all(
                                      color: branchColor,
                                      width: 2,
                                    ),
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "${selectedCashierProvider.totalItems}",
                                      style: headingStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                flex: 6,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      NumberFormat('###,###.### đ').format(
                                          selectedCashierProvider.totalPrice +
                                              _tip),
                                      style: totalStyle,
                                    ),
                                    Text(
                                      NumberFormat('###,###.### đ')
                                          .format(_tip),
                                      style: nullStyle,
                                    ),
                                  ],
                                ),
                              ),
                              // const SizedBox(
                              //   width: 50,
                              // ),
                              Expanded(
                                flex: 4,
                                child: FilledButton(
                                  onPressed: () async {
                                    if (_nameController.text.isEmpty ||
                                        _phoneController.text.isEmpty ||
                                        selectedCashierProvider.branch?.id ==
                                            null ||
                                        _selectedEmployee?.id == null ||
                                        (selectedCashierProvider.totalPrice +
                                                _tip) ==
                                            0) {
                                      print("Hãy điền đủ thông tin!");
                                      return; // Ngừng thực hiện nếu điều kiện không đạt
                                    }

                                    Receipt obj = getReceipt();

                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const AlertDialog(
                                          backgroundColor: branchColor20,
                                          title: Text('Thông báo'),
                                          content: SingleChildScrollView(
                                            child: Text(
                                                'Đã thanh toán thành công'),
                                          ),
                                        );
                                      },
                                    );

                                    Receipt? newReceipt = await _databaseHelper
                                        .insertReceipt(obj);
                                    if (newReceipt != null) {
                                      await _databaseHelper
                                          .insertReceiptService(
                                        newReceipt,
                                        selectedCashierProvider.lstSelected,
                                      );
                                    }

                                    await Future.delayed(Duration(seconds: 3));

                                    if (newReceipt != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SuccessWidget(
                                              receipt: newReceipt),
                                        ),
                                      );
                                    } else {
                                      print("Hãy điền đủ thông tin!");
                                    }
                                  },
                                  style: FilledButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    backgroundColor: branchColor,
                                  ),
                                  child: const Text(
                                    "Thanh toán",
                                    style: textButtonStyle17w,
                                    textAlign: TextAlign.center,
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
                // Thanh tạm tính --------------End
              ],
            ),
    );
  }

  Widget _buildTipButton(double money) {
    bool isSelected = _tip == money;

    return Expanded(
      flex: 3,
      child: SizedBox(
        height: 40,
        width: double.maxFinite,
        child: OutlinedButton(
          onPressed: () => UpdateTip(money),
          // ignore: sort_child_properties_last
          child: Text(
            NumberFormat("###,###.###").format(money),
            style: textButtonStyle16.copyWith(
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
          style: OutlinedButton.styleFrom(
            backgroundColor: isSelected ? Colors.black : Colors.transparent,
            side: const BorderSide(color: branchColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
    );
  }
}
