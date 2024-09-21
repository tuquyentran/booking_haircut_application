import 'package:booking_haircut_application/clientpage/page/branch/branchwidget.dart';
import 'package:booking_haircut_application/config/const.dart';
import 'package:booking_haircut_application/config/list/branch_body.dart';
import 'package:booking_haircut_application/data/model/branchmodel.dart';
import 'package:booking_haircut_application/data/model/customermodel.dart';
import 'package:booking_haircut_application/data/provider/branchprovider.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeCuswidget extends StatefulWidget {
  final Customer customer;

  const HomeCuswidget({Key? key, required this.customer}) : super(key: key);

  @override
  State<HomeCuswidget> createState() => _HomeWidgetState();
}

final imageSlider = [
  'assets/images/slider1.jpg',
  'assets/images/slider2.jpg',
  'assets/images/slider3.jpg',
];

int myCurrentIndex = 0;

class _HomeWidgetState extends State<HomeCuswidget> {
  int _currentPage = 0;
  final List<Widget> pages = const [
    BranchCuswidget(),
  ];

  List<Branch> lstBranch = [];
  String name = '';

  Future<void> loadBracnhList() async {
    lstBranch = (await ReadDataBranch().loadData());
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initializePreferences();
    loadBracnhList();
  }

  Future<void> _initializePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = (prefs.getString('name') ?? widget.customer.name)!;
      print(name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 280,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Xin chào, $name!",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: titleStyle18,
                                  ),
                                ),
                              ],
                            ),
                            const Text(
                              "Mời bạn trải nghiệm các dịch vụ của 4Rau nhé !",
                              style: labelStyle15,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 70.0,
                        height: 70.0,
                        decoration: BoxDecoration(
                          border: Border.all(color: branchColor, width: 2.0),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: widget.customer.image != null
                                ? AssetImage(
                                    'assets/images/${widget.customer.image}')
                                : const AssetImage(
                                    "assets/images/logo4rau_black.jpg"),
                            fit: BoxFit.cover,
                            onError: (exception, stackTrace) =>
                                const AssetImage(
                                    "assets/images/logo4rau_black.jpg"),
                          ),
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
                  const SizedBox(
                    width: double.infinity,
                    child: Text(
                      'LifeStyle',
                      style: titleStyle22,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Column(
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                          autoPlay: true,
                          height: 170,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                          autoPlayInterval: const Duration(seconds: 2),
                          enlargeCenterPage: true,
                          aspectRatio: 2.0,
                          viewportFraction: 1.0,
                          onPageChanged: (index, reason) {
                            setState(() {
                              myCurrentIndex = index;
                            });
                          },
                        ),
                        items: imageSlider
                            .map((item) => Builder(
                                  builder: (BuildContext context) {
                                    return Container(
                                      margin: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            spreadRadius: 1,
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                        image: DecorationImage(
                                          image: AssetImage(item),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  },
                                ))
                            .toList(),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AnimatedSmoothIndicator(
                        activeIndex: myCurrentIndex,
                        count: imageSlider.length,
                        effect: const WormEffect(
                            dotHeight: 8,
                            dotWidth: 8,
                            spacing: 6,
                            dotColor: branchColor60,
                            activeDotColor: branchColor,
                            paintStyle: PaintingStyle.fill),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Chi nhánh cắt tóc',
                        style: titleStyle22,
                        textAlign: TextAlign.start,
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BranchCuswidget(),
                            ),
                          );
                        },
                        child: const Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Xem thêm', style: titleStyle16),
                              SizedBox(
                                width: 2,
                              ),
                              Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 16,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: lstBranch.take(2).length,
                    itemBuilder: (context, index) {
                      return itemBranchView(lstBranch[index], index, context);
                    },
                  ),
                  const SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Đặt lịch cắt tóc ngay',
                          style: titleStyle22,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    height: 120,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/Subtract.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
