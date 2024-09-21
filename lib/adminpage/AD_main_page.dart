import 'package:booking_haircut_application/adminpage/page/statistical/statisticalwidget.dart';
import 'package:flutter/material.dart';
import 'package:booking_haircut_application/config/const.dart';
import '../adminpage/page/branch/branchwidget.dart';
import '../adminpage/page/employee/employeewidget.dart';
import '../loginwidget.dart';
import 'page/bill/receiptwidget.dart';
import '../adminpage/page/order/orderwidget.dart';
import '../adminpage/page/customer/customerwidget.dart';
import '../adminpage/page/service/servicewidget.dart';

class ADMainPage extends StatefulWidget {
  const ADMainPage({Key? key}) : super(key: key);

  @override
  State<ADMainPage> createState() => _ADMainPageState();
}

class _ADMainPageState extends State<ADMainPage> {
  int _selectedIndex = 0;
  static const List<String> drawerTitles = [
    "Thống kê",
    "Quản lý chi nhánh",
    "Quản lý nhân viên",
    "Quản lý hóa đơn",
    "Quản lý đơn đặt",
    "Quản lý khách hàng",
    "Quản lý dịch vụ",
    "Đăng xuất"
  ];
  static const List<Widget> _widgetOptions = <Widget>[
    Statisticalwidget(),
    Branchwidget(),
    Employeewidget(),
    BillWidget(),
    OrderWidget(),
    Customerwidget(),
    Servicewidget(),
    LoginWidget(),
  ];

  static const List<IconData> drawerIcons = [
    Icons.line_axis_rounded,
    Icons.store_mall_directory,
    Icons.group_outlined,
    Icons.receipt_long_outlined,
    Icons.receipt_outlined,
    Icons.person_2_outlined,
    Icons.star_border,
    Icons.logout_rounded
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          drawerTitles[_selectedIndex],
          style: titleStyleAdmin,
        ),
        backgroundColor: branchColor,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              color: Colors.white,
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 330,
              child: DrawerHeader(
                decoration: const BoxDecoration(color: branchColor),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(urlBlack_logo),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10)),
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                          child: ClipOval(
                            child: Image.network(
                              'https://i.pinimg.com/564x/1c/6f/2f/1c6f2ffdf7f4cbad59a29d7408d8c630.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 25),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Xin chào, Admin',
                              style: titleStyleAdmin,
                            ),
                            Text(
                              'admin@gmail.com',
                              style: infoStyleNav,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text('Hệ thống quản lý 4RAU',
                            style: titleStyleAdmin),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ...drawerTitles.asMap().entries.map((entry) {
              final index = entry.key;
              final title = entry.value;
              final icon = drawerIcons[index];
              return ListTile(
                leading: Icon(icon),
                title: Text(title),
                selected: _selectedIndex == index,
                onTap: () {
                  _onItemTapped(index);
                  Navigator.pop(context);
                },
              );
            }).toList(),
            // const ListTile(
            //   leading: Icon(Icons.logout_rounded, color: Colors.red),
            //   title:
            //       const Text('Đăng xuất', style: TextStyle(color: Colors.red)),
            // onTap: () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => const LoginWidget()),
            //   );
            // },
            // ),
          ],
        ),
      ),
    );
  }
}
