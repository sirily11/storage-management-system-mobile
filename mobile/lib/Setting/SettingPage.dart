import 'package:flutter/material.dart';
import 'package:mobile/Home/DrawerNav.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomepageDrawer(),
      appBar: AppBar(
        title: Text("Settings"),
      ),
    );
  }
}
