import 'package:cms_mobile/screens/profile/about.dart';
import 'package:cms_mobile/utilities/drawer.dart';
import 'package:cms_mobile/utilities/image_address.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utilities/constants.dart';

class Profile extends StatefulWidget {
  final String username;

  const Profile({this.username});

  @override
  _Profile createState() => _Profile(username);
}

class _Profile extends State<Profile> {
  final String username;

  _Profile(this.username);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: AppDrawer(),
      appBar: AppBar(
        backgroundColor: appPrimaryColor,
        title: const Text('Profile'),
      ),
      body: Query(
        options: QueryOptions(
          documentNode: gql('''
                              query {
                                user(username: "$username"){
                                  admissionYear                                
                                  isMembershipActive 
                                  isInLab
                                  lastSeenInLab                               
                                }
                                profile(username: "$username"){
    															about
                                  batch
                                  email
                                  fullName
                                  githubUsername
                                  gitlabUsername
                                  profilePic  
                                  telegramID                            
                                }                              
                              }
                              '''),
        ),
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          if (result.loading) {
            return Center(child: CircularProgressIndicator());
          }
          if (result.data == null) {
            print(username);
            print('NOT FOUND NAMES');
            return Center(child: Text('Names not found.'));
          }
          return _profileView(result);
        },
      ),
    );
  }

  Widget _profileView(QueryResult result) {
    final nameList = result.data['profile'];
    return new Container(
        margin: const EdgeInsets.only(left: 15, right: 20),
        child: new Column(children: <Widget>[
          new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                margin: EdgeInsets.only(top: 20, bottom: 20, right: 20),
                child: new CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(
                      ImageAddressProvider.imageAddress(
                          nameList['githubUsername'], nameList['profilePic'])),
                ),
              ),
              new Container(
                margin: EdgeInsets.only(top: 20, bottom: 20),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text('${nameList['fullName']}',
                        style: Theme.of(context).textTheme.headline),
                    new Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: new Text(nameList['about'],
                          style: Theme.of(context).textTheme.subtitle),
                    ),
                    Row(
                      children: <Widget>[
                        IconButton(
                            icon: new Icon(FlutterIcons.github_faw5d),
                            onPressed: () {
                              launch('https://github.com/' +
                                  nameList['githubUsername']);
                            }),
                        IconButton(
                            icon: new Icon(FlutterIcons.gitlab_faw5d),
                            onPressed: () {
                              launch('https://gitlab.com/' +
                                  nameList['gitlabUsername']);
                            }),
                        IconButton(
                            icon: new Icon(FlutterIcons.telegram_faw5d),
                            onPressed: () {
                              launch('https://t.me/' + nameList['telegramID']);
                            })
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          Divider(color: Colors.black),
          _details(result),
        ]));
  }

  Widget _details(QueryResult result) {
    final nameList = result.data['profile'];
    final detailsList = result.data['user'];

    String membership =
        (detailsList['isMembershipActive']) ? "Active" : "Suspended";

    return Expanded(
        child: ListView(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.account_circle),
          title: Text(
            'CMS Username: $username',
          ),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.mail),
          title: Text(
            'Email ID: ${nameList['email']}',
          ),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.calendar_today),
          title: Text(
            'Admission Year: ${detailsList['admissionYear']}',
          ),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.assessment),
          title: Text(
            'Membership Status: $membership',
          ),
        ),
        Divider(),
        ListTile(
          leading: Icon(FlutterIcons.eye_faw5s),
          title: Text(
            _isInLab(result),
          ),
        )
      ],
    ));
  }

  String _isInLab(QueryResult result) {
    final detailsList = result.data['user'];
    if (detailsList['isInLab']) {
      return "You are in lab now";
    }
    String lastSeen =
        "Last seen: " + _getFormatedDate(detailsList['lastSeenInLab']);
    return lastSeen;
  }

  String _getFormatedDate(String date) {
    var formmatedTime =
        DateFormat("HH:mm:ss").parse(date.substring(11, 19), true);
    var dateLocal = formmatedTime.toLocal();
    return date.substring(0, 10) +
        " " +
        dateLocal.toIso8601String().substring(11, 19);
  }
}
