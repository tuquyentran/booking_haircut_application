import 'dart:convert';

import 'package:booking_haircut_application/clientpage/page/profile/aboutwidget.dart';
import 'package:booking_haircut_application/clientpage/page/profile/change_infowidget.dart';
import 'package:booking_haircut_application/clientpage/page/profile/history_billwidget.dart';
import 'package:booking_haircut_application/clientpage/page/profile/repasswidget.dart';
import 'package:booking_haircut_application/clientpage/tablayouthistory_cus.dart';
import 'package:booking_haircut_application/config/const.dart';
import 'package:booking_haircut_application/data/model/customermodel.dart';
import 'package:booking_haircut_application/loginwidget.dart';
import 'package:booking_haircut_application/registerwidget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileCuswidget extends StatefulWidget {
  final Customer customer;
  const ProfileCuswidget({Key? key, required this.customer}) : super(key: key);

  @override
  State<ProfileCuswidget> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<ProfileCuswidget> {
  Customer customer = Customer();

  @override
  Widget build(BuildContext context) {
    Future<bool> saveCustomer(Customer obj) async {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String strCustomer = jsonEncode(obj);
        prefs.setString('customer', strCustomer);
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
          body: Stack(
        children: <Widget>[
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
                    Row(
                      children: [
                        Container(
                          width: 70.0,
                          height: 70.0,
                          decoration: BoxDecoration(
                            border: Border.all(color: branchColor, width: 2.0),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: widget.customer.image == null
                                  ? AssetImage(
                                      urlImgCus + widget.customer.image!)
                                  : const AssetImage(
                                      "assets/images/logo4rau_black.jpg"),
                              fit: BoxFit.cover,
                              onError: (exception, stackTrace) =>
                                  const AssetImage(
                                      "assets/images/logo4rau_black.jpg"),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${widget.customer.name}",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: titleStyle18,
                              ),
                              Text(
                                "+${widget.customer.phone}",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: subtitleStyle3,
                              ),
                              Text(
                                "${widget.customer.email}",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: subtitleStyle3,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      thickness: 1,
                      color: Colors.black,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Ngày tạo tài khoản: 18:47, 28/01/2024",
                              style: subtitleStyle3,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          children: [
                            Text(
                              "Phiên bản: 1.1.1.1",
                              style: subtitleStyle3,
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 30),
                    Column(
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChangeInfoCuswidget(
                                        customer: widget.customer),
                                  ),
                                );
                              },
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.edit_note_rounded,
                                    size: 30,
                                  ),
                                  SizedBox(width: 20),
                                  Text(
                                    "Thay đổi thông tin người dùng",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: btnText16,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                var obj = widget.customer;
                                if (await saveCustomer(obj) == true) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TabBarHistory(
                                          customer: widget.customer),
                                    ),
                                  );
                                }
                              },
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.calendar_month_outlined,
                                    size: 30,
                                  ),
                                  SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Lịch sử đơn đặt",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: btnText16,
                                      ),
                                      SizedBox(
                                        width: 200,
                                        child: Text(
                                          "Lịch sử đơn đặt, lịch sử đơn đã thanh toán",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                          style: subtitleStyle3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RepassCuswidget(
                                      customer: widget.customer,
                                    ),
                                  ),
                                );
                              },
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.edit_outlined,
                                    size: 30,
                                  ),
                                  SizedBox(width: 20),
                                  Text(
                                    "Đổi mật khẩu",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: btnText16,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AboutCuswidget(),
                                  ),
                                );
                              },
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    size: 30,
                                  ),
                                  SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Thông tin về chúng tôi",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: btnText16,
                                      ),
                                      SizedBox(
                                        width: 200,
                                        child: Text(
                                          "Chính sách quyền riêng tư, Điều khoản dịch vụ, Giấy phép",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                          style: subtitleStyle3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginWidget(),
                                  ),
                                );
                              },
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.logout_outlined,
                                    size: 30,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 20),
                                  Text(
                                    "Đăng xuất",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: btnTextLogout,
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
