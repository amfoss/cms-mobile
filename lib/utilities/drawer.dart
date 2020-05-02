import 'package:cms_mobile/data/user_database.dart';
import 'package:cms_mobile/screens/attendance/statistics/attendance_stats.dart';
import 'package:cms_mobile/screens/home.dart';
import 'package:cms_mobile/screens/login_screen.dart';
import 'package:cms_mobile/screens/profile/about.dart';
import 'package:cms_mobile/screens/profile/update_profile.dart';
import 'package:cms_mobile/screens/statusUpdate/statistics/status_update_graphs.dart';
import 'package:cms_mobile/screens/statusUpdate/statistics/status_update_stats.dart';
import 'package:cms_mobile/screens/statusUpdate/userUpdates.dart';
import 'package:cms_mobile/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

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
              text: 'Update Profile',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UpdateProfile()))),
          _createDrawerItem(
              icon: Icons.info,
              text: 'About',
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => About()))),
          Divider(),
          _createDrawerItem(
              icon: FlutterIcons.graph_trend_fou,
              text: 'Status Update Stats',
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StatusUpdateStats()))),
          _createDrawerItem(
              icon: FlutterIcons.graph_trend_fou,
              text: 'Attendance Stats',
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AttendanceStats()))),
          _createDrawerItem(
              icon: FlutterIcons.graph_oct,
              text: 'Status Updates Overview',
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StatusUpdateGraphs()))),
          _createDrawerItem(
              icon: FlutterIcons.list_alt_faw5,
              text: 'Messages List',
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          UserUpdates(HomePageScreen.username)))),
          Divider(),
          _createDrawerItem(
              icon: Icons.exit_to_app,
              text: 'Logout',
              onTap: () => logout()),
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

  void logout() {
    final db = Provider.of<AppDatabase>(context, listen: false);
    db.getSingleUser().then((userFromDb) {
      db.deleteUser(userFromDb).then((onValue) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      });
    });
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
