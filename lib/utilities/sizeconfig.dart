import 'package:flutter/widgets.dart';

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  double _safeAreaHorizontal;
  double _safeAreaVertical;
  static double widthFactor;
  static double heightFactor;
  static double aspectRation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    widthFactor = (screenWidth - _safeAreaHorizontal) / 360;
    heightFactor = (screenHeight - _safeAreaVertical) / 740;
    aspectRation = widthFactor / heightFactor;
  }
}
