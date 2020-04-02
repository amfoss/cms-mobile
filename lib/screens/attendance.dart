import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';

class Attendance extends StatefulWidget {
  @override
  _Attendance createState() => _Attendance();
}

class _Attendance extends State<Attendance> {
    final String query = '''
                      query {
                        dailyAttendance(date:"${DateFormat("yyyy-MM-dd").format(DateTime.now())}"){
                          date
                          membersPresent{
                            member{
                              username
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
              child: Text('Attendance not found'),
            );
          }
          print(result.data['dailyAttendance']['membersPresent'][0]);
          // if (result.data[0] == [])
            return _attendanceList(result);
        },
      ),
    );
  }
Widget _attendanceList(QueryResult result) {
    final attendance = result.data['dailyAttendance'];
    return ListView.separated(
        primary: false,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(attendance['membersPresent'][index]['member']['username']),
          );
        },
        separatorBuilder: (context, index) => Divider(),
        itemCount: 5);
  }
}