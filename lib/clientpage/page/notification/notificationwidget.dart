import 'package:booking_haircut_application/config/const.dart';
import 'package:flutter/material.dart';

class NoficationCuswidget extends StatefulWidget {
  const NoficationCuswidget({super.key});

  @override
  State<NoficationCuswidget> createState() => _NoticepageState();
}

class _NoticepageState extends State<NoficationCuswidget> {
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
            padding: EdgeInsets.fromLTRB(16, 55, 16, 20),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'THÔNG BÁO',
                        style: titleStyle22,
                      ),
                      SizedBox(height: 5),
                      Divider(
                        thickness: 2,
                        color: branchColor,
                      ),
                      SizedBox(height: 5),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Mới nhất',
                          style: subtitleStyle20,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Trước đó',
                          style: subtitleStyle20,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    ));
  }
}
