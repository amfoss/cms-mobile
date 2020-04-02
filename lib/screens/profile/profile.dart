import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

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
      body: Query(
        options: QueryOptions(documentNode: gql('''
                              query {
                                user(username: "$username"){
                                  firstName
                                  username
                                }
                              }
                              '''),),
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
    final nameList = result.data['user'];

    return Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Center(
            child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 170, bottom: 20),
              child: CircleAvatar(
                radius: 70,
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(
                    'https://avatars.githubusercontent.com/${nameList['username']}'),
              ),
            ),
            Text(
              '@${nameList['username']}',
              style: TextStyle(
                fontSize: 27,
              ),
            ),
          ],
        )));
  }
}