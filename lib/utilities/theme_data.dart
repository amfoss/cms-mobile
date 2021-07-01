import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    if (isDarkTheme) {
      return ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xffffa635),
        accentColor: Colors.amber[300],
      );
    } else {
      return ThemeData(
          brightness: Brightness.light,
          primaryColor: Color(0xffffa635),
          accentColor: Colors.amber[300],
      );
    }
  }
}
