import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _Profile createState() => _Profile();
}

class _Profile extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 10.0, top: 30.0),
        child: Column(
          children: <Widget>[
            Text('Profile')
          ],
        ),
      ),
    );
  }
}