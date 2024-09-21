import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Image -------------------------------------
const urlImgShop = 'assets/images/shop/';
const urlImgEmp = 'assets/images/employees/';
const urlImgHair = 'assets/images/haircut/';
const urlImgCus = 'assets/images/customers/';
const urlBlack_logo = 'assets/images/logo4rau_white.png';
const urlBackground = 'assets/images/Background.png';
const urlBarBackground = 'assets/images/Bar-background.png';
const urlBookingBackground = 'assets/images/tiem-4rau-barbershop-2.png';
const urlSuccess = 'assets/images/success.png';
// Color -------------------------------------
const branchColor = Color(0xFF0C0C0C);
const branchColor80 = Color(0xFF3C3C3C);
const branchColor60 = Color(0xFF6B6B6C);
const branchColor40 = Color(0xFF9B9B9C);
const branchColor20 = Color(0xFFCACACC);
const whiteColor = Color(0xFFFFFFFF);
const starColor = Color(0xFFF98600);
const background = Color.fromARGB(255, 255, 255, 255);
// Font Style ---------------------------------
// Heading
const textStyle45 = TextStyle(
  color: branchColor,
  fontSize: 45,
  height: 1.05,
  fontWeight: FontWeight.bold,
); //

const headingStyle = TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.bold,
  fontFamily: 'Inter',
  color: branchColor,
); //
const heading3Style = TextStyle(
  fontSize: 22,
  fontFamily: 'Inter',
  color: branchColor,
);
// Title
const titleStyle30 = TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.bold,
  fontFamily: 'Inter',
  color: branchColor,
); //

const titleStyle22 = TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.bold,
  fontFamily: 'Inter',
  color: branchColor,
); //

const titleStyle17 = TextStyle(
  fontSize: 17,
  fontWeight: FontWeight.bold,
  fontFamily: 'Inter',
  color: branchColor,
);

const titleStyle18 = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w900,
  fontFamily: 'Inter',
  color: branchColor,
); //

// const titleStyle22 = TextStyle(
//   fontSize: 22,
//   fontWeight: FontWeight.w900,
//   fontFamily: 'Inter',
//   color: branchColor,
// ); //

const errorInput = TextStyle(
  color: Colors.red,
  fontSize: 14,
  fontFamily: 'Inter',
);

const titleStyleDate = TextStyle(
  fontSize: 14,
  fontFamily: 'Inter',
  color: branchColor,
);

const titleStyle20White = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  fontFamily: 'Inter',
  color: whiteColor,
);

const titleStyle16 = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  fontFamily: 'Inter',
  color: branchColor,
); //

// Label
const labelStyle16 = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  fontFamily: 'Inter',
  color: branchColor80,
);

const labelStyle17n = TextStyle(
  fontSize: 17,
  fontFamily: 'Inter',
  color: branchColor80,
);

const labelStyle = TextStyle(
  fontSize: 13,
  fontWeight: FontWeight.normal,
  fontFamily: 'Inter',
  color: branchColor80,
);

const labelStyle15 = TextStyle(
  fontSize: 15,
  fontFamily: 'Inter',
  color: branchColor80,
); //

const labelStyle14White = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.normal,
  fontFamily: 'Inter',
  color: whiteColor,
);

// Subtitle
const subtitleStyle20 = TextStyle(
  fontSize: 20,
  color: branchColor,
  fontFamily: 'Inter',
  fontWeight: FontWeight.bold,
); //

const subtitleStyle20b80 = TextStyle(
  fontSize: 20,
  color: branchColor80,
  fontFamily: 'Inter',
  fontWeight: FontWeight.bold,
); //

const subtitleStyle17 = TextStyle(
  fontSize: 17,
  color: branchColor,
  fontFamily: 'Inter',
  fontWeight: FontWeight.bold,
); //

const subtitleStyle16 = TextStyle(
  fontSize: 16,
  color: branchColor80,
  fontFamily: 'Inter',
  fontWeight: FontWeight.bold,
); //

const subtitleStyle17n = TextStyle(
  fontSize: 16,
  color: branchColor80,
  fontFamily: 'Inter',
); //

const subtitleStyle2 = TextStyle(
  fontSize: 14,
  color: branchColor,
  fontFamily: 'Inter',
  fontWeight: FontWeight.bold,
);
const subtitleStyle3 = TextStyle(
  fontSize: 16,
  color: branchColor60,
  fontWeight: FontWeight.bold,
); //

const subtitleStyle4 = TextStyle(
  fontSize: 16,
  color: branchColor60,
  fontWeight: FontWeight.bold,
);

const paragraphStyle16 = TextStyle(
  fontSize: 16,
  color: branchColor60,
  fontWeight: FontWeight.bold,
); //

const subtitleStyle5 = TextStyle(
  fontSize: 11,
  color: branchColor80,
  fontFamily: 'Inter',
);

// const infoStyle = TextStyle(
//   fontSize: 16,
//   fontFamily: 'Inter',
//   color: branchColor,
// );

// --------------------- For Statistical Widget
const numberStatisticalStyle = TextStyle(
  fontSize: 36,
  color: branchColor,
  fontFamily: 'Inter',
  fontWeight: FontWeight.bold,
);
const textStatisticalStyle = TextStyle(
  fontSize: 20,
  color: branchColor,
  fontFamily: 'Inter',
  fontWeight: FontWeight.w500,
);
// --------------------------------- For Button
const textButtonStyle17w = TextStyle(
  fontSize: 17,
  fontWeight: FontWeight.bold,
  fontFamily: 'Inter',
  color: Colors.white,
); //

