import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Edit/CardTheme.dart';
import '../Home/DrawerNav.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final TextEditingController _websocket = TextEditingController();
  final TextEditingController _server = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final wsPath = "websocket";
  final serverPath = "server";

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      _websocket.text = prefs.getString(wsPath);
      _server.text = prefs.getString(serverPath);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: HomepageDrawer(),
        appBar: AppBar(
          title: Text("Settings"),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: "服务器",
              ),
              Tab(
                text: "WebSocket",
              )
            ],
          ),
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: TabBarView(
            children: <Widget>[
              AddressForm(
                _server,
                serverPath,
                onSaved: () => _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text("已经保存"),
                )),
              ),
              AddressForm(
                _websocket,
                wsPath,
                onSaved: () => _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text("已经保存"),
                )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AddressForm extends StatelessWidget {
  final TextEditingController _controller;
  final String to;
  final Function onSaved;
  AddressForm(this._controller, this.to, {this.onSaved});

  @override
  Widget build(BuildContext context) {
    return CardSelectorTheme(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _controller,
              autovalidate: true,
              style: Theme.of(context).textTheme.body1,
              validator: (str) {
                if (!(str.startsWith("http") | str.startsWith("https"))) {
                  return "Invalid URL";
                }
                if (str.endsWith("/")) {
                  return "Invalid URL";
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: "Server Address",
                labelStyle:
                    Theme.of(context).textTheme.body1.copyWith(fontSize: 18),
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(15.0),
                  borderSide: new BorderSide(),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                RaisedButton(
                  child: Text("Save"),
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                              child: new Wrap(
                            children: <Widget>[
                              new ListTile(
                                  leading: new Icon(Icons.save),
                                  title: new Text('Save'),
                                  onTap: () async {
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setString(to, _controller.text);
                                    Navigator.pop(context);
                                    onSaved();
                                  }),
                              new ListTile(
                                leading: new Icon(Icons.clear),
                                title: new Text('Cancel'),
                                onTap: () => Navigator.pop(context),
                              ),
                            ],
                          ));
                        });
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
