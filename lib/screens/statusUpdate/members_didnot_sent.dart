import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class MembersDidNotSend extends StatefulWidget {
  @override
  _MemberDidNotSend createState() => _MemberDidNotSend();
}

class _MemberDidNotSend extends State<MembersDidNotSend> {
  final String query = '''
                      query {
                        dailyStatusUpdates(date: "2020-04-04") {
                                  date
                                  memberDidNotSend {
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
          print(result.data['dailyStatusUpdates']['memberDidNotSend'][0]);
          return _membersSentList(result);
        },
      ),
    );
  }

  Widget _membersSentList(QueryResult result) {
    final membersDidNotSentList = result.data['dailyStatusUpdates'];
    final membersPresent = membersDidNotSentList['memberDidNotSend'];
    return ListView.separated(
        itemCount: membersPresent.length,
        itemBuilder: (context, index) {
          String url = membersDidNotSentList['memberDidNotSend'][index]
              ['member']['avatar']['githubUsername'];
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
            title: Text(membersDidNotSentList['memberDidNotSend'][index]
                ['member']['fullName']),
            subtitle: Text("@" +
                membersDidNotSentList['memberDidNotSend'][index]['member']
                    ['username']),
          );
        },
        separatorBuilder: (context, index) => Divider());
  }
}
