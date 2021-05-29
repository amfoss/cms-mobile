import 'package:cms_mobile/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import 'data/user_database.dart';
import 'screens/home.dart';

class CMS extends StatefulWidget {
  @override
  _CMS createState() => _CMS();
}

class _CMS extends State<CMS> {
  Link link;
  String username;
  String token;
  final HttpLink httpLink = HttpLink(
    uri: 'https://api.amfoss.in/',
  );
  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context, listen: false);
    return FutureBuilder(
      future: db.getSingleUser(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Container(color: Colors.white);
        else if (snapshot.data == null)
          return LoginScreen();
        else if (snapshot.hasData) {
          final refreshCred = snapshot.data.refreshToken;
          if(refreshCred == null){
            return LoginScreen();
          }
          final split = refreshCred.split(' ');
          final username = snapshot.data.username;
          final password = split[1];
          setToken(username, password).then((value){
            token = value;
          });
          final AuthLink authLink = AuthLink(
            getToken: () async => 'JWT $token',
          );
          link = authLink.concat(httpLink);
          return HomePage(
            username: username,
            url: link,
          );
        } else
          return Container(color: Colors.white,);
      },
    );
  }

  setToken(String username, String password) async{
    final String authMutation = '''
                        mutation{
                          tokenAuth(username:"$username", password:"$password") {
                            token
                            }
                        }
                        ''';

    GraphQLClient _client = GraphQLClient(
        link: httpLink,
        cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject));
    QueryResult result =
    await _client.mutate(MutationOptions(document: authMutation));

    String refreshedToken = result.data['tokenAuth']['token'];
    return refreshedToken;
  }
}
