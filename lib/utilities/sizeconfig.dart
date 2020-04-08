import 'package:flutter/widgets.dart';

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  double _screenWidth;
  double _screenHeight;
  double _safeAreaHorizontal;
  double _safeAreaVertical;
  static double widthFactor;
  static double heightFactor;
  static double aspectRation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    _screenWidth = _mediaQueryData.size.width;
    _screenHeight = _mediaQueryData.size.height;
    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    widthFactor = (_screenWidth - _safeAreaHorizontal) / 360;
    heightFactor = (_screenHeight - _safeAreaVertical) / 740;
    aspectRation = widthFactor / heightFactor;
  }
}
