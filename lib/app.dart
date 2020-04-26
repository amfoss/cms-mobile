import 'package:cms_mobile/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import 'data/user_database.dart';
import 'screens/home.dart';

class CMS extends StatefulWidget {
  @override
  _CMS createState() => _CMS();
}

class _CMS extends State<CMS> {
  Link link;
  String username;
  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context, listen: false);
    return FutureBuilder(
      future: db.getSingleUser(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Container(color: Colors.white);
        else if (snapshot.data == null)
          return LoginScreen();
        else if (snapshot.hasData) {
          final httpLink = HttpLink(
            uri: 'https://api.amfoss.in/',
          );
          String token = snapshot.data.authToken;
          final AuthLink authLink = AuthLink(
            getToken: () async => 'JWT $token',
          );
          link = authLink.concat(httpLink);
          username = snapshot.data.username;
          return HomePage(
            username: username,
            url: link,
          );
        } else
          return Container(color: Colors.white,);
      },
    );
  }
}
