import 'package:cms_mobile/utilities/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utilities/sizeconfig.dart';

class About extends StatefulWidget {
  @override
  _AboutScreen createState() => _AboutScreen();
}

class _AboutScreen extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: appPrimaryColor, title: Text("About")),
      body: Column(
        children: <Widget>[
          _appIcon(),
          _amFOSSLogo(),
          _aboutText(
              "This is a flutter application for the amFOSS CMS. Club members can login into the CMS using the app and view club attendence, their profile and status updates.",
              null,
              null),
          _aboutText(
              "amFOSS is a student-run community with over 50+ members from Amrita Vishwa Vidyapeetham, Amritapuri. Know more about us ",
              "here",
              "https://amfoss.in"),
          _links(Icons.code, 'The app is open source, with the code ', "here",
              "https://gitlab.com/amfoss/cms-mobile"),
          _links(Icons.error, "Issues can be reported ", "here",
              "https://gitlab.com/amfoss/cms-mobile/-/issues"),
          _links(Icons.person_outline, "App developers can be found ", "here",
              "https://gitlab.com/amfoss/cms-mobile/-/graphs/master")
        ],
      ),
    );
  }

  Widget _appIcon() {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Image.asset('assets/launcher/icon.png'),
      height: SizeConfig.heightFactor * 150,
    );
  }

  Widget _amFOSSLogo() {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 20),
      child: Image.asset('assets/images/amfoss.jpg'),
      width: SizeConfig.screenWidth / 2.5,
    );
  }

  Widget _aboutText(String normalText, String richText, String url) {
    return ListTile(
      title: new RichText(
        text: new TextSpan(
          children: [
            new TextSpan(
              text: normalText,
              style: new TextStyle(color: Colors.black, fontSize: 14),
            ),
            new TextSpan(
              text: richText,
              style: new TextStyle(color: Colors.blue, fontSize: 14),
              recognizer: new TapGestureRecognizer()
                ..onTap = () {
                  _launchURL(url);
                },
            ),
          ],
        ),
      ),
    );
  }

  Widget _links(IconData icon, String normalText, String richText, String url) {
    return ListTile(
      leading: Icon(icon),
      title: new RichText(
        text: new TextSpan(
          children: [
            new TextSpan(
              text: normalText,
              style: new TextStyle(color: Colors.black, fontSize: 14),
            ),
            new TextSpan(
              text: richText,
              style: new TextStyle(color: Colors.blue, fontSize: 14),
              recognizer: new TapGestureRecognizer()
                ..onTap = () {
                  _launchURL(url);
                },
            ),
          ],
        ),
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
