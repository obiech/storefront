import 'package:flutter/material.dart';
import 'package:storefront_app/constants/dropezy_colors.dart';

const appBarStyle = TextStyle(
  color: DropezyColors.white,
  fontSize: 16,
  fontFamily: 'Montserrat',
  fontWeight: FontWeight.w700,
);

final lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: DropezyColors.black,
  primaryColor: DropezyColors.blue,
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: DropezyColors.blue,
    selectionColor: DropezyColors.blue,
    selectionHandleColor: DropezyColors.blue,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: DropezyColors.black,
    centerTitle: false,
    elevation: 0,
    iconTheme: IconThemeData(
      color: DropezyColors.white,
    ),
    toolbarTextStyle: appBarStyle,
    titleTextStyle: appBarStyle,
  ),
  fontFamily: 'Montserrat',
  iconTheme: const IconThemeData(
    color: DropezyColors.white,
  ),
);
