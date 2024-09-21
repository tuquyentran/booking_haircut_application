import 'package:flutter/material.dart';

class Noticepage extends StatefulWidget {
  const Noticepage({super.key});

  @override
  State<Noticepage> createState() => _NoticepageState();
}

class _NoticepageState extends State<Noticepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'notice page',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
