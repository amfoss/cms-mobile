import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class MembersAbsent extends StatefulWidget {
  DateTime selectedDate;

  MembersAbsent(DateTime selectedDate) {
    this.selectedDate = selectedDate;
  }

  @override
  AttendanceAbsent createState() => AttendanceAbsent(selectedDate);
}

class AttendanceAbsent extends State<MembersAbsent> {
  DateTime selectedDate;

  AttendanceAbsent(DateTime selectedDate) {
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
              child: Text('Attendance not found'),
            );
          }
          if (result.data['dailyAttendance']['membersAbsent'].length == 0) {
            return Center(
              child: Text('Woohoo!\nLooks like every one is present'),
            );
          }
          print(result.data['dailyAttendance']['membersAbsent'][0]);
          return _attendanceList(result);
        },
      ),
    );
  }

  Widget _attendanceList(QueryResult result) {
    final attendance = result.data['dailyAttendance'];
    final membersAbsent = attendance['membersAbsent'];
    return ListView.separated(
        itemCount: membersAbsent.length,
        itemBuilder: (context, index) {
          String url = attendance['membersAbsent'][index]['member']['avatar']
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
                Text(attendance['membersAbsent'][index]['member']['fullName']),
          );
        },
        separatorBuilder: (context, index) => Divider());
  }

  String _buildQuery() {
    String query = '''
                      query {
                      dailyAttendance(date: "${DateFormat("yyyy-MM-dd").format(selectedDate)}") {
                                date
                                membersAbsent {
                                  member {
                                    username
                                    fullName
                                    avatar {
                                      githubUsername
                                    }
                                  }
                                }
                              }
                      }''';
    return query;
  }
}
