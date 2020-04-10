import 'package:flutter/material.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class Messages extends StatefulWidget {
  DateTime selectedDate;

  Messages(DateTime selectedDate) {
    this.selectedDate = selectedDate;
  }

  @override
  MessagesTab createState() => MessagesTab(selectedDate);
}

class MessagesTab extends State<Messages> {
  DateTime selectedDate;

  MessagesTab(DateTime selectedDate) {
    this.selectedDate = selectedDate;
  }

  @override
  Widget build(BuildContext context) {
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
          if (result.data['getStatusUpdates'].length == 0) {
            return Center(
              child: Text('No status updates for this date'),
            );
          }
          print(selectedDate);
          print(result.data['getStatusUpdates'][0]['member']);
          return _membersSentList(result);
        },
      ),
    );
  }

  Widget _membersSentList(QueryResult result) {
    final messagesList = result.data['getStatusUpdates'];
    return ListView.separated(
        itemCount: messagesList.length,
        itemBuilder: (context, index) {
          String url =
              messagesList[index]['member']['avatar']['githubUsername'];
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
            title: Text(messagesList[index]['member']['fullName'] + "\n"),
            subtitle: MarkdownBody(
                data: html2md.convert(messagesList[index]['message'])
            ),
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
                        getStatusUpdates(date: "${DateFormat("yyyy-MM-dd").format(selectedDate)}"){
                          member{
                            username
                            fullName
                            avatar{
                              githubUsername
                            }
                          }
                          timestamp
                          message
                        } 
                      }''';
  }
}
