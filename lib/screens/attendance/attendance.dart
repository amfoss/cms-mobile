import 'package:cms_mobile/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:intl/intl.dart';

import 'absent.dart' as absent;
import 'present.dart' as present;

class Attendance extends StatefulWidget {
  @override
  _Attendance createState() => _Attendance();
}

class _Attendance extends State<Attendance>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  bool isConnection = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    tabController = new TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      debounceDuration: Duration.zero,
      connectivityBuilder: (BuildContext context,
          ConnectivityResult connectivity,
          Widget child,) {
        if (connectivity == ConnectivityResult.none) {
          if (isConnection == true) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              final snackBar =
              SnackBar(content: Text('You dont have internet Connection'));
              _scaffoldKey.currentState.showSnackBar(snackBar);
            });
          }

          isConnection = false;
        } else {
          if (isConnection == false) {
            final snackBar =
            SnackBar(content: Text('Your internet is live again'));
            _scaffoldKey.currentState.showSnackBar(snackBar);
            SchedulerBinding.instance.addPostFrameCallback((_) =>
                setState(() {
                  isConnection = true;
                }));
          }

          isConnection = true;
        }
        return child;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: appPrimaryColor,
          title: Text(
              "Attendance: ${DateFormat("yyyy-MM-dd").format(selectedDate)}"),
          leading: new IconButton(
              icon: new Icon(Icons.calendar_today),
              onPressed: () {
                setState(() {
                  _selectDate(context);
                });
              }),
          bottom: new TabBar(
            controller: tabController,
            tabs: <Widget>[
              new Tab(
                icon: new Icon(Icons.assignment_turned_in),
                text: "Present",
              ),
              new Tab(
                icon: new Icon(Icons.report),
                text: "Absent",
              ),
            ],
          ),
        ),
        body: new TabBarView(
          controller: tabController,
          children: <Widget>[
            new present.AttendancePresent(selectedDate).build(context),
            new absent.AttendanceAbsent(selectedDate).build(context),
          ],
        ),
      ),
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2018, 1),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
    build(context);
  }
}
