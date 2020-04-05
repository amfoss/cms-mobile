import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class MembersSent extends StatefulWidget {
  @override
  _MembersSent createState() => _MembersSent();
}

class _MembersSent extends State<MembersSent> {
  final String query = '''
                      query {
                        dailyStatusUpdates(date: "2020-04-04") {
                                  date
                                  membersSent {
                                    member {
                                      username
                                      fullName
                                      avatar{
                                        githubUsername
                                      }
                                    }
                                  }
                                }
                      }''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Query(
        options: QueryOptions(documentNode: gql(query)),
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          if (result.loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (result.data == null) {
            return Center(
              child: Text('Status Update not found'),
            );
          }
          print(result.data['dailyStatusUpdates']['membersSent'][0]);
          return _membersSentList(result);
        },
      ),
    );
  }

  Widget _membersSentList(QueryResult result) {
    final membersSentList = result.data['dailyStatusUpdates'];
    final membersPresent = membersSentList['membersSent'];
    return ListView.separated(
        itemCount: membersPresent.length,
        itemBuilder: (context, index) {
          String url = membersSentList['membersSent'][index]['member']['avatar']
              ['githubUsername'];
          if (url == null) {
            url = 'github';
          }
          return ListTile(
            leading: new CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey,
              backgroundImage:
                  NetworkImage('https://avatars.githubusercontent.com/' + url),
            ),
            title: Text(
                membersSentList['membersSent'][index]['member']['fullName']),
            subtitle: Text("@" +
                membersSentList['membersSent'][index]['member']['username']),
          );
        },
        separatorBuilder: (context, index) => Divider());
  }
}
