import 'package:cms_mobile/screens/home.dart';
import 'package:cms_mobile/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:intl/intl.dart';

class UserUpdates extends StatefulWidget {
  String username;

  UserUpdates(String username) {
    this.username = username;
  }

  @override
  _MessagesList createState() => _MessagesList(username);
}

class _MessagesList extends State<UserUpdates> {
  String username;
  static String _searchText = "";
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Updates');
  final TextEditingController _controller = new TextEditingController();

  _MessagesList(String username) {
    this.username = username;
    _searchText = username;
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(onChange);
  }

  void onChange(){
    _searchText = _controller.text;
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
          title: _appBarTitle,
          actions: <Widget>[
            IconButton(
              icon: _searchIcon,
              onPressed: () {
                _searchPressed();
              },
            ),
          ],
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
                child: Text('Please enter a valid username'),
              );
            }
            print(result.data['getMemberStatusUpdates'][0]['member']);
            return _membersSentList(result);
          },
        ),
      ),
    );
  }

  void _searchPressed() {
    setState(() {
      if (_searchIcon.icon == Icons.search) {
        _searchText = "";
        _searchIcon = new Icon(Icons.done);
        _appBarTitle = new TextField(
          controller: _controller,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search), hintText: 'Enter Username'),
          autofocus: true,
        );
      } else {
        _searchIcon = new Icon(Icons.search);
        _appBarTitle = new Text('Updates');
        build(context);
      }
    });
  }

  Widget _membersSentList(QueryResult result) {
    final messagesList = result.data['getMemberStatusUpdates'];
    return ListView.separated(
        shrinkWrap: true,
        itemCount: messagesList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              "Name: " +
                  messagesList[index]['member']['fullName'].toString() +
                  "\nDate: " +
                  messagesList[index]['date'] +
                  "\nTime: " +
                  getDate(messagesList[index]['timestamp']) +
                  "\nMessage:\n",
              style: userUpdateHeadings,
            ),
            subtitle:
                MarkdownBody(data: html2md.convert(messagesList[0]['message'])),
          );
        },
        separatorBuilder: (context, index) => Divider());
  }

  String getDate(String date) {
    var dateTime = DateFormat("HH:mm:ss").parse(date.substring(11, 19), true);
    var dateLocal = dateTime.toLocal();
    return dateLocal.toIso8601String().substring(11, 19);
  }

  String _buildQuery() {
    return '''
                query {
                          getMemberStatusUpdates(username:"$_searchText"){
                              message
                              member{
                                avatar{
                                  githubUsername
                                }
                                fullName
                              }
                              date
                              timestamp
                            }                          
                      }
            ''';
  }
}
