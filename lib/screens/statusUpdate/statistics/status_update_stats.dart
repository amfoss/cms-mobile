import 'package:cms_mobile/screens/home.dart';
import 'package:cms_mobile/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:intl/intl.dart';


class StatusUpdateStats extends StatefulWidget {
  @override
  _StatusUpdateStats createState() => _StatusUpdateStats();
}

class _StatusUpdateStats extends State<StatusUpdateStats>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  DateTime initialDate = DateTime.now().subtract(Duration(days: 7));
  DateTime lastDate = new DateTime.now();

  @override
  void initState() {
    tabController = new TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      GraphQLClient(link: HomePageScreen.url, cache: InMemoryCache()),
    );

    return GraphQLProvider(
      client: client,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appPrimaryColor,
          title: Text("Status Update stats" + "\n" + _getFormatedDate(initialDate)+ " - " + _getFormatedDate(lastDate)),
          bottom: new TabBar(
            controller: tabController,
            tabs: <Widget>[
              new Tab(
                icon: new Icon(Icons.assignment_turned_in),
                text: "Top 5",
              ),
              new Tab(
                icon: new Icon(Icons.report),
                text: "Worst 5",
              ),
            ],
          ),
          leading: IconButton(
            icon: new Icon(Icons.calendar_today),
            onPressed: () => _selectDateRange(),
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
                child: Text('Status Update not found'),
              );
            }
            if (result.data['clubStatusUpdate']['memberStats'].length == 0) {
              return Center(
                child: Text('No one a sent status update yet'),
              );
            }
            print(result.data['clubStatusUpdate']['memberStats'][0]);
            return new TabBarView(
              controller: tabController,
              children: <Widget>[_topFive(result), _worstFive(result)],
            );
          },
        ),
      ),
    );
  }

  Future<Null> _selectDateRange() async{
    final List<DateTime> picked = await DateRagePicker.showDatePicker(
        context: context,
        initialFirstDate: new DateTime.now().subtract(Duration(days: 7)),
        initialLastDate: (new DateTime.now()),
        firstDate: new DateTime(2015),
        lastDate: new DateTime(2022)
    );
    if (picked != null && picked.length == 2) {
      print(picked);
      setState(() {
        initialDate = picked[0];
        lastDate = picked[1];
      });
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Widget _topFive(QueryResult result) {
    var topFiveList = result.data['clubStatusUpdate'];
    return ListView.separated(
        itemCount: 5,
        itemBuilder: (context, index) {
          String url = topFiveList['memberStats'][index]['user']['avatar']
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
                Text(topFiveList['memberStats'][index]['user']['fullName']),
            subtitle: Text("count: " +
                topFiveList['memberStats'][index]['statusCount']),
          );
        },
        separatorBuilder: (context, index) => Divider());
  }

  Widget _worstFive(QueryResult result) {
    var worstFiveList = result.data['clubStatusUpdate'];
    var lentgh = worstFiveList['memberStats'].length;
    return ListView.separated(
        itemCount: 5,
        itemBuilder: (context, index) {
          String url = worstFiveList['memberStats'][lentgh - index - 1]
              ['user']['avatar']['githubUsername'];
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
            title: Text(worstFiveList['memberStats'][lentgh - index - 1]
                ['user']['fullName']),
            subtitle: Text("count: " +
                worstFiveList['memberStats'][lentgh - index - 1]
                    ['statusCount']),
          );
        },
        separatorBuilder: (context, index) => Divider());
  }

  String _getFormatedDate(DateTime dateTime){
    return DateFormat("yyyy-MM-dd").format(dateTime);
  }


  String _buildQuery() {
    return '''
                query{
                    clubStatusUpdate(startDate: "${DateFormat("yyyy-MM-dd").format(initialDate)}", endDate: "${DateFormat("yyyy-MM-dd").format(lastDate)}")
                    {
                      memberStats
                      {
                        user
                        {
                          fullName
                          avatar 
                          {
                             githubUsername
                          }
                        }
                       statusCount
                      }
                    }
                }   
                      ''';
  }
}
