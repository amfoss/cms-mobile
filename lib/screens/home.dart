import 'package:cms_mobile/screens/profile/profile.dart';
import 'package:cms_mobile/screens/statusUpdate/status_update.dart';
import 'package:cms_mobile/utilities/constants.dart';
import 'package:cms_mobile/utilities/get_stats.dart';
import 'package:cms_mobile/utilities/image_address.dart';
import 'package:cms_mobile/utilities/indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_stack/image_stack.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import '../navigationDrawer.dart';

class HomePage extends StatefulWidget {
  final Link url;
  final String username;

  const HomePage({Key key, this.username, this.url}) : super(key: key);

  @override
  HomePageScreen createState() => HomePageScreen();
}

class HomePageScreen extends State<HomePage> {
  static Link url;
  static String username;
  bool isCollapsed = true;
  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 300);
  DateTime pickedDate;
  final df = new DateFormat('dd-MMM-yyyy');

  @override
  void initState() {
    super.initState();
    pickedDate = DateTime.now().subtract(Duration(hours: 29));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          query(context),
        ],
      )
    );
  }

  Widget query(context){
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
            return Center(
              child: ElevatedButton(
                onPressed: () {setState(() {});},
                child: Text('Reload'),
              )
            );
          }
          if (result.data['dailyStatusUpdates']['membersSent'].length == 0) {
            return Center(
              child: Container(
                child: IconButton(
                  onPressed: () => HomePageScreen(),
                  icon: Icon(Icons.cloud_download_rounded),
                ),
              ),
            );
          }
          print(pickedDate);
          print(result.data['dailyStatusUpdates']['membersSent'][0]);
          return dashboard(context, result);
        },
      ),
    );
  }

  Widget dashboard(context, QueryResult result) {
    final memberSent = result.data['dailyStatusUpdates']['membersSent'];
    final memberNotSent = result.data['dailyStatusUpdates']['memberDidNotSend'];
    final total = memberSent.length + memberNotSent.length;
    final sent = memberSent.length/total * 100;
    final notSent = memberNotSent.length/total * 100;
    final url = "https://api.amfoss.in/";
    List<String> profilePicSent;
    List<String> profilePicNotSent;
    List<PieChartSectionData> showingSections() {
      return List.generate(
          2,
              (i) {
                final isTouched = i == 0;
                switch (i) {
                  case 0:
                    return PieChartSectionData(
                      color: Colors.amber[700],
                      value: sent,
                      title: sent.floor().toString() + '%',
                      radius: 45,
                      titleStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xfffffefe)),
                      titlePositionPercentageOffset: 0.55,
                    );
                  case 1:
                    return PieChartSectionData(
                      color: Colors.deepOrangeAccent,
                      value: notSent,
                      title: notSent.ceil().toString() +'%',
                      radius: 45,
                      titleStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xfffffefe)),
                      titlePositionPercentageOffset: 0.55,
                    );
                  default:
                    throw Error();
                }
              });
    }
    if(!memberSent.isEmpty){
      profilePicSent= getProfilePic(url, memberSent);
    }else{
      profilePicSent = [];
    }

    if(!memberNotSent.isEmpty){
      profilePicNotSent= getProfilePic(url, memberNotSent);
    }else{
      profilePicNotSent = [];
    }

    print(profilePicSent);
    GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _globalKey,
        drawer: NavigationDrawer(),
        body: Material(
        elevation: 8,
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.only(left: 16, right: 16, top: 48),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    IconButton(
                        icon: Icon(Icons.menu, color: getTheme(context) ? Colors.white : Colors.black,),
                      onPressed: (){
                          _globalKey.currentState.openDrawer();
                      },
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Profile(username: widget.username,)),
                        );
                      },
                      child: Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: const Color(0xff7c94b6),
                          image: DecorationImage(
                            image: NetworkImage(
                                ImageAddressProvider.imageAddress(
                                    result.data['profile']['githubUsername'], result.data['profile']['profilePic'])),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all( Radius.circular(50.0)),
                          border: Border.all(
                            color: Colors.amber,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: "Dashboard",
                          style: GoogleFonts.poppins(
                              fontSize: 28,
                              color: getTheme(context) ? Colors.white : Colors.black,
                          )
                      ),
                    ),
                    SizedBox(width: 30,),
                    InkWell(
                      onTap: (){
                        showDatePicker(
                          context: context,
                          initialDate: pickedDate,
                          firstDate: DateTime(2018,1),
                          lastDate: DateTime.now().subtract(Duration(hours: 29)),
                        ).then((date) {
                          setState(() {
                            if(date!= null){
                              pickedDate = date;
                            }
                            else{
                              date = pickedDate;
                            }
                          });
                        });
                      },
                      child: Container(
                        alignment: Alignment.topRight,
                        decoration: BoxDecoration(
                          color: getTheme(context) ? Colors.grey[800] : Colors.grey[200],
                          borderRadius:  BorderRadius.all(Radius.circular(10.0)),
                        ),
                        height: 35,
                        width: 100,
                        child: Align(
                          alignment: Alignment.center,
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: " "+ pickedDate.day.toString() + " " +df.format(pickedDate).substring(3,6),
                                    style: TextStyle(color: getTheme(context) ? Colors.white : Colors.black,)),
                                WidgetSpan(child: Icon(Icons.arrow_drop_down, size: 16,))
                              ]
                            ),
                          )
                        )
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Card(
                  elevation: 0,
                  color: Colors.transparent,
                  child:  Column(
                    children: <Widget>[
                      PieChart(
                          PieChartData(
                              sections: showingSections(),
                              centerSpaceRadius: 50,
                              sectionsSpace: 10,
                              borderData: FlBorderData(show: false),
                          ),
                        ),
                      Padding(
                        padding: EdgeInsets.only(left: 100),
                        child: Container(
                         child: Row( children: [
                           Indicator(
                             color: Colors.deepOrangeAccent,
                             text: "Not Sent",
                             textColor: getTheme(context) ? Colors.white : Colors.black,
                             size: 8,
                             isSquare: true,
                           ),
                           SizedBox(width: 20,),
                           Indicator(
                             color: Colors.amber,
                             text: "Sent",
                             textColor: getTheme(context) ? Colors.white : Colors.black,
                             size: 8,
                             isSquare: true,
                           ),
                         ],),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height:30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    RichText(text: TextSpan(
                      text: "Updates",
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          color: getTheme(context) ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500
                        )
                    ))
                  ],
                ),
                SizedBox(
                  height:20,
                ),
                _buildCard("Members Sent", memberSent, profilePicSent, sent, 0, Colors.amber, 0),
                _buildCard("Members Not Sent", memberNotSent, profilePicNotSent, notSent, 1, Colors.deepOrangeAccent,1),
              ],
            ),
          ),
        ),
        )
      );
  }

  Widget _buildCard(String title, dynamic members, List profilePic, dynamic count, int identifier, dynamic color, int index){
    return InkWell(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StatusUpdate(
            appUsername: widget.username,
            url: widget.url,
            index: index,
          ))
        )
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: getTheme(context) ? Colors.grey[800] : Colors.white,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[Align(
                  child: RichText(
                      text: TextSpan(
                          text: title,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: getTheme(context) ? Colors.white : Colors.black,
                          )
                      )),
                ),
                  SizedBox(height: 10,),
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                        text: "Count: ${members.length}",
                        style: TextStyle(
                            fontSize: 12,
                            color: getTheme(context) ? Colors.white : Colors.black,
                        )
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children:<Widget> [
                      Padding(
                        padding: EdgeInsets.only(left: 110,right: 5),
                        child: ImageStack(
                          imageList: profilePic,
                          totalCount: 5,
                          imageBorderColor: getTheme(context) ? Colors.black: Colors.white,
                          imageRadius: 35,
                          imageCount: 5,
                          imageBorderWidth: 1,
                        ),
                      ),
                      RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                            text: members.length<=5?"":"+${members.length-5}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: getTheme(context) ? Colors.white : Colors.black,
                            )
                        ),
                      ),
                    ]
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularPercentIndicator(
                      radius: 60.0,
                      lineWidth: 5.0,
                      percent: count.floor()/100,
                      center: new Text("${identifier == 0 ? count.floor() : count.ceil()}%"),
                      progressColor: color,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  String _buildQuery() {
    return '''
                query {
                        profile(username: "${widget.username}"){
      													  about
                                  batch
                                  email
                                  fullName
                                  githubUsername
                                  gitlabUsername
                                  profilePic  
                                  telegramID                            
                                 }
                        dailyStatusUpdates(date: "${DateFormat("yyyy-MM-dd").format(pickedDate)}"){
                                  date
                                  membersSent {
                                    member {
                                      username
                                      fullName
                                      avatar{
                                        githubUsername
                                      }
                                      profile {
                                        profilePic
                                      }
                                    }
                                  }
                                  memberDidNotSend {
                                    member {
                                      username
                                      fullName
                                      avatar{
                                        githubUsername
                                      }
                                      profile {
                                        profilePic
                                      }
                                    }
                                  }
                                }
                      }''';
  }
}

