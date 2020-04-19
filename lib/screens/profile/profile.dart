import 'package:cms_mobile/screens/profile/about.dart';
import 'package:cms_mobile/utilities/drawer.dart';
import 'package:cms_mobile/utilities/image_address.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

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
                                }
                                profile(username: "$username"){
    															fullName
                                  email
                                  githubUsername  
                                  profilePic                              
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
                margin: EdgeInsets.only(top: 10, bottom: 20, right: 20),
                child: new CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(ImageAddressProvider.imageAddress(nameList['githubUsername'], nameList['profilePic'])),
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
                      child: new Text('@${nameList['githubUsername']}',
                          style: Theme.of(context).textTheme.subtitle),
                    ),
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
      ],
    ));
  }
}
