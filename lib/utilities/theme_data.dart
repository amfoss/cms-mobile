import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    if (isDarkTheme) {
      return ThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.amber
      );
    } else {
      return ThemeData(
          brightness: Brightness.light,
          accentColor: Colors.amberAccent
      );
    }
  }
}
