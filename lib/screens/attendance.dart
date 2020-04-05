import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';

class Attendance extends StatefulWidget {
  @override
  _Attendance createState() => _Attendance();
}

class _Attendance extends State<Attendance> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Attendence: ${DateFormat("yyyy-MM-dd").format(selectedDate)}"),
        leading: new IconButton(
          icon: new Icon(Icons.calendar_today),
          onPressed: () => _selectDate(context),
        ),
      ),
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

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2018, 1),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
    build(context);
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
