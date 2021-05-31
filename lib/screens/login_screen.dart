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
  bool _rememberMe = false;
  bool passwordInvisible = true;
  bool userExist = false;
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

      User user = User(authToken: token, username: _usernameController.text);
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
        Text(
          'Username',
          style: loginLabelStyle,
        ),
        SizedBox(height: SizeConfig.heightFactor * 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: loginBoxDecorationStyle,
          height: SizeConfig.heightFactor * 60.0,
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: _usernameController,
            textInputAction: TextInputAction.next,
            focusNode: _usernameFocus,
            onFieldSubmitted: (term) {
              _fieldFocusChange(context, _usernameFocus, _passwordFocus);
            },
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.only(top: SizeConfig.heightFactor * 14.0),
              prefixIcon: Icon(
                Icons.account_circle,
                color: Colors.white54,
              ),
              hintText: 'Enter your Username',
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
        Text(
          'Password',
          style: loginLabelStyle,
        ),
        SizedBox(height: SizeConfig.heightFactor * 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: loginBoxDecorationStyle,
          height: SizeConfig.heightFactor * 60.0,
          child: TextFormField(
            controller: _passwordController,
            textInputAction: TextInputAction.done,
            focusNode: _passwordFocus,
            onFieldSubmitted: (value) {
              _passwordFocus.unfocus();
              _onLoginPress();
            },
            obscureText: passwordInvisible,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.only(top: SizeConfig.heightFactor * 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white54,
              ),
              hintText: 'Enter your Password',
              hintStyle: loginHintTextStyle,
              suffixIcon: IconButton(
                icon: Icon(
                  passwordInvisible ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white54,
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

  Widget _buildRememberMeCheckbox() {
    return Container(
      height: SizeConfig.heightFactor * 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.black),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.amberAccent,
              activeColor: Colors.black,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value;
                });
              },
            ),
          ),
          Text(
            'Remember me',
            style: loginLabelStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: SizeConfig.heightFactor * 25.0),
        width: double.infinity,
        child: RaisedButton(
          elevation: SizeConfig.widthFactor * 5.0,
          padding: EdgeInsets.all(SizeConfig.aspectRation * 15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SizeConfig.aspectRation * 30.0),
          ),
          color: Colors.amber,
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

  Widget _buildFromText() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 60),
      child: Text(
        'From',
        style: loginLabelStyle,
      ),
    );
  }

  Widget _buildSignInWithLogo() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Image.asset(
        'assets/images/amfoss_dark.jpg',
        width: SizeConfig.screenWidth / 2.5,
        alignment: Alignment.bottomCenter,
      ),
    );
  }

  Widget _buildLogoCMS() {
    return Image.asset(
      'assets/images/cms.jpg',
      width: SizeConfig.screenWidth / 1.5,
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
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black,
                      Colors.black,
                      Colors.black,
                      Colors.black,
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.widthFactor * 40.0,
                ),
                height: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildLogoCMS(),
                    SizedBox(height: SizeConfig.heightFactor * 30.0),
                    _buildEmailTF(),
                    SizedBox(
                      height: SizeConfig.heightFactor * 30.0,
                    ),
                    _buildPasswordTF(),
                    // TODO: Implement remember me
                    // _buildRememberMeCheckbox(),
                    SizedBox(
                      height: SizeConfig.heightFactor * 30,
                    ),
                    _buildLoginBtn(),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: _buildFromText(),
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
