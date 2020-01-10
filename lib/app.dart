import 'package:cms_android/screens/home.dart';
import 'package:cms_android/screens/login_screen.dart';
import 'package:flutter/material.dart';

class CMS extends StatefulWidget {
  @override
  _CMS createState() => _CMS();
}

class _CMS extends State<CMS> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      initialRoute: '/login',
      routes: {
        '/login': (BuildContext context) => LoginScreen()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}