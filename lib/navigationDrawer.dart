//import 'dart:js';
import 'package:cms_mobile/data/user_database.dart';
import 'package:cms_mobile/screens/login_screen.dart';
import 'package:cms_mobile/utilities/constants.dart';
import 'package:cms_mobile/utilities/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class NavigationDrawer extends StatelessWidget{
  ContextAction context;
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      child: Container(
        width: 250,
        child: Drawer(
          child: Material(
            color: Colors.white,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              children: <Widget>[
                const SizedBox(height: 50,),
                _buildMenuItem(
                    text: "Dashboard",
                    icon: Icons.speed
                ),
                _buildMenuItem(
                    text:"User Updates",
                    icon:Icons.note
                ),
                _buildMenuItem(
                    text:"Settings",
                    icon: Icons.settings
                ),
                _buildMenuItem(
                    text:"About",
                    icon: Icons.info),
                _buildMenuItem(
                    text: getTheme(context) ? 'Light Mode' : 'Dark Mode',
                    icon: getTheme(context)
                        ? FlutterIcons.weather_sunny_mco
                        : FlutterIcons.weather_night_mco,
                    onTap: () => darkMode(themeChange)),
                _buildMenuItem(
                    text:"Log out",
                    icon: Icons.exit_to_app,
                    onTap: () => logout(context),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({String text, IconData icon,GestureTapCallback onTap}){
    final color = Colors.black;
    return ListTile(
      leading: Icon(icon, color: color,),
      title: Text(text, style: TextStyle(color: color),),
      onTap: onTap,
    );
  }

  logout(BuildContext context) {
    final db = Provider.of<AppDatabase>(context, listen: false);
    Provider.of<AppDatabase>(context, listen: false);
    db.getSingleUser().then((userFromDb) {
      db.deleteUser(userFromDb).then((onValue) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      });
    });
  }

  darkMode(DarkThemeProvider themeChange) {
    if (themeChange.darkTheme) {
      themeChange.darkTheme = false;
    } else {
      themeChange.darkTheme = true;
    }
  }
}