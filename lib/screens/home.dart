import 'package:cms_android/screens/attendance.dart';
import 'package:cms_android/screens/profile.dart';
import 'package:cms_android/screens/status_update.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [Attendance(), Profile(), StatusUpdate()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.playlist_add_check),
            title: Text("Attendance"),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text("Profile")),
          BottomNavigationBarItem(
              icon: Icon(Icons.check_box), title: Text("Status")),
        ],
        onTap: onTabTapped,
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
