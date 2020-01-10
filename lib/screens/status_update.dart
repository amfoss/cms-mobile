import 'package:flutter/material.dart';

class StatusUpdate extends StatefulWidget {
  @override
  _StatusUpdate createState() => _StatusUpdate();
}

class _StatusUpdate extends State<StatusUpdate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 10.0, top: 30.0),
        child: Column(
          children: <Widget>[
            Text('Status Update')
          ],
        ),
      ),
    );
  }
}