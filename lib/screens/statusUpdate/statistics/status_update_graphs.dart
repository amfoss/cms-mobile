import 'package:cms_mobile/screens/home.dart';
import 'package:cms_mobile/utilities/ColorGenerator.dart';
import 'package:cms_mobile/utilities/constants.dart';
import 'package:cms_mobile/utilities/indicator.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';

class StatusUpdateGraphs extends StatefulWidget {
  @override
  _StatusUpdateGraphs createState() => _StatusUpdateGraphs();
}

class _StatusUpdateGraphs extends State<StatusUpdateGraphs>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  bool isConnection = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  DateTime initialDate = DateTime.now().subtract(Duration(days: 7));
  DateTime lastDate = DateTime.now().subtract(Duration(hours: 29));

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
      child: OfflineBuilder(
        debounceDuration: Duration.zero,
        connectivityBuilder: (BuildContext context,
            ConnectivityResult connectivity,
            Widget child,) {
          if (connectivity == ConnectivityResult.none) {
            if (isConnection == true) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                final snackBar = SnackBar(
                    content: Text('You dont have internet Connection'));
                _scaffoldKey.currentState.showSnackBar(snackBar);
              });
            }

            isConnection = false;
          } else {
            if (isConnection == false) {
              final snackBar =
              SnackBar(content: Text('Your internet is live again'));
              _scaffoldKey.currentState.showSnackBar(snackBar);
              SchedulerBinding.instance
                  .addPostFrameCallback((_) =>
                  setState(() {
                    isConnection = true;
                  }));
            }

            isConnection = true;
          }
          return child;
        },
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: appPrimaryColor,
            title: Text("Status Update trends" +
                "\n" +
                _getFormatedDate(initialDate) +
                " - " +
                _getFormatedDate(lastDate)),
            bottom: new TabBar(
              controller: tabController,
              tabs: <Widget>[
                new Tab(
                  icon: new Icon(Icons.assignment_turned_in),
                  text: "Update Trends",
                ),
                new Tab(
                  icon: new Icon(Icons.card_membership),
                  text: "Member Trends",
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
                children: <Widget>[
                  _UpdateTrends(result),
                  _memberUpdates(result)
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<Null> _selectDateRange() async {
    final List<DateTime> picked = await DateRagePicker.showDatePicker(
        context: context,
        initialFirstDate: new DateTime.now().subtract(Duration(days: 7)),
        initialLastDate: (DateTime.now().subtract(Duration(hours: 29))),
        firstDate: new DateTime(2015),
        lastDate: DateTime.now().subtract(Duration(hours: 29)));
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

  // ignore: non_constant_identifier_names
  Widget _UpdateTrends(QueryResult result) {
    var updateList = result.data['clubStatusUpdate'];
    var length = result.data['clubStatusUpdate']['dailyLog'].length;
    var dates = [];
    var totalCount = 0;
    List<int> count = [];
    var colors = [];
    for (int i = 0; i < length; ++i) {
      dates.add(updateList['dailyLog'][i]['date']);
      count.add(updateList['dailyLog'][i]['membersSentCount']);
      totalCount += updateList['dailyLog'][i]['membersSentCount'];
      colors.add(ColorGenerator.getColor());
    }
    return new GridView.count(
      crossAxisCount: 1,
      children: new List<Widget>.generate(
        1,
        (index) {
          return new GridTile(
            header: Text(
              "  Status Update trends for given dates",
              style: messageLabelStyle,
            ),
            child: new Card(
              child: _makePieChart(length, dates, count, colors, totalCount),
            ),
          );
        },
      ),
    );
  }

  Widget _memberUpdates(QueryResult result) {
    var updateList = result.data['clubStatusUpdate'];
    var members1 = [];
    List<int> count1 = [];
    var color1 = [];
    int totalCount1 = 0;

    var members2 = [];
    List<int> count2 = [];
    var color2 = [];
    int totalCount2 = 0;

    var members3 = [];
    List<int> count3 = [];
    var color3 = [];
    int totalCount3 = 0;

    var members4 = [];
    List<int> count4 = [];
    var color4 = [];
    int totalCount4 = 0;

    for (int i = 0;
        i < result.data['clubStatusUpdate']['memberStats'].length;
        ++i) {
      if (updateList['memberStats'][i]['user']['admissionYear'] == 2016) {
        if ((updateList['memberStats'][i]['user']['username'])
                .toString()
                .length <
            9) {
          members1.add(updateList['memberStats'][i]['user']['username']);
        } else {
          members1.add((updateList['memberStats'][i]['user']['username'])
              .toString()
              .substring(0, 9));
        }
        count1.add(int.parse(updateList['memberStats'][i]['statusCount']));
        totalCount1 += int.parse(updateList['memberStats'][i]['statusCount']);
        color1.add(ColorGenerator.getColor());
      } else if (updateList['memberStats'][i]['user']['admissionYear'] ==
          2017) {
        if ((updateList['memberStats'][i]['user']['username'])
                .toString()
                .length <
            9) {
          members2.add(updateList['memberStats'][i]['user']['username']);
        } else {
          members2.add((updateList['memberStats'][i]['user']['username'])
              .toString()
              .substring(0, 9));
        }
        count2.add(int.parse(updateList['memberStats'][i]['statusCount']));
        totalCount2 += int.parse(updateList['memberStats'][i]['statusCount']);
        color2.add(ColorGenerator.getColor());
      } else if (updateList['memberStats'][i]['user']['admissionYear'] ==
          2018) {
        if ((updateList['memberStats'][i]['user']['username'])
                .toString()
                .length <
            9) {
          members3.add(updateList['memberStats'][i]['user']['username']);
        } else {
          members3.add((updateList['memberStats'][i]['user']['username'])
              .toString()
              .substring(0, 9));
        }
        count3.add(int.parse(updateList['memberStats'][i]['statusCount']));
        totalCount3 += int.parse(updateList['memberStats'][i]['statusCount']);
        color3.add(ColorGenerator.getColor());
      } else if (updateList['memberStats'][i]['user']['admissionYear'] ==
          2019) {
        if ((updateList['memberStats'][i]['user']['username'])
                .toString()
                .length <
            9) {
          members4.add(updateList['memberStats'][i]['user']['username']);
        } else {
          members4.add((updateList['memberStats'][i]['user']['username'])
              .toString()
              .substring(0, 9));
        }
        count4.add(int.parse(updateList['memberStats'][i]['statusCount']));
        totalCount4 += int.parse(updateList['memberStats'][i]['statusCount']);
        color4.add(ColorGenerator.getColor());
      }
    }

    var membersList = [members1, members2, members3, members4];
    var countList = [count1, count2, count3, count4];
    List<int> totalCounts = [
      totalCount1,
      totalCount2,
      totalCount3,
      totalCount4
    ];
    var colorsList = [color1, color2, color3, color4];
    var years = ["2016", "2017", "2018", "2019"];

    return new GridView.count(
      crossAxisCount: 1,
      children: new List<Widget>.generate(
        4,
        (index) {
          return new GridTile(
            header: Text(
              "  ${years[index]}",
              style: messageLabelStyle,
            ),
            child: new Card(
              child: _makePieChart(
                  membersList[index].length,
                  membersList[index],
                  countList[index],
                  colorsList[index],
                  totalCounts[index]),
            ),
          );
        },
      ),
    );
  }

  AspectRatio _makePieChart(
      int length, List dates, List count, List colors, int totalCount) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: <Widget>[
          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 2,
                    centerSpaceRadius: 25,
                    sections:
                        showingSections(length, count, colors, totalCount)),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: showLegend(length, dates, colors),
          ),
          const SizedBox(
            width: 28,
            height: 20,
          ),
        ],
      ),
    );
  }

  String _getFormatedDate(DateTime dateTime) {
    return DateFormat("yyyy-MM-dd").format(dateTime);
  }

  String _buildQuery() {
    return '''
                query{
                    clubStatusUpdate(startDate: "${DateFormat("yyyy-MM-dd").format(initialDate)}", endDate: "${DateFormat("yyyy-MM-dd").format(lastDate)}")
                    {                    
                      dailyLog {
                        date
                        membersSentCount
                      }
                      memberStats
                      {
                        user
                        {
                          username
                          admissionYear
                        }
                       statusCount
                      }
                    }
                }   
                      ''';
  }

  List<Widget> showLegend(int length, List dates, List colors) {
    return List.generate(length, (i) {
      return Indicator(
        color: colors[i],
        text: dates[i].toString(),
        isSquare: true,
      );
    });
  }

  List<PieChartSectionData> showingSections(
      int length, List count, List colors, int totalCount) {
    return List.generate(length, (i) {
      final double fontSize = 14;
      final double radius = 80;
      return PieChartSectionData(
        color: colors[i],
        value: count[i] / totalCount * 100,
        title: count[i].toString(),
        radius: radius,
        titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white),
      );
    });
  }
}
