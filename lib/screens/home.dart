import 'package:cms_mobile/screens/attendance.dart';
import 'package:cms_mobile/screens/profile/profile.dart';
import 'package:cms_mobile/screens/status_update.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class HomePage extends StatefulWidget {
  final Link url;
  final String username;

  const HomePage({Key key, this.username, this.url}) : super(key: key);

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [Attendance(), Profile(), StatusUpdate()];

  @override
  Widget build(BuildContext context) {
    final List<Widget> _children = [
      Attendance(),
      Profile(
        username: widget.username,
      ),
      StatusUpdate()
    ];

    final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      GraphQLClient(link: widget.url, cache: InMemoryCache()),
    );

    return GraphQLProvider(
      client: client,
      child: Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: StreamBuilder(
          stream: null,
          builder: (context, snapshot) {
            return BottomNavigationBar(
              fixedColor: Colors.blueAccent,
              currentIndex: _currentIndex,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.playlist_add_check),
                  title: Text("Attendance"),
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    title: Text("Profile")
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_box),
                    title: Text("Status Update")
                ),
              ],
              onTap: onTabTapped,
            );
          }
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
