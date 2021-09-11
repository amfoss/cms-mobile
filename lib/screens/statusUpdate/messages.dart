import 'package:cms_mobile/utilities/constants.dart';
import 'package:cms_mobile/utilities/image_address.dart';
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
  Link url;

  Messages(String selectedDate, String username, Link url) {
    this.selectedDate = selectedDate;
    this.username = username;
    this.url = url;
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
      GraphQLClient(link: widget.url, cache: InMemoryCache()),
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
              return _membersSentList(result);
            },
          ),
        ),
      ),
    );
  }

  Widget _membersSentList(QueryResult result) {
    final messagesList = result.data['getMemberStatusUpdates'];
    final df = new DateFormat('dd-MMM-yyyy');
    DateTime date = new DateFormat("yyyy-MM-dd").parse(selectedDate);
    String url =
    messagesList[0]['member']['avatar']['githubUsername'];
    if (url == null) {
      url = 'github';
    }
    return Scaffold(
      body: Material(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: getTheme(context) ? Colors.grey[900] :Color.fromRGBO(0, 26, 51, 10),
                padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {Navigator.of(context).pop();},
                          icon: Icon(Icons.arrow_back,color: Colors.white,),
                        ),
                        Text("$username",
                        style: TextStyle(
                          fontSize: 18,
                            color: Colors.white,
                        ),),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.info_outline,color: Colors.white),
                        ),
                      ],
                    ),
                    Divider(
                      height: 10,
                      indent: 30,
                      endIndent: 30,
                      color: Colors.grey[800],
                    ),
                    SizedBox(height: 15,),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey,
                              backgroundImage: NetworkImage(
                                  ImageAddressProvider.imageAddress(
                                      url,
                                      messagesList[0]['member']['profile']
                                      ['profilePic'])),
                            ),
                            SizedBox(width: 20,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(messagesList[0]['member']['fullName'].toString(),
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white
                                ),),
                                Text("on: " + date.day.toString() + " " + df.format(date).substring(3,6),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey
                                    )
                                )
                              ],
                            )
                          ],
                        ),
                        Text(getDate(messagesList[0]['timestamp'],),
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey
                          ),)
                      ],
                    ),
                    SizedBox(height: 20,)
                  ],
                ),
              ),
              displayMessage((messagesList[0]['message'])),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  Widget displayMessage(String message){
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 40, bottom: 40),
      child: MarkdownBody(
        data: html2md.convert(message).replaceAll('\\', '').replaceAll('*', '**').replaceAll(': **', ':** '),
        styleSheet: MarkdownStyleSheet(
          textScaleFactor: 1.15,
        ),
      ),
    );
  }

  String getDate(String date) {
    var dateTime = DateFormat("HH:mm:ss").parse(date.substring(11, 19), true);
    var dateLocal = dateTime.toLocal();
    return DateFormat('hh:mm a').format(dateLocal);
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
