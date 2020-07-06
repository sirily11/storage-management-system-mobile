import 'package:flutter/material.dart';
import '../Scanner/ScannerPage.dart';
import '../Setting/SettingPage.dart';
import 'Homepage.dart';

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
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Homepage();
                }));
              },
            ),
            ListTile(
              title: Text("Scanner"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ScannerPage();
                }));
              },
            ),
            ListTile(
              title: Text("Settings"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
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
