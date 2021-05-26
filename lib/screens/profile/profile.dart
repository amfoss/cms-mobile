import 'package:cms_mobile/utilities/drawer.dart';
import 'package:cms_mobile/utilities/image_address.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_offline/flutter_offline.dart';
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
  bool isConnection = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  _Profile(this.username);

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      debounceDuration: Duration.zero,
      connectivityBuilder: (
        BuildContext context,
        ConnectivityResult connectivity,
        Widget child,
      ) {
        if (connectivity == ConnectivityResult.none) {
          isConnection = false;
        } else {
          if (isConnection == false) {
            final snackBar =
                SnackBar(content: Text('Your internet is live again'));
            _scaffoldKey.currentState.showSnackBar(snackBar);
            SchedulerBinding.instance.addPostFrameCallback((_) => setState(() {
                  isConnection = true;
                }));
          }
          isConnection = true;
        }
        return child;
      },
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        endDrawer: AppDrawer(),
        appBar: AppBar(
          backgroundColor: appPrimaryColor,
          title: const Text('Profile'),
        ),
        body: Query(
          options: QueryOptions(
            documentNode: gql(_getBuildQuery()),
          ),
          builder: (QueryResult result,
              {VoidCallback refetch, FetchMore fetchMore}) {
            if (result.loading) {
              return Center(child: CircularProgressIndicator());
            }
            if (!isConnection) {
              print('No Internet');
              return Center(
                  child: Text('Please check your internet connection'));
            }
            if (result.data == null) {
              print(username);
              print('NOT FOUND NAMES');
              return Center(child: Text('Names not found.'));
            }
            return _profileView(result);
          },
        ),
      ),
    );
  }

  String _getBuildQuery() {
    return '''
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
                                ''';
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
                    Container(
                      padding: EdgeInsets.only(left: 4),
                      margin: EdgeInsets.only(left: 8),
                      child: new Text('${nameList['fullName']}',
                          style: Theme.of(context).textTheme.headline),
                    ),
                    Row(
                      children: <Widget>[
                        IconButton(
                            icon: new Icon(FlutterIcons.github_faw5d),
                            onPressed: () {
                              if (nameList['githubUsername'] != null) {
                                launch('https://github.com/' +
                                    nameList['githubUsername']);
                              } else {
                                final snackBar = SnackBar(
                                    content: Text('github username not found'));
                                _scaffoldKey.currentState
                                    .showSnackBar(snackBar);
                              }
                            }),
                        IconButton(
                            icon: new Icon(FlutterIcons.gitlab_faw5d),
                            onPressed: () {
                              if (nameList['gitlabUsername'] != null) {
                                launch('https://gitlab.com/' +
                                    nameList['gitlabUsername']);
                              } else {
                                final snackBar = SnackBar(
                                    content: Text('Gitlab username not found'));
                                _scaffoldKey.currentState
                                    .showSnackBar(snackBar);
                              }
                            }),
                        IconButton(
                            icon: new Icon(FlutterIcons.telegram_faw5d),
                            onPressed: () {
                              if (nameList['telegramID'] != null) {
                                launch(
                                    'https://t.me/' + nameList['telegramID']);
                              } else {
                                final snackBar = SnackBar(
                                    content: Text(
                                        'Telegram username not availible'));
                                _scaffoldKey.currentState
                                    .showSnackBar(snackBar);
                              }
                            })
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          new Container(
            margin: const EdgeInsets.only(top: 5.0),
            child: new Text(nameList['about'],
                style: Theme.of(context).textTheme.subtitle),
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
    if(date == null){
      return "No Info";
    }
    var formmatedTime =
        DateFormat("HH:mm:ss").parse(date.substring(11, 19), true);
    var dateLocal = formmatedTime.toLocal();
    return date.substring(0, 10) +
        " " +
        dateLocal.toIso8601String().substring(11, 19);
  }
}
