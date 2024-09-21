import 'dart:convert';
import 'dart:developer';
import 'dart:ui';
import 'package:booking_haircut_application/clientpage/page/booking/select_servicewidget.dart';
import 'package:booking_haircut_application/clientpage/page/booking/successwidget.dart';
import 'package:booking_haircut_application/config/const.dart';
import 'package:booking_haircut_application/config/custom_input.dart';
import 'package:booking_haircut_application/config/list/branch_body.dart';
import 'package:booking_haircut_application/data/model/branchmodel.dart';
import 'package:booking_haircut_application/data/model/ordermodel.dart';
import 'package:booking_haircut_application/data/provider/branchprovider.dart';
import 'package:booking_haircut_application/loginwidget.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/custom_widget.dart';
import '../../../config/list/service_body.dart';
import '../../../config/photo_view.dart';
import '../../../data/model/employeemodel.dart';
import '../../../data/model/selectedCusmodel.dart';
import '../../../data/model/servicemodel.dart';
import 'package:intl/intl.dart';

import 'select_branchwidget.dart';
import 'select_employeewidget.dart';

class BookingCuswidget extends StatefulWidget {
  const BookingCuswidget({Key? key}) : super(key: key);

  @override
  State<BookingCuswidget> createState() => _BookingCuswidgetState();
}

