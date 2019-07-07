import 'package:flutter/material.dart';
import 'package:mobile/Home/Homepage.dart';
import 'package:mobile/Scanner/ScannerPage.dart';

class HomepageDrawer extends StatelessWidget {
  const HomepageDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Center(
                child: Text(
              "Settings",
              style: TextStyle(fontSize: 20, color: Colors.white),
            )),
            decoration: BoxDecoration(color: Colors.blue),
          ),
          ListTile(
            title: Text("Home"),
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
          )
        ],
      ),
    );
  }
}
