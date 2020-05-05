import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    if (isDarkTheme) {
      return ThemeData.dark();
    } else {
      return ThemeData.light();
    }
  }
}
