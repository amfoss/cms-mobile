import 'package:cms_mobile/screens/home.dart';
import 'package:cms_mobile/utilities/constants.dart';
import 'package:cms_mobile/utilities/sizeconfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../data/user_database.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool passwordInvisible = true;
  bool userExist = false;
  String refreshCred;
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  FocusNode _usernameFocus = new FocusNode();
  FocusNode _passwordFocus = new FocusNode();

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  _onLoginPress() async {
    final db = Provider.of<AppDatabase>(context, listen: false);
    if (_usernameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      final String authMutation = '''
                        mutation{
                          tokenAuth(username:"${_usernameController.text}", password:"${_passwordController.text}") {
                            token
                            }
                        }
                        ''';

      final HttpLink httpLink = HttpLink(
        uri: 'https://api.amfoss.in/',
      );
      GraphQLClient _client = GraphQLClient(
          link: httpLink,
          cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject));
      QueryResult result;
      String token;
      try {
        result = await _client.mutate(MutationOptions(document: authMutation));
        token = result.data['tokenAuth']['token'];
        userExist = true;
      }on NoSuchMethodError catch(e){
        print(e);
      }

      final AuthLink authLink = AuthLink(
        getToken: () async => 'JWT $token',
      );
      final Link link = authLink.concat(httpLink);
      refreshCred = _usernameController.text + " " + _passwordController.text;

      User user = User(authToken: token, username: _usernameController.text, refreshToken: refreshCred);
      db.getSingleUser().then((userFromDb) {
        if(!userExist){
          Toast.show("Invalid username or password", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }else if (userFromDb == null)
          db.insertUser(user).then((onValue) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(
                  username: _usernameController.text,
                  url: link,
                ),
              ),
            );
          });
      });
    } else {
      Toast.show("Please enter the required fields", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          height: SizeConfig.heightFactor * 60.0,
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            controller: _usernameController,
            textInputAction: TextInputAction.next,
            focusNode: _usernameFocus,
            onSubmitted: (term) {
              _fieldFocusChange(context, _usernameFocus, _passwordFocus);
            },
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).accentColor,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                  )
              ),
              contentPadding:
                  EdgeInsets.only(top: SizeConfig.heightFactor * 14.0),
              prefixIcon: Icon(
                Icons.account_circle,
                color: Theme.of(context).accentColor,
              ),
              hintText: 'Username',
              hintStyle: loginHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          height: SizeConfig.heightFactor * 60.0,
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            enableSuggestions: false,
            autocorrect: false,
            controller: _passwordController,
            textInputAction: TextInputAction.done,
            focusNode: _passwordFocus,
            onSubmitted: (value) {
              _passwordFocus.unfocus();
              _onLoginPress();
            },
            obscureText: passwordInvisible,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).accentColor,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                )
              ),
              contentPadding:
                  EdgeInsets.only(top: SizeConfig.heightFactor * 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Theme.of(context).accentColor,
              ),
              hintText: 'Password',
              hintStyle: loginHintTextStyle,
              suffixIcon: IconButton(
                icon: Icon(
                  passwordInvisible ? Icons.visibility_off : Icons.visibility,
                  color: passwordInvisible ? Colors.white60 : Theme.of(context).accentColor,
                ),
                onPressed: () {
                  setState(() {
                    passwordInvisible = !passwordInvisible;
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginBtn() {
    return Container(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Theme.of(context).primaryColor,
            elevation: SizeConfig.widthFactor*5,
            padding: EdgeInsets.all(SizeConfig.aspectRation * 15.0),
              shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                  )
              ),
          child: Text(
            'LOGIN',
            style: TextStyle(
              color: Colors.black,
              letterSpacing: SizeConfig.widthFactor * 1.5,
              fontSize: SizeConfig.widthFactor * 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
          onPressed: _onLoginPress,
        ));
  }

  Widget _buildSignInWithLogo() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Image.asset(
        'assets/images/amfoss.png',
        width: SizeConfig.screenWidth / 3,
        alignment: Alignment.bottomCenter,
      ),
    );
  }

  Widget _buildLogoCMS() {
    return Image.asset(
      'assets/images/cms.png',
      width: SizeConfig.screenWidth / 2,
      alignment: Alignment.topCenter,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              _buildSignInWithLogo(),
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      //use amfoss api later to fetch a custom image1
                        'https://images.unsplash.com/photo-1485841938031-1bf81239b815?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=614&q=80'
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x00000000),
                      Color(0xff000000)
                    ],
                    stops: [0.1,0.40],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.widthFactor * 40.0,
                ),
                height: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: SizeConfig.heightFactor * 110.0),
                    _buildLogoCMS(),
                    SizedBox(height: SizeConfig.heightFactor * 145.0),
                    _buildEmailTF(),
                    SizedBox(
                      height: SizeConfig.heightFactor * 8.0,
                    ),
                    _buildPasswordTF(),
                    SizedBox(
                      height: SizeConfig.heightFactor * 40,
                    ),
                    _buildLoginBtn(),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: _buildSignInWithLogo(),
              ),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
