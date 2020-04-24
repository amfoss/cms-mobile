import 'package:cms_mobile/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:intl/intl.dart';

import 'members_didnot_sent.dart' as memberDidNotSend;
import 'members_sent.dart' as membersSent;

class StatusUpdate extends StatefulWidget {
  final String appUsername;

  const StatusUpdate({this.appUsername});

  @override
  _StatusUpdateScreen createState() => _StatusUpdateScreen(appUsername);
}

class _StatusUpdateScreen extends State<StatusUpdate>
    with SingleTickerProviderStateMixin {
  String appUsername;
  bool isConnection = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  _StatusUpdateScreen(String appUsername) {
    this.appUsername = appUsername;
  }

  TabController tabController;
  DateTime selectedDate = DateTime.now().subtract(Duration(hours: 29));

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
              final snackBar = SnackBar(
                  content: Text('You dont have internet Connection'));
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
          title: new Text(
              "Status update: ${DateFormat("yyyy-MM-dd").format(
                  selectedDate)}"),
          leading: IconButton(
            icon: new Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
          bottom: new TabBar(
            controller: tabController,
            tabs: <Widget>[
              new Tab(
                icon: new Icon(Icons.assignment_turned_in),
                text: "sent",
              ),
              new Tab(
                icon: new Icon(Icons.report),
                text: "Not sent",
              ),
            ],
          ),
        ),
        body: new TabBarView(
          controller: tabController,
          children: <Widget>[
            new membersSent.MembersSentTab(_getDate()).build(context),
            new memberDidNotSend.MemberDidNotSendTab(_getDate()).build(context),
          ],
        ),
      ),
    );
  }

  String _getDate() {
    return selectedDate.toIso8601String();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2018, 1),
        lastDate: DateTime.now().subtract(Duration(hours: 29)));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
    build(context);
  }
}
