import 'package:booking_haircut_application/config/const.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageZoomScreen extends StatelessWidget {
  final String? imagePath;

  const ImageZoomScreen({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Zoom Image',
          style: headingStyle,
          textAlign: TextAlign.center,
        ),
        flexibleSpace: const Image(
          image: AssetImage('assets/images/background_register.png'),
          fit: BoxFit.cover,
        ),
        backgroundColor: Colors.transparent,
      ),
      body: PhotoView(
        backgroundDecoration: const BoxDecoration(
          color: branchColor,
          // image: DecorationImage(
          //   image: AssetImage('assets/images/Background.png'),
          //   fit: BoxFit.cover,
          // ),
        ),
        imageProvider: AssetImage(imagePath!),
      ),
    );
  }
}
