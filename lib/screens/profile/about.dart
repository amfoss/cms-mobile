import 'package:cms_mobile/utilities/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
          amfossLogo(),
          SizedBox(height: 50),
          aboutApp(),
          SizedBox(
            height: 50,
          ),
          links('This app is opensource you can find it, ', "here",
              "https://gitlab.com/amfoss/cms-mobile"),
          SizedBox(
            height: 15,
          ),
          links("If you find any issues please open it, ", "here",
              "https://gitlab.com/amfoss/cms-mobile/-/issues"),
          SizedBox(
            height: 15,
          ),
          links("You can find the developers of this app, ", "here",
              "https://gitlab.com/amfoss/cms-mobile/-/graphs/master")
        ],
      ),
    );
  }

  Widget amfossLogo() {
    return Container(
        padding: EdgeInsets.only(top: 30),
        child: Image.asset('assets/images/amfoss.jpg'));
  }

  Widget aboutApp() {
    return Text("// about app");
  }

  Widget links(String normalText, String richText, String url) {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(left: 5),
      child: new RichText(
        text: new TextSpan(
          children: [
            new TextSpan(
              text: normalText,
              style: new TextStyle(color: Colors.black, fontSize: 16),
            ),
            new TextSpan(
              text: richText,
              style: new TextStyle(color: Colors.blue, fontSize: 16),
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
