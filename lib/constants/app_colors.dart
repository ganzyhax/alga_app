import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xffF2F2F7); // Light / Neutral / Gray 6
  static const Color primary = Color(0xff052DC1);
  static final Color primaryDisabled = Color(0xff052DC1).withOpacity(0.5);
  static const Color blackForText = Color(0xff32384A);
  static const Color grayForText = Color(0xff8E8E93); // Light / Neutral / Gray
  static const Color blockOnTheWhite = Color(0xffE5E5EA73);
  static const Color whiteForText = Color(0xffFFFFFF);
  static final Color choiceColor = Color(0xff052DC126);
  static final Color cardOnTheBlue = Color(0xffE5E5EA4D);
  static final Color cardOnTheBlue2 = Color(0xffE5E5EAB2);
  static final Color onTheBlue2 = Color.fromRGBO(229, 229, 234, 0.70); // ONTHEBLUE2
  static const Color grayProgressBar = Color(0xffE5E5EA); // Light/Neutral/gray5
  static const Color alternativeBlack = Color(0xff1C202C);
  static const Color alternativeGray = Color(0xff6A7186);
  static const Color containerBorder = Color(0xffE8E9EE);
  static const Color calendarTextColor = Color(0xff27272E); // Light/Text/primary
  static const Color slotColor = Color(0xffD1D1D6); // Light/Neutral/gray4
  static const Color exit = Color(0xffD54950);
  static const Color filterGray = Color.fromARGB(30, 142, 142, 147); // Light/Fill/system3
  static const Color actionGreen = Color(0xff17B582); //Light / Text / action
  static const Color actionFill = Color.fromARGB(51, 142, 142, 147);
  static const Color onTheWhite = Color.fromRGBO(229, 229, 234, 0.45); //ONTHEWHITE
  static const Color gray333333 = Color(0xff333333);

  static final LinearGradient gradientPrimary = const LinearGradient(
    colors: [Color(0xff052DC1), Color(0xff052DC1)],
    stops: [0.25, 0.75],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static final LinearGradient gradientWhite = const LinearGradient(
    colors: [Colors.white, Color.fromARGB(255, 71, 68, 68)],
    stops: [0.25, 0.75],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static final LinearGradient gradientGrey = const LinearGradient(
    colors: [Color(0xff9fadb9), Color(0xff9fadb9)],
    stops: [0.25, 0.75],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}