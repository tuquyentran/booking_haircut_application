import 'package:booking_haircut_application/config/const.dart';
import 'package:flutter/material.dart';

class AboutPrivacywidget extends StatefulWidget {
  const AboutPrivacywidget({super.key});

  @override
  State<AboutPrivacywidget> createState() => _AboutCuswidgetState();
}

class _AboutCuswidgetState extends State<AboutPrivacywidget> {
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
          const SingleChildScrollView(
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
                        'Chính sách quyền riêng tư',
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
                  Text(
                    "Chính sách quyền riêng tư này giải thích cách chúng tôi thu thập, sử dụng và bảo vệ thông tin cá nhân của bạn. Chúng tôi cam kết bảo mật thông tin của bạn và chỉ sử dụng cho các mục đích hợp pháp như cung cấp dịch vụ, cải thiện trải nghiệm người dùng và tuân thủ các yêu cầu pháp lý. Thông tin của bạn sẽ không được chia sẻ với bên thứ ba nếu không có sự đồng ý của bạn, trừ khi pháp luật yêu cầu.",
                    style: paragraphStyle16,
                    textAlign: TextAlign.justify,
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