const textButtonStyle17 = TextStyle(
  fontSize: 17,
  fontFamily: 'Inter',
  color: branchColor,
  fontWeight: FontWeight.bold,
);
const textButtonStyle2 = TextStyle(
  fontSize: 14,
  color: branchColor,
  fontFamily: 'Inter',
  fontWeight: FontWeight.bold,
);

const textButtonStyle16 = TextStyle(
  fontSize: 16,
  color: branchColor,
  fontFamily: 'Inter',
);

const textButtonStyle4 = TextStyle(
    fontSize: 16,
    fontFamily: 'Inter',
    color: branchColor,
    fontStyle: FontStyle.italic);

const textButtonStyle5 = TextStyle(
  fontSize: 11,
  fontFamily: 'Inter',
  color: branchColor,
  fontWeight: FontWeight.bold,
);
const btnText12 = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.bold,
  fontFamily: 'Inter',
  color: branchColor,
);

const btnText16 = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  fontFamily: 'Inter',
  color: branchColor,
);

const btnText19w = TextStyle(
  fontSize: 19,
  fontWeight: FontWeight.w900,
  fontFamily: 'Inter',
  color: branchColor,
);

const btnTextLogout = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  fontFamily: 'Inter',
  color: Colors.red,
);

// ---------------------- For Bill Detail Widget
const subtitleDetailStyle = TextStyle(
  fontSize: 18,
  color: branchColor,
  fontFamily: 'Inter',
  fontWeight: FontWeight.bold,
); //

const subtitleDetailStyle2 = TextStyle(
  fontSize: 18,
  color: branchColor,
  fontFamily: 'Inter',
);
const infoDetailStyle = TextStyle(
  fontSize: 18,
  fontFamily: 'Inter',
  color: branchColor,
);
const infoDetailStyle3 = TextStyle(
    fontSize: 18,
    fontFamily: 'Inter',
    color: branchColor,
    fontStyle: FontStyle.italic); //
const subtitleTempStyle = TextStyle(
  fontSize: 18,
  fontFamily: 'Inter',
  color: branchColor80,
  fontStyle: FontStyle.italic,
);
const infoTempStyle = TextStyle(
  fontSize: 18,
  fontFamily: 'Inter',
  color: branchColor80,
  fontStyle: FontStyle.italic,
);

// ----------------------------- For List Widget
const infoListStyle = TextStyle(
  fontSize: 15,
  fontFamily: 'Inter',
  color: branchColor,
); //

const infoListStyle2 = TextStyle(
  fontSize: 14,
  fontFamily: 'Inter',
  color: branchColor80,
); //

const infoListStyle3 = TextStyle(
  fontSize: 13,
  fontFamily: 'Inter',
  color: Color(0xFF868686),
);

const serialStyle = TextStyle(
  fontSize: 16,
  fontFamily: 'Inter',
  color: branchColor,
  fontWeight: FontWeight.bold,
);

const serialStyle2 = TextStyle(
  fontSize: 16,
  fontFamily: 'Inter',
  color: branchColor,
);

const nullStyle = TextStyle(
  fontSize: 17,
  fontFamily: 'Inter',
  color: branchColor60,
  fontStyle: FontStyle.italic,
);

const nullStyle2 = TextStyle(
  fontSize: 16,
  fontFamily: 'Inter',
  color: branchColor60,
  fontStyle: FontStyle.italic,
);

const totalItemStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  fontFamily: 'Inter',
  color: branchColor,
);

const totalStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  fontFamily: 'Inter',
  color: branchColor,
);

// ---------------------------- For Admin Widget
//nhutquan
const titleStyleAdmin = TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.bold,
    fontFamily: 'Inter',
    color: Color.fromARGB(255, 255, 255, 255));
const infoStyleNav = TextStyle(
    fontSize: 13,
    fontFamily: 'Inter',
    color: Color.fromARGB(255, 255, 255, 255),
    fontWeight: FontWeight.w400);
const hintText = TextStyle(
  fontFamily: 'Inter',
  fontSize: 14,
  fontWeight: FontWeight.normal,
  color: Color.fromRGBO(202, 202, 204, 100),
);

// const inputStyle = TextStyle(
//   fontSize: 16,
//   color: branchColor,
//   fontWeight: FontWeight.normal,
// );
//---------------for admin services
const infoDetailStyle2 = TextStyle(
  fontSize: 15,
  fontFamily: 'Inter',
  color: Color(0xFF646464),
);

//input
InputDecoration inputAdminStyle({
  String hintText = '',
  Widget? suffixIcon,
}) {
  return InputDecoration(
    isDense: true,
    hintText: hintText,

    suffixIcon: suffixIcon,
    //border: InputBorder.none,
    //border: constBorderSide(color: Colors.blue, width: 1.0),
    contentPadding: EdgeInsets.only(bottom: 3),

    hintStyle: const TextStyle(
      fontSize: 15,
      color: Color(0x9CA0A0A0),
    ),
  );
}

//input
InputDecoration inputAdminStyleAdd({
  String hintText = '',
  Widget? suffixIcon,
}) {
  return InputDecoration(
    isDense: true,
    hintText: hintText,

    suffixIcon: suffixIcon,
    //border: InputBorder.none,
    //border: constBorderSide(color: Colors.blue, width: 1.0),
    contentPadding: EdgeInsets.only(bottom: 10),

    hintStyle: const TextStyle(
      fontSize: 15,
      color: Color(0x9CA0A0A0),
    ),
  );
}

//button
ButtonStyle buttonForServiceStyle() {
  return ElevatedButton.styleFrom(
    backgroundColor: branchColor,
    foregroundColor: Colors.white,
    overlayColor: Color(0xFFCECECE),
    elevation: 15,
    shadowColor: Colors.grey,
    padding: EdgeInsets.symmetric(vertical: 15),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
}
