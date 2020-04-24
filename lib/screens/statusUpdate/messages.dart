import 'package:cms_mobile/screens/home.dart';
import 'package:cms_mobile/utilities/constants.dart';
import 'package:cms_mobile/utilities/image_address.dart';
import 'package:cms_mobile/utilities/sizeconfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:intl/intl.dart';

class Messages extends StatefulWidget {
  String selectedDate;
  String username;

  Messages(String selectedDate, String username) {
    this.selectedDate = selectedDate;
    this.username = username;
  }

  @override
  MessagesTab createState() => MessagesTab(selectedDate, username);
}

class MessagesTab extends State<Messages> {
  String selectedDate;
  String username;
  bool isConnection = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  MessagesTab(String selectedDate, String username) {
    this.selectedDate = selectedDate;
    this.username = username;
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
            title: Text("Status update message"),
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
              if (result.data['getMemberStatusUpdates'].length == 0) {
                return Center(
                  child: Text('No status updates for this date'),
                );
              }
              print(selectedDate);
              print(result.data['getMemberStatusUpdates'][0]['member']);
              return _membersSentList(result);
            },
          ),
        ),
      ),
    );
  }

  Widget _membersSentList(QueryResult result) {
    final messagesList = result.data['getMemberStatusUpdates'];
    return Column(
      children: <Widget>[
        SizedBox(height: SizeConfig.heightFactor * 20),
        ListView.builder(
            shrinkWrap: true,
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
                  backgroundImage: NetworkImage(
                      ImageAddressProvider.imageAddress(
                          url,
                          messagesList[index]['member']['profile']
                              ['profilePic'])),
                ),
                title:
                    Text(messagesList[index]['member']['fullName'].toString()),
                subtitle: Text("Date: " +
                    selectedDate +
                    "\n" +
                    "Time: " +
                    getDate(messagesList[index]['timestamp'])),
              );
            }),
        SizedBox(
          height: SizeConfig.heightFactor * 40,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 20),
            child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Message: ",
                          style: messageLabelStyle,
                        )),
                    SizedBox(
                      height: SizeConfig.heightFactor * 15,
                    ),
                    MarkdownBody(
                        data: html2md.convert(messagesList[0]['message']))
                  ],
                )),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  String getDate(String date) {
    var dateTime = DateFormat("HH:mm:ss").parse(date.substring(11, 19), true);
    var dateLocal = dateTime.toLocal();
    return dateLocal.toIso8601String().substring(11, 19);
  }

  String _buildQuery() {
    return '''
                query {
                          getMemberStatusUpdates(username:"$username", date:"$selectedDate"){
                              message
                              member{
                                avatar{
                                  githubUsername
                                }
                                fullName
                                profile {
                                  profilePic
                                }
                              }
                              timestamp
                            } 
                      }
            ''';
  }
}
