import 'package:flutter/material.dart';

class Attendance extends StatefulWidget {
  @override
  _Attendance createState() => _Attendance();
}

class _Attendance extends State<Attendance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 10.0, top: 30.0),
        child: Column(
          children: <Widget>[
            Text('Attendance')
          ],
        ),
      ),
    );
  }
}