import 'package:cms_mobile/screens/profile/profile.dart';
import 'package:cms_mobile/utilities/constants.dart';
import 'package:cms_mobile/utilities/sizeconfig.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'statusUpdate/status_update.dart';
import 'attendance/attendance.dart';

class HomePage extends StatefulWidget {
  final Link url;
  final String username;

  const HomePage({Key key, this.username, this.url}) : super(key: key);

  @override
  HomePageScreen createState() => HomePageScreen();
}

class HomePageScreen extends State<HomePage> {
  static Link url;
  static String username;

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final List<Widget> _children = [
      Attendance(),
      StatusUpdate(
        appUsername: widget.username,
      ),
      Profile(
        username: widget.username,
      )
    ];

    final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      GraphQLClient(link: widget.url, cache: InMemoryCache()),
    );

    url = widget.url;
    username = widget.username;
    return GraphQLProvider(
      client: client,
      child: Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: StreamBuilder(
            stream: null,
            builder: (context, snapshot) {
              return BottomNavigationBar(
                fixedColor: appPrimaryColor,
                currentIndex: _currentIndex,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.playlist_add_check),
                    title: Text("Attendance"),
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.check_box),
                      title: Text("Status Update")),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person), title: Text("Profile"))
                ],
                onTap: onTabTapped,
              );
            }),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
