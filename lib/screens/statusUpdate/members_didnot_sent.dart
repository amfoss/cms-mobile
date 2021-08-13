import 'package:cms_mobile/utilities/image_address.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class MembersDidNotSend extends StatefulWidget {
  String selectedDate;

  MembersDidNotSend(this.selectedDate);

  @override
  MemberDidNotSendTab createState() => MemberDidNotSendTab(selectedDate);
}

class MemberDidNotSendTab extends State<MembersDidNotSend> {
  String selectedDate;

  MemberDidNotSendTab(this.selectedDate);

  @override
  Widget build(BuildContext context) {
    selectedDate = selectedDate.substring(0, 10);
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
              child: Text('Status Update not found'),
            );
          }
          if (result.data['dailyStatusUpdates']['memberDidNotSend'].length ==
              0) {
            return Center(
              child: Text('Everyone Sent their Status Update'),
            );
          }
          if (result.data['dailyStatusUpdates']['memberDidNotSend'].length ==
              0) {
            return Center(
              child: Text('Woohoo!\nEveryone sent an update today.'),
            );
          }
          print(result.data['dailyStatusUpdates']['memberDidNotSend'][0]);
          return _membersSentList(result);
        },
      ),
    );
  }

  Widget _membersSentList(QueryResult result) {
    final membersDidNotSentList = result.data['dailyStatusUpdates'];
    final membersPresent = membersDidNotSentList['memberDidNotSend'];
    return ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 10),
        itemCount: membersPresent.length,
        itemBuilder: (context, index) {
          String url = membersDidNotSentList['memberDidNotSend'][index]
              ['member']['avatar']['githubUsername'];
          if (url == null) {
            url = 'github';
          }
          return ListTile(
            leading: new CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(ImageAddressProvider.imageAddress(
                  url,
                  membersDidNotSentList['memberDidNotSend'][index]['member']
                      ['profile']['profilePic'])),
            ),
            title: Text(membersDidNotSentList['memberDidNotSend'][index]
                ['member']['fullName'],
                style: GoogleFonts.poppins(
                  fontSize: 14,
                )),
            subtitle: Text("@" +
                membersDidNotSentList['memberDidNotSend'][index]['member']
                    ['username'],
                style: GoogleFonts.poppins(
                  fontSize: 12,
                )),
          );
        },
        separatorBuilder: (context, index) => Divider());
  }

  String _buildQuery() {
    return '''
                      query {
                        dailyStatusUpdates(date: "$selectedDate") {
                                  date
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
