import 'package:cms_mobile/utilities/sizeconfig.dart';
import 'package:cms_mobile/utilities/theme_provider.dart';
import 'package:flutter/material.dart';

final kHintTextStyle = TextStyle(
  color: getCurrentAppTheme() != null ? Colors.white54 : Colors.black54,
  fontFamily: 'OpenSans',
);

final appPrimaryColor = Color(0xFFFFA538);

final kLabelStyle = TextStyle(
  color: getCurrentAppTheme() != null ? Colors.white : Colors.black,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final messageLabelStyle = TextStyle(
  color: getCurrentAppTheme() != null ? Colors.white : Colors.black,
  fontSize: 20,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final userUpdateHeadings = TextStyle(
  color: getCurrentAppTheme() != null ? Colors.white : Colors.black,
  fontSize: 16,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final CMSLabelStyle = TextStyle(
  color: getCurrentAppTheme() != null ? Colors.white : Colors.black,
  fontWeight: FontWeight.bold,
  fontStyle: FontStyle.italic,
  fontFamily: 'OpenSans',
);

final List<String> choices = <String>["Select Date", "Messages List"];

final kBoxDecorationStyle = BoxDecoration(
  color: getCurrentAppTheme() != null ? Colors.white12 : Colors.black12,
  borderRadius: BorderRadius.circular(SizeConfig.aspectRation * 10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.white,
      blurRadius: SizeConfig.aspectRation * 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

Future<bool> getCurrentAppTheme() async {
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
  return await themeChangeProvider.darkThemePreference.getTheme();
}

//Login screen constants

final loginLabelStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final loginBoxDecorationStyle = BoxDecoration(
  color: Colors.black12,
  borderRadius: BorderRadius.circular(SizeConfig.aspectRation * 10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.white,
      blurRadius: SizeConfig.aspectRation * 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

final loginHintTextStyle = TextStyle(
  color: Colors.black54,
  fontFamily: 'OpenSans',
);

final loginCMSLabelStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.bold,
  fontStyle: FontStyle.italic,
  fontFamily: 'OpenSans',
);