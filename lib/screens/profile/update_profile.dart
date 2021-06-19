import 'package:cms_mobile/screens/home.dart';
import 'package:cms_mobile/utilities/constants.dart';
import 'package:cms_mobile/utilities/sizeconfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UpdateProfile extends StatefulWidget {
  @override
  UpdateProfileScreen createState() => UpdateProfileScreen();
}

class UpdateProfileScreen extends State<UpdateProfile> {
  final String username = HomePageScreen.username;

  bool isConnection = true;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _firstNameController = new TextEditingController();
  TextEditingController _lastNameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _customEmailController = new TextEditingController();
  TextEditingController _phoneNumberController = new TextEditingController();
  TextEditingController _githubUsernameController = new TextEditingController();
  TextEditingController _gitlabUsernameController = new TextEditingController();
  TextEditingController _rollNumberController = new TextEditingController();
  TextEditingController _batchController = new TextEditingController();
  TextEditingController _aboutController = new TextEditingController();

  String about,
      batch,
      email,
      firstName,
      githubUsername,
      lastName,
      phoneNo,
      roll,
      gitlabUsername,
      customEmail;

  @override
  Widget build(BuildContext context) {
    final theme = getTheme(context);
    final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      GraphQLClient(link: HomePageScreen.url, cache: InMemoryCache()),
    );

