import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:json_schema_form/JSONSchemaForm.dart';
import 'package:json_schema_form/models/Action.dart';
import 'package:json_schema_form/models/Icon.dart';
import 'package:mobile/utils/utils.dart';

class NewEditPage extends StatefulWidget {
  final Map<String, dynamic> values;
  final int id;

  NewEditPage({this.values, this.id});

  @override
  _NewEditPageState createState() => _NewEditPageState();
}

class _NewEditPageState extends State<NewEditPage> {
  GlobalKey<ScaffoldState> key = GlobalKey();

  Future<List<dynamic>> _fetchSchema() async {
    try {
      String url = await getURL("item/");
      Response response =
          await Dio().request(url, options: Options(method: "OPTIONS"));
      return response.data['fields'];
    } on DioError catch (e) {
      key.currentState.showSnackBar(
        SnackBar(
          content: Text("Network issue:$e"),
        ),
      );
      return null;
    }
  }

  Future _postItem(Map<String, dynamic> data) async {
    try {
      String url = await getURL("item/");
      Response response = await Dio().post(url, data: data);
      if (response.statusCode == 201) {
        print("ok");
      }
    } on DioError catch (e) {
      key.currentState.showSnackBar(
        SnackBar(
          content: Text("Network issue:$e"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        primaryColor: Color.fromRGBO(58, 66, 86, 1.0),
        primaryTextTheme: TextTheme(),
        accentColor: Colors.orange[300],
        buttonTheme: ButtonThemeData(
            buttonColor: Colors.deepPurple, textTheme: ButtonTextTheme.primary),
        hintColor: Colors.white,
      ),
      child: Scaffold(
        key: key,
        appBar: AppBar(
          title: Text("Edit"),
        ),
        body: FutureBuilder<List<dynamic>>(
          future: _fetchSchema(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return LinearProgressIndicator();
            } else {
              List<Map<String, dynamic>> json =
                  snapshot.data.map((s) => s as Map<String, dynamic>).toList();
              return JSONSchemaForm(
                rounded: true,
                schema: json,
                values: widget.values ?? {},
                icons: [
                  FieldIcon(schemaName: "name", iconData: Icons.title),
                  FieldIcon(
                      schemaName: "description", iconData: Icons.description),
                  FieldIcon(schemaName: "price", iconData: Icons.attach_money),
                  FieldIcon(schemaName: "column", iconData: Icons.view_column),
                  FieldIcon(schemaName: "row", iconData: Icons.view_list),
                  FieldIcon(schemaName: "qr_code", iconData: Icons.scanner),
                  FieldIcon(schemaName: "unit", iconData: Icons.g_translate)
                ],
                actions: [
                  FieldAction(
                      schemaName: "qr_code",
                      actionTypes: ActionTypes.qrScan,
                      actionDone: ActionDone.getInput)
                ],
                onSubmit: (data) async {
                  if (widget.id == null) {
                    await _postItem(data);
                  }

                  Navigator.pop(context);
                },
              );
            }
          },
        ),
      ),
    );
  }
}
