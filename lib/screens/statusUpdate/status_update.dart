import 'package:flutter/material.dart';

import 'members_didnot_sent.dart' as memberDidNotSend;
import 'members_sent.dart' as membersSent;

class StatusUpdate extends StatefulWidget {
  @override
  _StatusUpdate createState() => _StatusUpdate();
}

class _StatusUpdate extends State<StatusUpdate>
    with SingleTickerProviderStateMixin {
  TabController tabController;

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
    return Scaffold(
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueAccent,
        title: Text("Status Update"),
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
          new membersSent.MembersSent(),
          new memberDidNotSend.MembersDidNotSend(),
        ],
      ),
    );
  }
}
