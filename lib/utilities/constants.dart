import 'package:cms_mobile/utilities/sizeconfig.dart';
import 'package:cms_mobile/utilities/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final kHintTextStyle = TextStyle(
    color: getCurrentAppTheme() != null ? Colors.white54 : Colors.black54,
  fontFamily: 'OpenSans',
);

final appPrimaryColor = Color(0xFFFFA538);

final kLabelStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final messageLabelStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final userUpdateHeadings = TextStyle(
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
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final loginBoxDecorationStyle = BoxDecoration(
  color: Colors.white12,
  borderRadius: BorderRadius.circular(SizeConfig.aspectRation * 10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black,
      blurRadius: SizeConfig.aspectRation * 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

final loginHintTextStyle = TextStyle(
  color: Colors.white60,
  fontFamily: 'OpenSans',
);

final loginCMSLabelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontStyle: FontStyle.italic,
  fontFamily: 'OpenSans',
);

bool getTheme(BuildContext context){
  return Provider.of<DarkThemeProvider>(context).darkTheme;
}