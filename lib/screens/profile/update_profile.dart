import 'package:cms_mobile/screens/home.dart';
import 'package:cms_mobile/utilities/constants.dart';
import 'package:cms_mobile/utilities/sizeconfig.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UpdateProfile extends StatefulWidget {
  @override
  UpdateProfileScreen createState() => UpdateProfileScreen();
}

class UpdateProfileScreen extends State<UpdateProfile> {
  final String username = HomePageScreen.username;

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
    final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      GraphQLClient(link: HomePageScreen.url, cache: InMemoryCache()),
    );

    GraphQLClient graphQLClient =
        new GraphQLClient(link: HomePageScreen.url, cache: InMemoryCache());

    return GraphQLProvider(
      client: client,
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
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.widthFactor * 30.0,
                  vertical: SizeConfig.widthFactor * 20.0),
              height: double.infinity,
              child: ListView(
                children: <Widget>[
                  _buildTextField(
                      "username", "Enter your username", _usernameController),
                  _buildTextField("First Name", "Enter your First Name",
                      _firstNameController),
                  _buildTextField(
                      "Last Name", "Enter your Last Name", _lastNameController),
                  _buildTextField(
                      "Email", "Enter your Email", _emailController),
                  _buildTextField(
                      "Custom Email", "Enter your Custom Email", _customEmailController),
                  _buildTextField("Phone Number", "Enter your Phone Number",
                      _phoneNumberController),
                  _buildTextField("GitHub Username",
                      "Enter your GitHub username", _githubUsernameController),
                  _buildTextField("GitLab Username",
                      "Enter your GitLab username", _gitlabUsernameController),
                  _buildTextField("Roll Number", "Enter your Roll number",
                      _rollNumberController),
                  _buildTextField(
                      "Batch", "Enter your Batch", _batchController),
                  _buildTextField("About", "Enter About", _aboutController),
                  _buildUpdateBtn(graphQLClient, context),
                ],
              ),
            );
          },
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
              fontSize: SizeConfig.widthFactor * 18.0,
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
      TextEditingController textEditingController) {
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
          decoration: kBoxDecorationStyle,
          height: SizeConfig.heightFactor * 60.0,
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            controller: textEditingController,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.widthFactor * 10.0,
                  vertical: SizeConfig.heightFactor * 10),
              hintText: hintText,
              hintStyle: kHintTextStyle,
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
