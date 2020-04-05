import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class MembersSent extends StatefulWidget {
  final String slectedDate;

  const MembersSent(this.slectedDate);

  @override
  MembersSentTab createState() => MembersSentTab(slectedDate);
}

class MembersSentTab extends State<MembersSent> {
  String selctedDate;

  MembersSentTab(this.selctedDate);

  @override
  Widget build(BuildContext context) {
    selctedDate = selctedDate.substring(0, 10);
    return Scaffold(
      body: Query(
        options: QueryOptions(documentNode: gql(_buildQuery())),
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
          if (result.data['dailyStatusUpdates']['membersSent'].length == 0) {
            return Center(
              child: Text('No one a sent status update yet'),
            );
          }
          print(selctedDate);
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

  @override
  void initState() {
    super.initState();
  }

  String _buildQuery() {
    return '''
                query {
                        dailyStatusUpdates(date: "$selctedDate") {
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
  }
}
