import 'package:booking_haircut_application/config/const.dart';
import 'package:flutter/material.dart';

class AboutLicensewidget extends StatefulWidget {
  const AboutLicensewidget({super.key});

  @override
  State<AboutLicensewidget> createState() => _AboutCuswidgetState();
}

class _AboutCuswidgetState extends State<AboutLicensewidget> {
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
                        'Giấy phép',
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
                    "Chúng tôi cấp cho bạn một giấy phép giới hạn, không độc quyền, không thể chuyển nhượng để sử dụng dịch vụ của chúng tôi theo các điều khoản và điều kiện được quy định. Bạn không được sao chép, sửa đổi, phân phối, hoặc tạo ra các sản phẩm phái sinh từ dịch vụ của chúng tôi mà không có sự cho phép bằng văn bản từ chúng tôi. Giấy phép này có thể bị hủy bỏ nếu bạn vi phạm bất kỳ điều khoản nào trong Điều khoản dịch vụ của chúng tôi.",
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
