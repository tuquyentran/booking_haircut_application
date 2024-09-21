import 'package:booking_haircut_application/config/const.dart';
import 'package:flutter/material.dart';

class AboutTermswidget extends StatefulWidget {
  const AboutTermswidget({super.key});

  @override
  State<AboutTermswidget> createState() => _AboutCuswidgetState();
}

class _AboutCuswidgetState extends State<AboutTermswidget> {
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
                        'Điều khoản dịch vụ',
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
                    "Bằng việc sử dụng dịch vụ của chúng tôi, bạn đồng ý tuân thủ các điều khoản và điều kiện sau đây. Bạn phải sử dụng dịch vụ một cách hợp pháp và không vi phạm quyền lợi của người khác. Chúng tôi có quyền thay đổi hoặc ngừng cung cấp dịch vụ mà không cần thông báo trước. Bạn chịu trách nhiệm bảo vệ thông tin tài khoản của mình và thông báo ngay cho chúng tôi nếu có bất kỳ vi phạm an ninh nào.",
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
