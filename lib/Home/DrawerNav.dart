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
        color: Color.fromRGBO(58, 66, 80, 9.0),
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Center(
                  child: Text(
                "Settings",
                style: TextStyle(fontSize: 20, color: Colors.white),
              )),
              decoration: BoxDecoration(
                color: Color.fromRGBO(58, 66, 86, 1.0),
              ),
            ),
            ListTile(
              title: Text(
                "Home",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Homepage();
                }));
              },
            ),
            ListTile(
              title: Text("Scanner", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ScannerPage();
                }));
              },
            ),
            ListTile(
              title: Text("Settings", style: TextStyle(color: Colors.white)),
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
