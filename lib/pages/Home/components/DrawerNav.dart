import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:storage_management_mobile/pages/login/LoginPage.dart';
import '../../Scanner/ScannerPage.dart';
import '../../Setting/SettingPage.dart';
import '../Homepage.dart';

class HomepageDrawer extends StatelessWidget {
  const HomepageDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Center(
                  child: Text(
                "Settings",
                style: TextStyle(fontSize: 20),
              )),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            ),
            ListTile(
              title: Text(
                "Home",
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialWithModalsPageRoute(builder: (context) {
                    return Homepage();
                  }),
                );
              },
            ),
            ListTile(
              title: Text(
                "Login",
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialWithModalsPageRoute(builder: (context) {
                    return LoginPage();
                  }),
                );
              },
            ),
            ListTile(
              title: Text("Scanner"),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialWithModalsPageRoute(builder: (context) {
                  return ScannerPage();
                }));
              },
            ),
            ListTile(
              key: Key("Settings"),
              title: Text("Settings"),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialWithModalsPageRoute(builder: (context) {
                  return SettingPage();
                }));
              },
            )
          ],
        ),
      ),
    );
  }
}
