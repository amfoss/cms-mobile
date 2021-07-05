import 'package:cms_mobile/appInit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main()   {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}