import 'package:cms_mobile/screens/home.dart';
import 'package:cms_mobile/screens/profile/about.dart';
import 'package:cms_mobile/screens/profile/profile.dart';
import 'package:cms_mobile/screens/statusUpdate/statistics/status_update_stats.dart';
import 'package:cms_mobile/screens/statusUpdate/userUpdates.dart';
import 'package:cms_mobile/utilities/constants.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: new EdgeInsets.only(top: 50),
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                HomePageScreen.username,
                style: messageLabelStyle,
              )),
          Divider(),
          _createDrawerItem(
              icon: Icons.account_circle,
              text: 'Account'),
          _createDrawerItem(
              icon: Icons.info,
              text: 'About',
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => About()))),
          Divider(),
          _createDrawerItem(
              icon: Icons.trending_up,
              text: 'Status Update Stats',
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          StatusUpdateStats()))),
          _createDrawerItem(
              icon: Icons.trending_up,
              text: 'Attendance Stats'),
          _createDrawerItem(
              icon: Icons.score,
              text: 'Status Updates Overview'),
          _createDrawerItem(
              icon: Icons.list,
              text: 'Messages List',
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => UserUpdates(HomePageScreen.username)))),
          Divider(),
          _createDrawerItem(icon: Icons.bug_report, text: 'Report an issue'),
          ListTile(
            title: Text('0.0.1'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
