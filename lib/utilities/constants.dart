import 'package:cms_mobile/utilities/sizeconfig.dart';
import 'package:flutter/material.dart';

final kHintTextStyle = TextStyle(
  color: Colors.black54,
  fontFamily: 'OpenSans',
);

final appPrimaryColor = Color(0xFFFFA538);

final kLabelStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final CMSLabelStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.bold,
  fontStyle: FontStyle.italic,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(
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
