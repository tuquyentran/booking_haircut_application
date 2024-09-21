import 'package:booking_haircut_application/data/model/branchmodel.dart';

import '../data/model/employeemodel.dart';
import 'const.dart';
import 'package:flutter/material.dart';

Widget MyInfo(Employee employee, String? branchName) {
  return Container(
    decoration: const BoxDecoration(),
    child: Column(
      children: [
        // Thông tin nhân viên và chi nhánh
        Row(
          children: [
            SizedBox(
              width: 240,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Xin chào, ${employee.nickname}",
                    style: titleStyle22,
                  ),
                  Text(
                    "Nhân viên thu ngân chi nhánh ${branchName.toString()}",
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
                border: Border.all(color: branchColor, width: 1.0),
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: employee.image != null
                      ? AssetImage(urlImgEmp + employee.image.toString())
                      : const AssetImage("assets/images/logo4rau_black.jpg"),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) =>
                      const AssetImage("assets/images/logo4rau_black.jpg"),
                ),
              ),
            ),
          ],
        ),
        // Thông tin nhân viên và chi nhánh --------------- End
        const Divider(
          color: branchColor,
          height: 30,
          thickness: 2,
        ),
      ],
    ),
  );
}

Widget MySubtile(String text, String subtitle, IconData icon) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text(
            "${text}",
            style: subtitleStyle17n,
          ),
          const SizedBox(
            width: 5,
          ),
          const Text(
            "(*)",
            style: TextStyle(
              fontSize: 16,
              color: Colors.red,
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
      Row(
        children: [
          Icon(icon),
          const SizedBox(
            width: 5,
          ),
          Text(
            "${subtitle}",
            style: subtitleStyle16,
          ),
          const SizedBox(
            width: 8,
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 20,
          ),
        ],
      ),
    ],
  );
}

Widget MySubtile2(String text, String subtitle, IconData icon) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "${text}",
        style: subtitleStyle17n,
        textAlign: TextAlign.left,
      ),
      Row(
        children: [
          Icon(icon),
          const SizedBox(
            width: 5,
          ),
          Text(
            "${subtitle}",
            style: subtitleStyle16,
          ),
          const SizedBox(
            width: 8,
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 20,
          ),
        ],
      ),
    ],
  );
}

Widget MySubtile3(String text, String subtitle, IconData icon,
    BuildContext context, Widget widget) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => widget,
        ),
      );
    },
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "${text}",
              style: subtitleStyle17n,
            ),
            const SizedBox(
              width: 5,
            ),
            const Text(
              "(*)",
              style: TextStyle(
                fontSize: 16,
                color: Colors.red,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Icon(icon),
            const SizedBox(
              width: 5,
            ),
            Text(
              "${subtitle}",
              style: subtitleStyle16,
            ),
            const SizedBox(
              width: 8,
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 20,
            ),
          ],
        ),
      ],
    ),
  );
}

Widget LoadingScreen() {
  return Stack(
    children: [
      Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(urlBackground),
            fit: BoxFit.cover,
          ),
        ),
      ),
      const Center(
        child: CircularProgressIndicator(
          color: branchColor,
          backgroundColor: branchColor20,
        ),
      )
    ],
  );
}