class _BookingCuswidgetState extends State<BookingCuswidget> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _noteController = TextEditingController();
  String? _nameError;
  String? _phoneError;
  // final NumberFormat _currencyFormat = NumberFormat('###,###.###');
  String selectedDate = '';

  DateTime today =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  Color _emailTFColor = branchColor80;

  final FocusNode _emailTFFocusNode = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> loadBranch() async {
    final selectedModel = Provider.of<SelectedCusModel>(context, listen: false);

    if (selectedModel.branch == null) {
      await selectedModel.FirstBranch(); // Await the async function
    } else {
      print('Branch not found');
      // Handle case where branch is not found
    }

    setState(() {});
  }

  void _onEmailTFFocusChange() {
    setState(() {
      _emailTFFocusNode.hasFocus
          ? _emailTFColor = branchColor
          : _emailTFColor = branchColor80;
    });
  }

  @override
  void initState() {
    super.initState();
    _emailTFFocusNode.addListener(_onEmailTFFocusChange);
    loadBranch();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _noteController.dispose();

    _emailTFFocusNode.removeListener(_onEmailTFFocusChange);
    _emailTFFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedProvider = Provider.of<SelectedCusModel>(context);

    Order getReceipt() {
      Order order = Order(
        id: 69,
        name: _nameController.text,
        phone: _phoneController.text,
        branch: SelectedCusModel().branch?.id,
        employee: SelectedCusModel().employee?.id,
        total: selectedProvider.totalPrice.toDouble(),
        time: selectedTime,
        date: selectedDate,
        note: _noteController.text,
        services: selectedProvider.lstSelected,
      );
      return order;
    }

    Future<bool> saveOrder(Order obj) async {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String strOrder = jsonEncode(obj);
        prefs.setString('order', strOrder);
        return true;
      } catch (e) {
        print(e);
        return false;
      }
    }

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        body: selectedProvider.branch == null
            ? const Center(
                child: CircularProgressIndicator(
                  color: branchColor,
                ),
              )
            : Stack(
                children: <Widget>[
                  Image.asset(
                    urlBookingBackground,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: SafeArea(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: BackButton(
                          color: whiteColor,
                        ),
                      ),
                    ),
                  ),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: IntrinsicHeight(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 220),
                            child: Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(urlBackground),
                                        fit: BoxFit.cover),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(28),
                                      topRight: Radius.circular(28),
                                    ),
                                  ),
                                ),
                                SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(13),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: branchColor,
                                          borderRadius:
                                              BorderRadius.circular(28),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              spreadRadius: 0,
                                              blurRadius: 4,
                                              offset: const Offset(0, 4),
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
                                                  padding:
                                                      const EdgeInsets.all(7.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              const ImageZoomScreen(
                                                            imagePath:
                                                                'assets/images/timeWork.jpeg',
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      width: 105,
                                                      height: 105,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16),
                                                        image:
                                                            const DecorationImage(
                                                          image: AssetImage(
                                                              "assets/images/timeWork.jpeg"),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const Expanded(
                                              flex: 8,
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 7, 0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Lịch hoạt động',
                                                        style:
                                                            titleStyle20White,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                      SizedBox(height: 2),
                                                      Row(
                                                        children: [
                                                          SizedBox(width: 3),
                                                          Expanded(
                                                            flex: 1,
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Text(
                                                                'Working Hours/ Giờ Làm Việc: 10am - 7:30pm (everyday) Except Wednesday / Riêng Thứ 4: 10am - 4pm',
                                                                style:
                                                                    labelStyle14White,
                                                                maxLines: 5,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
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
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 0, 16, 10),
                                        child: Center(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
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
                                                      fontSize: 16,
                                                      color: Colors.red,
                                                      fontStyle:
                                                          FontStyle.italic,
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
                                              const SizedBox(height: 10),
                                              Form(
                                                key: _formKey,
                                                child: Column(
                                                  children: [
                                                    TextFormField(
                                                      controller:
                                                          _nameController,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText:
                                                            "Họ và tên...",
                                                        labelStyle:
                                                            const TextStyle(
                                                          color: branchColor80,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ), // Replace with branchColor
                                                        border:
                                                            myOutlineInputBorder3(),
                                                        enabledBorder:
                                                            myOutlineInputBorder1(),
                                                        focusedBorder:
                                                            myOutlineInputBorder3(),
                                                        prefixIcon: const Icon(
                                                            Icons
                                                                .person_rounded),
                                                      ),
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'Vui lòng nhập họ tên';
                                                        }

                                                        return null;
                                                      },
                                                      onChanged: (value) {
                                                        setState(() {
                                                          _nameError = null;
                                                        });
                                                      },
                                                    ),
                                                    if (_nameError != null)
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 5),
                                                        child: Text(
                                                          _nameError!,
                                                          style: errorInput,
                                                        ),
                                                      ),
                                                    const SizedBox(height: 10),
                                                    TextFormField(
                                                      controller:
                                                          _phoneController,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      maxLength: 10,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText:
                                                            "Số điện thoại...",
                                                        labelStyle:
                                                            const TextStyle(
                                                          color: branchColor80,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ), // Replace with branchColor
                                                        border:
                                                            myOutlineInputBorder3(),
                                                        enabledBorder:
                                                            myOutlineInputBorder1(),
                                                        focusedBorder:
                                                            myOutlineInputBorder3(),
                                                        prefixIcon: const Icon(
                                                            Icons
                                                                .phone_rounded),
                                                        counterText: '',
                                                      ),
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'Vui lòng nhập số điện thoại';
                                                        }

                                                        return null;
                                                      },
                                                      onChanged: (value) {
                                                        setState(() {
                                                          _phoneError = null;
                                                        });
                                                      },
                                                    ),
                                                    if (_phoneError != null)
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 5),
                                                        child: Text(
                                                          _phoneError!,
                                                          style: errorInput,
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),

                                              const SizedBox(
                                                height: 15,
                                              ),
                                              const Text(
                                                "Thông tin dịch vụ",
                                                style: titleStyle22,
                                              ),
                                              // Chọn chi nhánh
                                              MySubtile3(
                                                "Chọn chi nhánh",
                                                "Chọn chi nhánh cắt tóc",
                                                Icons.business_rounded,
                                                context,
                                                SelectBranchCuswidget(),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              // INPUT
                                              ShrinkWrappingViewport(
                                                offset: ViewportOffset.zero(),
                                                slivers: <Widget>[
                                                  SliverList(
                                                    delegate:
                                                        SliverChildBuilderDelegate(
                                                      (BuildContext context,
                                                          int index) {
                                                        return selectBranchCus(
                                                            selectedProvider
                                                                .branch,
                                                            context);
                                                      },
                                                      childCount:
                                                          1, // Số lượng item là 1
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              MySubtile3(
                                                "Yêu cầu kỹ thuật viên",
                                                "Chọn thợ cắt tóc",
                                                Icons.person_rounded,
                                                context,
                                                SelectEmployeeCuswidget(
                                                    lstEmployee:
                                                        selectedProvider
                                                            .lstBranchEmp),
                                              ),
                                              // Yêu cầu kỹ thuật viên ------------End
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              // INPUT
                                              ShrinkWrappingViewport(
                                                offset: ViewportOffset.zero(),
                                                slivers: <Widget>[
                                                  SliverList(
                                                    delegate:
                                                        SliverChildBuilderDelegate(
                                                      (BuildContext context,
                                                          int index) {
                                                        return selectEmployeeCus(
                                                            selectedProvider
                                                                .employee,
                                                            context);
                                                      },
                                                      childCount:
                                                          1, // Số lượng item là 1
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // INPUT
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              MySubtile(
                                                  "Dịch vụ",
                                                  "Chọn dịch vụ cắt tóc",
                                                  Icons.add_box_outlined),
                                              const SizedBox(
                                                height: 5,
                                              ),
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
                                              // LIST

                                              // DANH SÁCH DỊCH VỤ
                                              Container(
                                                child:
                                                    Consumer<SelectedCusModel>(
                                                  builder: (context, value,
                                                          child) =>
                                                      value.lstSelected.isEmpty
                                                          ? const Text(
                                                              "Không có dịch vụ nào!",
                                                              style: nullStyle)
                                                          : ListView.builder(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          5),
                                                              shrinkWrap: true,
                                                              physics:
                                                                  const NeverScrollableScrollPhysics(),
                                                              itemCount: value
                                                                  .lstSelected
                                                                  .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                var service =
                                                                    value.lstSelected[
                                                                        index];
                                                                return itemServiceCusBooking(
                                                                    service,
                                                                    context);
                                                              },
                                                            ),
                                                ),
                                              ),

                                              // DANH SÁCH DỊCH VỤ ----------------End
                                              // LIST ------------End
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              SizedBox(
                                                height: 30,
                                                width: double.maxFinite,
                                                child: OutlinedButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              SelectServiceCuswidget()),
                                                    );
                                                  },
                                                  // ignore: sort_child_properties_last
                                                  child: const Text(
                                                    "Thêm dịch vụ",
                                                    style: textButtonStyle17,
                                                  ),
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    side: const BorderSide(
                                                        color:
                                                            branchColor), // Viền màu đen
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0), // Bo góc 8
                                                    ),
                                                    // elevation: 4.0, // Đổ bóng
                                                    // shadowColor:
                                                    //     Colors.black.withOpacity(0.1), // Màu đổ bóng
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              MySubtile(
                                                  "Ngày đặt lịch",
                                                  "Chọn thời điểm cắt",
                                                  Icons
                                                      .calendar_today_outlined),
                                              EasyDateTimeLine(
                                                initialDate: today,
                                                locale: "vi",
                                                onDateChange: (myDate) {
                                                  var formatter =
                                                      DateFormat('dd-MM-yyyy');
                                                  String formattedDate =
                                                      formatter.format(myDate);
                                                  if (!check(myDate)) {
                                                    ShowDialog(context);
                                                  } else {
                                                    setState(() {
                                                      today = myDate;
                                                      selectedDate =
                                                          myDate.toString();
                                                    });

                                                    print(
                                                        'Ngày đã chọn: $formattedDate');
                                                  }
                                                },
                                                headerProps:
                                                    const EasyHeaderProps(
                                                  monthPickerType:
                                                      MonthPickerType.switcher,
                                                  dateFormatter: DateFormatter
                                                      .fullDateDMY(),
                                                ),
                                                dayProps: EasyDayProps(
                                                  todayHighlightColor:
                                                      branchColor,
                                                  todayHighlightStyle:
                                                      TodayHighlightStyle
                                                          .withBorder,
                                                  height: 50,
                                                  width: 52,
                                                  dayStructure:
                                                      DayStructure.dayStrDayNum,
                                                  activeDayStyle:
                                                      const DayStyle(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  8)),
                                                      color: branchColor,
                                                    ),
                                                    dayStrStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  inactiveDayStyle: DayStyle(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  8)),
                                                      border: Border.all(
                                                          width: 2,
                                                          color: branchColor),
                                                      color: Colors
                                                          .transparent, // Màu trong suốt cho ngày không thể chọn
                                                    ),
                                                    dayStrStyle:
                                                        const TextStyle(
                                                      color: branchColor,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                                itemBuilder: (context,
                                                    dayNumber,
                                                    dayName,
                                                    monthName,
                                                    fullDate,
                                                    isSelected) {
                                                  bool isPastDate = fullDate
                                                      .isBefore(DateTime.now()
                                                          .subtract(
                                                              const Duration(
                                                                  days: 1)));

                                                  return Visibility(
                                                    visible: !isPastDate,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    8)),
                                                        color: isSelected
                                                            ? Colors.black
                                                            : Colors
                                                                .transparent,
                                                        border: Border.all(
                                                          color: branchColor,
                                                          width: isSelected
                                                              ? 0
                                                              : 2,
                                                        ),
                                                      ),
                                                      width: 52,
                                                      height: 50,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            dayName,
                                                            style: TextStyle(
                                                              color: isSelected
                                                                  ? Colors.white
                                                                  : branchColor,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Text(
                                                            dayNumber
                                                                .toString(),
                                                            style: TextStyle(
                                                              color: isSelected
                                                                  ? Colors.white
                                                                  : branchColor,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                              const SizedBox(height: 15),
                                              MySubtile(
                                                  "Chọn thời gian",
                                                  "Chọn khung giờ dịch vụ",
                                                  Icons.alarm_rounded),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Column(
                                                children: [
                                                  // 10,000 - 30,000
                                                  Row(
                                                    children: [
                                                      _buildTimeButton("10:00"),
                                                      const SizedBox(width: 4),
                                                      _buildTimeButton("10:30"),
                                                      const SizedBox(width: 4),
                                                      _buildTimeButton("11:00"),
                                                      const SizedBox(width: 4),
                                                      _buildTimeButton("11:30"),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      _buildTimeButton("12:00"),
                                                      const SizedBox(width: 4),
                                                      _buildTimeButton("12:30"),
                                                      const SizedBox(width: 4),
                                                      _buildTimeButton("13:00"),
                                                      const SizedBox(width: 4),
                                                      _buildTimeButton("13:30"),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      _buildTimeButton("14:00"),
                                                      const SizedBox(width: 4),
                                                      _buildTimeButton("14:30"),
                                                      const SizedBox(width: 4),
                                                      _buildTimeButton("15:00"),
                                                      const SizedBox(width: 4),
                                                      _buildTimeButton("15:30"),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      _buildTimeButton("16:00"),
                                                      const SizedBox(width: 4),
                                                      _buildTimeButton("16:30"),
                                                      const SizedBox(width: 4),
                                                      _buildTimeButton("17:00"),
                                                      const SizedBox(width: 4),
                                                      _buildTimeButton("17:30"),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      _buildTimeButton("18:00"),
                                                      const SizedBox(width: 4),
                                                      _buildTimeButton("18:30"),
                                                      const SizedBox(width: 4),
                                                      _buildTimeButton("19:00"),
                                                      const SizedBox(width: 4),
                                                      _buildTimeButton("19:30"),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  const Row(
                                                    children: [
                                                      Icon(Icons.chat_outlined),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        "Ghi chú",
                                                        style: subtitleStyle16,
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  SizedBox(
                                                    height: 80,
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 12),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  branchColor),
                                                          color: branchColor20,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8)),
                                                      child: TextFormField(
                                                        controller:
                                                            _noteController,
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                        ),
                                                        focusNode:
                                                            _emailTFFocusNode,
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              'Ghi chú...',
                                                          hintStyle: TextStyle(
                                                            color:
                                                                _emailTFColor,
                                                            fontSize: 13,
                                                          ),
                                                          border:
                                                              InputBorder.none,
                                                        ),
                                                      ),
                                                    ),
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
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
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
                                        "${selectedProvider.totalItems}",
                                        style: totalItemStyle,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        NumberFormat('###,###.### đ').format(
                                            selectedProvider.totalPrice),
                                        style: totalStyle,
                                      ),
                                      Text(
                                        "${selectedProvider.totalTimes} phút",
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
                                      if (_formKey.currentState!.validate()) {
                                        Order obj = getReceipt();

                                        if (await saveOrder(obj) == true) {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return const AlertDialog(
                                                  backgroundColor:
                                                      branchColor20,
                                                  title: Text('Thông báo'),
                                                  content:
                                                      SingleChildScrollView(
                                                    child: Text(
                                                        'Đã thanh toán thành công'),
                                                  ),
                                                );
                                              });
                                          await Future.delayed(
                                              Duration(seconds: 3));
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SuccessCuswidget()),
                                          );
                                        }
                                      }
                                    },
                                    style: FilledButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      backgroundColor: branchColor,
                                    ),
                                    child: const Text(
                                      "Đặt đơn",
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
      ),
    );
  }

  String? selectedTime;

  void _selectTime(String time) {
    setState(() {
      selectedTime = time;
    });
  }

  void ShowDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: whiteColor,
        title: const Text("Không thể chọn ngày trong quá khứ"),
        content: const Text("Vui lòng chọn ngày từ hôm nay trở đi."),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: branchColor),
            onPressed: () {
              Navigator.of(context).pop(); // Đóng dialog
            },
            child: const Text("Đã hiểu"),
          ),
        ],
      ),
    );
  }

  DateTime get30AfterDay() {
    return DateTime(
        DateTime.now().year, DateTime.now().month + 1, DateTime.now().day);
  }

  bool check(DateTime selectedDate) {
    DateTime today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    // Lấy ngày giờ hiện tại
    var formatter = DateFormat('dd-MM-yyyy');
    print(formatter); // Định dạng ngày tháng
    String formattedDate = formatter.format(today);
    if (selectedDate.isBefore(today)) {
      return false;
    }
    return true;
  }

  Widget _buildTimeButton(String time) {
    bool isSelected = selectedTime == time;

    return Expanded(
      child: SizedBox(
        height: 40,
        width: double.maxFinite,
        child: OutlinedButton(
          onPressed: () {
            _selectTime(time);
          },
          style: OutlinedButton.styleFrom(
            backgroundColor: isSelected ? Colors.black : Colors.transparent,
            side: const BorderSide(color: branchColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text(
            time,
            style: textButtonStyle16.copyWith(
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
