import 'package:booking_haircut_application/data/model/customermodel.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import '../clientpage/page/booking/bookingwidget.dart';
import '../clientpage/page/notification/notificationwidget.dart';
import '../clientpage/page/branch/branchwidget.dart';
import '../clientpage/page/home/homewidget.dart';
import 'page/profile/profilewidget.dart';
import '../config/const.dart';
import 'package:flutter/material.dart';

class MainPageCus extends StatefulWidget {
  final Customer customer;
  MainPageCus({Key? key, required this.customer}) : super(key: key);

  @override
  State<MainPageCus> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MainPageCus> {
  int _currentPage = 0;
  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      HomeCuswidget(customer: widget.customer),
      BranchCuswidget(),
      BookingCuswidget(),
      NoficationCuswidget(),
      ProfileCuswidget(customer: widget.customer),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(),
          CurvedNavigationBar(
            backgroundColor: Colors.white.withOpacity(1),
            buttonBackgroundColor: branchColor,
            color:
                branchColor, // Use branchColor for the navigation bar's background color
            animationDuration: Duration(milliseconds: 300),
            letIndexChange: (int newIndex) {
              if (newIndex == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BookingCuswidget(),
                  ),
                );
                return false;
              } else {
                setState(() {
                  _currentPage = newIndex;
                });
                return true;
              }
            },

            items: const [
              Icon(
                Icons.home_outlined,
                size: 26,
                color: Colors.white,
              ),
              Icon(Icons.store, size: 26, color: Colors.white),
              Icon(Icons.calendar_today_outlined,
                  size: 26, color: Colors.white),
              Icon(Icons.doorbell_rounded, size: 26, color: Colors.white),
              Icon(Icons.person_outline, size: 26, color: Colors.white),
            ],
          ),
        ],
      ),
      body: pages[_currentPage],
    );
  }
}
