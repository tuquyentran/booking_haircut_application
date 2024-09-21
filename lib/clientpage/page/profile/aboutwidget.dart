import 'package:booking_haircut_application/clientpage/page/profile/about_licensewidget.dart';
import 'package:booking_haircut_application/clientpage/page/profile/about_privacywidget.dart';
import 'package:booking_haircut_application/clientpage/page/profile/about_termswidget.dart';
import 'package:booking_haircut_application/config/const.dart';
import 'package:flutter/material.dart';

class AboutCuswidget extends StatefulWidget {
  const AboutCuswidget({super.key});

  @override
  State<AboutCuswidget> createState() => _AboutCuswidgetState();
}

class _AboutCuswidgetState extends State<AboutCuswidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              padding: const EdgeInsets.fromLTRB(16, 50, 16, 20),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      BackButton(
                        color: branchColor,
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Thông tin về chúng tôi',
                        style: titleStyle22,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Divider(
                    thickness: 2,
                    color: branchColor,
                  ),
                  const SizedBox(height: 5),
                  Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AboutPrivacywidget(),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Text(
                                  "Chính sách về quyền riêng tư",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: btnText16,
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_right_outlined,
                                  size: 25,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AboutTermswidget(),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Text(
                                  "Điều khoản dịch vụ",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: btnText16,
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_right_outlined,
                                  size: 25,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AboutLicensewidget(),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Text(
                                  "Giấy phép",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: btnText16,
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_right_outlined,
                                  size: 25,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
