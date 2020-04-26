import 'package:cms_mobile/app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/user_database.dart';

void main() {
  runApp(Provider<AppDatabase>(
      create: (BuildContext context) => AppDatabase(),
      child: MaterialApp(
        home: CMS(),
        debugShowCheckedModeBanner: false,
      )));
}