    GraphQLClient graphQLClient =
        new GraphQLClient(link: HomePageScreen.url, cache: InMemoryCache());

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
            title: Text("Update Profile"),
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
              if (result.data['profile'].length == 0) {
                return Center(
                  child: Text('No status updates for this date'),
                );
              }
              print(result.data['profile']);
              _fillTextFormFields(result);
              return Container(
                height: double.infinity,
                child: ListView(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.widthFactor * 30.0,
                      vertical: SizeConfig.widthFactor * 20.0),
                  children: <Widget>[
                    _buildTextField(
                        "Username", "Enter your username", _usernameController, theme, FlutterIcons.person_mdi),
                    _buildTextField("First Name", "Enter your First Name",
                        _firstNameController, theme, FlutterIcons.first_page_mdi),
                    _buildTextField("Last Name", "Enter your Last Name",
                        _lastNameController, theme, FlutterIcons.last_page_mdi),
                    _buildTextField(
                        "Email", "Enter your Email", _emailController, theme, Icons.email),
                    _buildTextField("Custom Email", "Enter your Custom Email",
                        _customEmailController, theme, Icons.alternate_email),
                    _buildTextField("Phone Number", "Enter your Phone Number",
                        _phoneNumberController, theme, Icons.phone),
                    _buildTextField(
                        "GitHub Username",
                        "Enter your GitHub username",
                        _githubUsernameController, theme, FlutterIcons.github_faw5d),
                    _buildTextField(
                        "GitLab Username",
                        "Enter your GitLab username",
                        _gitlabUsernameController, theme, FlutterIcons.gitlab_faw5d),
                    _buildTextField("Roll Number", "Enter your Roll number",
                        _rollNumberController, theme, FlutterIcons.list_alt_faw),
                    _buildTextField(
                        "Batch", "Enter your Batch", _batchController, theme, FlutterIcons.graduation_cap_faw),
                    _buildTextField("About", "Enter About", _aboutController, theme, FlutterIcons.info_outline_mdi),
                    _buildUpdateBtn(graphQLClient, context),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  _fillTextFormFields(QueryResult result) {
    _usernameController.text = HomePageScreen.username;
    _firstNameController.text = result.data['profile']['firstName'];
    _lastNameController.text = result.data['profile']['lastName'];
    _emailController.text = result.data['profile']['email'];
    _customEmailController.text = result.data['profile']['customEmail'];
    _phoneNumberController.text = result.data['profile']['phone'];
    _githubUsernameController.text = result.data['profile']['githubUsername'];
    _gitlabUsernameController.text = result.data['profile']['gitlabUsername'];
    _rollNumberController.text = result.data['profile']['roll'];
    _batchController.text = result.data['profile']['batch'];
    _aboutController.text = result.data['profile']['about'];
  }

  _getTexts() {
    about = _aboutController.text;
    firstName = _firstNameController.text;
    lastName = _lastNameController.text;
    email = _emailController.text;
    phoneNo = _phoneNumberController.text;
    githubUsername = _githubUsernameController.text;
    roll = _rollNumberController.text;
    batch = _batchController.text;
    about = _aboutController.text;
    gitlabUsername = _gitlabUsernameController.text;
    customEmail = _customEmailController.text;
  }

  Widget _buildUpdateBtn(GraphQLClient client, BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.heightFactor * 25.0,
            horizontal: SizeConfig.widthFactor * 30),
        width: double.infinity,
        child: RaisedButton(
          elevation: SizeConfig.widthFactor * 5.0,
          padding: EdgeInsets.all(SizeConfig.aspectRation * 15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SizeConfig.aspectRation * 30.0),
          ),
          color: appPrimaryColor,
          child: Text(
            'UPDATE',
            style: TextStyle(
              color: Colors.black,
              letterSpacing: SizeConfig.widthFactor * 1.5,
              fontSize: SizeConfig.widthFactor * 16.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
          onPressed: () async {
            GraphQLClient _client = GraphQLClient(
                link: HomePageScreen.url,
                cache: OptimisticCache(
                    dataIdFromObject: typenameDataIdFromObject));
            QueryResult result = await _client
                .mutate(MutationOptions(document: _updateMutation()));

            if (result.data['UpdateProfile']['id'] != null) {
              final snackBar = SnackBar(content: Text('Profile Updated'));
              _scaffoldKey.currentState.showSnackBar(snackBar);
            } else {
              final snackBar =
                  SnackBar(content: Text('Something error occoured'));
              _scaffoldKey.currentState.showSnackBar(snackBar);
            }
          },
        ));
  }

  Widget _buildTextField(String title, String hintText,
      TextEditingController textEditingController, bool theme, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: kLabelStyle,
        ),
        SizedBox(height: SizeConfig.heightFactor * 10.0),
        Container(
          alignment: Alignment.centerLeft,
          height: SizeConfig.heightFactor * 50.0,
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            controller: textEditingController,
            style: TextStyle(
              color: theme ? Colors.white : Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.all(Radius.circular(30))
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.amber),
                borderRadius: BorderRadius.all(Radius.circular(30))
              ),
              prefixIcon: Icon(icon,color: theme ? Colors.white : Colors.black,),
              filled: true,
              fillColor: theme ? Colors.grey[1000] :Colors.grey[200],
              hintText: hintText,
              hintStyle: TextStyle(
                color: theme ? Colors.white38 : Colors.black38,
                fontFamily: 'OpenSans'
              ),
            ),
          ),
        ),
        SizedBox(
          height: SizeConfig.heightFactor * 20,
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  String _buildQuery() {
    return '''
                query 
                {
                    profile(username: "$username") {
                      about
                      batch
                      email
                      firstName
                      lastName
                      phone
                      roll
                      githubUsername
                      gitlabUsername
                      customEmail
                    }
                  }
            ''';
  }

  String _updateMutation() {
    _getTexts();
    return '''
            mutation {
                UpdateProfile(about: "${_aboutController.text}", 
                batch: ${int.parse(_batchController.text)}, 
                email: "${_emailController.text}", 
                customEmail: "${_customEmailController.text}", 
                firstName: "${_firstNameController.text}", 
                githubUsername: "${_githubUsernameController.text}", 
                gitlabUsername: "${_gitlabUsernameController.text}", 
                lastName: "${_lastNameController.text}", 
                phoneNo: "${_phoneNumberController.text}", 
                roll: "${_rollNumberController.text}", 
                username: "${_usernameController.text}") {
                  id
                }
              }
            ''';
  }
}
