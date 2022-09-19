import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';

ThemeData lightTheme = ThemeData(
  fontFamily: 'Amiri',
  canvasColor: Colors.transparent,
  primarySwatch: kMainLightColor,
  scaffoldBackgroundColor: kWhiteColor,
  appBarTheme: const AppBarTheme(
    elevation: 0,
    backgroundColor: kWhiteColor,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: kWhiteColor,
      statusBarIconBrightness: Brightness.dark,
    ),
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: 'Amiri',
    ),
  ),
  floatingActionButtonTheme:
      FloatingActionButtonThemeData(backgroundColor: kMainLightColor),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: kMainLightColor,
    unselectedItemColor: kSecondaryLightColor,
    elevation: 20.0,
    backgroundColor: kWhiteColor,
  ),
  textTheme: const TextTheme(
    bodyText1: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.black,
      fontFamily: 'Amiri',
    ),
  ),
);

ThemeData darkTheme = ThemeData(
  primarySwatch: Colors.grey,
  scaffoldBackgroundColor: kMainDarkColor,
  // HexColor('0xFF000073'),
  appBarTheme: const AppBarTheme(
    elevation: 0,
    backgroundColor: kMainDarkColor,
    systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: kMainDarkColor,
        statusBarIconBrightness: Brightness.light),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  // buttonTheme: ButtonThemeData(buttonColor: kBlackColor),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: kMainDarkColor,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: kMainDarkColor,
    unselectedItemColor: kSecondaryDarkColor,
    elevation: 20.0,
    backgroundColor: Colors.grey,
  ),
  textTheme: const TextTheme(
    bodyText1: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  ),
);
