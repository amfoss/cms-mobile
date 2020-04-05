import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class MembersPresent extends StatefulWidget {
  DateTime selectedDate;

  MembersPresent(DateTime selectedDate) {
    this.selectedDate = selectedDate;
  }

  @override
  AttendancePresent createState() => AttendancePresent(selectedDate);
}

class AttendancePresent extends State<MembersPresent> {
  DateTime selectedDate;

  AttendancePresent(DateTime selectedDate) {
    this.selectedDate = selectedDate;
    build(context);
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
              child: Text('Attendance not found'),
            );
          }
          print(result.data['dailyAttendance']['membersPresent'][0]);
          return _attendanceList(result);
        },
      ),
    );
  }

  Widget _attendanceList(QueryResult result) {
    final attendance = result.data['dailyAttendance'];
    final membersPresent = attendance['membersPresent'];
    return ListView.separated(
        itemCount: membersPresent.length,
        itemBuilder: (context, index) {
          String url = attendance['membersPresent'][index]['member']['avatar']
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
            title:
                Text(attendance['membersPresent'][index]['member']['fullName']),
            subtitle: Text(
                "duration: " + attendance['membersPresent'][index]['duration']),
          );
        },
        separatorBuilder: (context, index) => Divider());
  }

  String _buildQuery() {
    String query = '''
                      query {
                      dailyAttendance(date: "${DateFormat("yyyy-MM-dd").format(selectedDate)}") {
                                date
                                membersPresent {
                                  member {
                                    username
                                    fullName
                                    avatar {
                                      githubUsername
                                    }
                                  }
                                  duration
                                }
                              }
                      }''';
    return query;
  }
}
