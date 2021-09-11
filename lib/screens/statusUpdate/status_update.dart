import 'package:cms_mobile/utilities/constants.dart';
import 'package:cms_mobile/utilities/get_stats.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:cms_mobile/utilities/theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../home.dart';
import 'members_didnot_sent.dart' as memberDidNotSend;
import 'members_sent.dart' as membersSent;

class StatusUpdate extends StatefulWidget {
  final String appUsername;
  final Link url;
  final int index;

  const StatusUpdate({this.appUsername, this.url, this.index});

  @override
  _StatusUpdateScreen createState() => _StatusUpdateScreen(appUsername);
}

class _StatusUpdateScreen extends State<StatusUpdate>
    with SingleTickerProviderStateMixin {
  String appUsername;
  DateTime pickedDate;
  bool isConnection = true;
  DateTime initialDate = DateTime.now().subtract(Duration(days: 30));
  DateTime lastDate = DateTime.now().subtract(Duration(hours: 29));
  TabController _tabController;
  final df = new DateFormat('dd-MMM-yyyy');
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  _StatusUpdateScreen(String appUsername) {
    this.appUsername = appUsername;
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this, initialIndex: widget.index);
    pickedDate = DateTime.now().subtract(Duration(hours: 29));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        statusQuery(context),
      ],
    ));
  }

  Widget statusQuery(context) {
    final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      GraphQLClient(link: widget.url, cache: InMemoryCache()),
    );

    return GraphQLProvider(
      client: client,
      child: Query(
        options: QueryOptions(documentNode: gql(_buildQuery())),
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          if (result.loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (result.data == null) {
            return Center(child: Text("No one send an update yet"));
          }
          if (result.data['clubStatusUpdate']['dailyLog'].length == 0) {
            return Center(
              child: Container(
                child: IconButton(
                  onPressed: () => HomePageScreen(),
                  icon: Icon(Icons.cloud_download_rounded),
                ),
              ),
            );
          }
          return statusDashboard(context, result);
        },
      ),
    );
  }

  Widget statusDashboard(context, result) {
    final dailyLog = result.data['clubStatusUpdate']['dailyLog'];
    print("in: " + initialDate.toString());
    List<String> weekNameData = getDays(dailyLog);
    double monthAvg = getMonthAvg(dailyLog).reduce((a, b) => a + b) / 4;
    List<BarChartGroupData> weekData = getWeekData(dailyLog);
    List<BarChartGroupData> monthData = getMonthData(dailyLog);
    bool pageChange = false;

    return Scaffold(
      key: _scaffoldKey,
      body: Material(
        child: Container(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  IconButton(
                      onPressed: () => {Navigator.pop(context)},
                      icon: Icon(Icons.arrow_back,
                          color:
                              getTheme(context) ? Colors.white : Colors.black)),
                  InkWell(
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: pickedDate,
                        firstDate: DateTime(2018, 1),
                        lastDate: DateTime.now().subtract(Duration(hours: 29)),
                      ).then((date) {
                        setState(() {
                          if (date != null) {
                            pickedDate = date;
                          } else {
                            date = pickedDate;
                          }
                        });
                      });
                    },
                    child: Container(
                        alignment: Alignment.topRight,
                        decoration: BoxDecoration(
                          color: getTheme(context)
                              ? Colors.grey[800]
                              : Colors.grey[200],
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        height: 35,
                        width: 100,
                        child: Align(
                            alignment: Alignment.center,
                            child: RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: " " +
                                        pickedDate.day.toString() +
                                        " " +
                                        df.format(pickedDate).substring(3, 6),
                                    style: TextStyle(
                                      color: getTheme(context)
                                          ? Colors.white
                                          : Colors.black,
                                    )),
                                WidgetSpan(
                                    child: Icon(
                                  Icons.arrow_drop_down,
                                  size: 16,
                                ))
                              ]),
                            ))),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
          Text(
            'Statistics',
            style: GoogleFonts.poppins(
                fontSize: 28, fontWeight: FontWeight.w500),
          ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 285,
                child: PageView(
                    controller: PageController(viewportFraction: 1),
                    scrollDirection: Axis.horizontal,
                    pageSnapping: true,
                    children: <Widget>[
                      _buildGraphCard(
                        type: "Weekly",
                          data: weekData,
                          avg: getAvg(dailyLog),
                          xAxis: weekNameData),
                      _buildGraphCard(
                        type: "Monthly",
                          data: monthData,
                          avg: monthAvg,
                          xAxis: [
                        'wk1',
                        'wk2',
                        'wk3',
                        'wk4',
                      ]),
                    ]),
              ),
              SizedBox(height: 15),
              Text(
                "Status Updates",
                style: GoogleFonts.poppins(
                  fontSize: 20
                ),

              ),
              SizedBox(height: 15),
              Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(
                    10.0,
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(
                      width: 4,
                      color: Color(0xFF646464),
                    ),
                    insets: EdgeInsets.only(
                        left: 0,
                        right: 8,
                        bottom: 4
                    )
                  ),
                  isScrollable: true,
                  labelPadding: EdgeInsets.all(10),
                  labelColor: getTheme(context) ?Colors.white : Colors.black,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(
                      text: 'Sent',
                    ),
                    Tab(
                      text: 'Not sent',
                    ),
                  ],
                ),
              ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // first tab bar view widget
                membersSent.MembersSent(DateFormat("yyyy-MM-dd").format(pickedDate),widget.url),
                // second tab bar view widget
                memberDidNotSend.MembersDidNotSend(DateFormat("yyyy-MM-dd").format(pickedDate))
              ],
            ),
          ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGraphCard(
      {String type, List<BarChartGroupData> data, double avg, List xAxis}) {
    dynamic theme = Provider.of<DarkThemeProvider>(context).darkTheme;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
                child: Text(
                  "$type Average:\n",
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
              ),
              Text(
                avg.toInt().toString() + " Updates",
                style: GoogleFonts.poppins(fontSize: 20),
              ),
              SizedBox(
                height: 35,
              ),
              SizedBox(
                height: 140,
                child: BarChart(BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 30,
                  barTouchData: BarTouchData(
                    enabled: false,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.transparent,
                      tooltipPadding: const EdgeInsets.all(0),
                      getTooltipItem: (
                        BarChartGroupData group,
                        int groupIndex,
                        BarChartRodData rod,
                        int rodIndex,
                      ) {
                        return BarTooltipItem(
                          rod.y.round().toString(),
                          TextStyle(
                            color: Color(0xff7589a2),
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: SideTitles(
                      showTitles: true,
                      textStyle: TextStyle(
                          color: Color(0xff7589a2),
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                      margin: 10,
                      getTitles: (double value) {
                        switch (value.toInt()) {
                          case 0:
                            return xAxis[0];
                          case 1:
                            return xAxis[1];
                          case 2:
                            return xAxis[2];
                          case 3:
                            return xAxis[3];
                          case 4:
                            return xAxis[4];
                          case 5:
                            return xAxis[5];
                          case 6:
                            return xAxis[6];
                          default:
                            return '';
                        }
                      },
                    ),
                    leftTitles: SideTitles(showTitles: false),
                  ),
                  barGroups: data,
                )),
              ),
            ],
          )),
    );
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
                }''';
  }
}
