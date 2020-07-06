import 'package:flutter/material.dart';
import 'package:json_schema_form/json_textform/JSONSchemaForm.dart';
import 'package:provider/provider.dart';
import 'package:storage_management_mobile/States/LoginProvider.dart';
import 'package:storage_management_mobile/pages/Home/DrawerNav.dart';

final List<Map<String, dynamic>> loginSchema = [
  {
    "label": "Login User Name",
    "readonly": false,
    "extra": {"help": "Please Enter your user name", "default": ""},
    "name": "username",
    "widget": "text",
    "required": true,
    "translated": false,
    "validations": {
      "length": {"maximum": 1024}
    }
  },
  {
    "label": "Password",
    "readonly": false,
    "extra": {"help": "Please Enter your password", "default": ""},
    "name": "password",
    "widget": "text",
    "required": true,
    "translated": false,
    "validations": {
      "length": {"maximum": 1024}
    }
  }
];

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  String error;

  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(isLoading ? "Loading..." : "Login"),
      ),
      body: !loginProvider.hasLogined
          ? JSONSchemaForm(
              schema: loginSchema,
              onFetchingSchema: null,
              onFetchingForignKeyChoices: null,
              onAddForignKeyField: null,
              onUpdateForignKeyField: null,
              onSubmit: (v) async {
                try {
                  setState(() {
                    isLoading = true;
                  });
                  await loginProvider.signIn(v['username'], v['password']);
                } catch (err) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Error"),
                      content: Text("$error"),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("OK"),
                        )
                      ],
                    ),
                  );
                } finally {
                  setState(() {
                    isLoading = false;
                  });
                }
              },
            )
          : Center(
              child: RaisedButton(
                child: Text("Sign Out"),
              ),
            ),
      drawer: HomepageDrawer(),
    );
  }
}
