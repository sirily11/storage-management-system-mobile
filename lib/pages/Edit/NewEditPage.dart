import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:json_schema_form/json_schema_form.dart' hide getURL;
import 'package:json_schema_form/json_textform/JSONForm.dart';
import 'package:json_schema_form/json_textform/models/Schema.dart';
import 'package:provider/provider.dart';

import 'package:storage_management_mobile/States/HomeProvider.dart';
import 'package:storage_management_mobile/States/LoginProvider.dart';
import 'package:storage_management_mobile/States/urls.dart';
import 'package:storage_management_mobile/pages/Edit/WikiSearchPage.dart';

class NewEditPage extends StatefulWidget {
  final Map<String, dynamic> values;
  final int id;

  NewEditPage({this.values, this.id});

  @override
  _NewEditPageState createState() => _NewEditPageState();
}

class _NewEditPageState extends State<NewEditPage> {
  GlobalKey<ScaffoldState> key = GlobalKey();
  List<dynamic> schema;
  bool isLoading = true;
  String error;

  @override
  void initState() {
    super.initState();
    _fetchSchema().then((value) {
      setState(() {
        schema = value;
        isLoading = false;
      });
    }).catchError((err) {
      setState(() {
        isLoading = false;
        error = err;
      });
    });
  }

  Future<List<dynamic>> _fetchSchema() async {
    try {
      HomeProvider homeProvider = Provider.of(context, listen: false);
      String url = "${homeProvider.baseURL}$itemURL/";
      Response response = await homeProvider.dio
          .request(url, options: Options(method: "OPTIONS"));
      return response.data['fields'];
    } on DioError catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Network issue:$e"),
        ),
      );
      return null;
    }
  }

  Future<void> _postItem(Map<String, dynamic> data) async {
    try {
      HomeProvider homeProvider = Provider.of(context, listen: false);
      var header = await LoginProvider.getLoginAccessKey();
      String url = "${homeProvider.baseURL}$itemURL/";
      Response response = await homeProvider.dio.post(
        url,
        data: data,
        options: Options(headers: header),
      );
      Navigator.pop(context);
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

  Future _updateItem(Map<String, dynamic> data) async {
    try {
      HomeProvider homeProvider = Provider.of(context, listen: false);
      var header = await LoginProvider.getLoginAccessKey();
      String url = "${homeProvider.baseURL}$itemURL/${widget.id}/";
      Response response = await homeProvider.dio.patch(
        url,
        data: data,
        options: Options(headers: header),
      );
      Navigator.pop(context);
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
    HomeProvider homeProvider = Provider.of(context, listen: false);
    return Theme(
      data: Theme.of(context),
      child: Scaffold(
        key: key,
        appBar: AppBar(
          title: Text("Edit"),
        ),
        body: Builder(
          builder: (context) {
            if (isLoading) {
              return LinearProgressIndicator();
            }

            if (error != null) {
              return Center(
                child: Text("$error"),
              );
            }

            List<Map<String, dynamic>> json =
                schema.map((s) => s as Map<String, dynamic>).toList();
            return Scrollbar(
              child: JSONSchemaForm(
                onAddforeignKeyField: (path, values) async {
                  String basePath = path.split("/")[1];
                  var result =
                      await homeProvider.addForeignKey(basePath, values);
                  return result;
                },
                onUpdateforeignKeyField: (path, values, id) async {
                  String basePath = path.split("/")[1];
                  var result =
                      await homeProvider.updateForeignKey(id, basePath, values);
                  return result;
                },
                onFetchingforeignKeyChoices: (path) async {
                  String basePath = path.split("/")[1];
                  var choices = await homeProvider.fetchChoices(basePath);
                  return choices;
                },
                onFetchingSchema: (path, isEdit, id) async {
                  String basePath = path.split("/")[1];
                  var schema = await homeProvider.fetchSchema(basePath);
                  Map<String, dynamic> values = {};
                  if (isEdit) {
                    values = await homeProvider.fetchSchemaValues(basePath, id);
                  }

                  return SchemaValues(schema: schema, values: values);
                },
                url: homeProvider.baseURL,
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
                    actionDone: ActionDone.getInput,
                  ),
                  FieldAction(
                    schemaName: 'name',
                    icon: Icons.search,
                    actionTypes: ActionTypes.custom,
                    actionDone: ActionDone.getInput,
                    onActionTap: (schema) async {
                      print(schema.value);
                      String result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WikiSearchPage(),
                        ),
                      );
                      return result;
                    },
                  ),
                  FieldAction(
                    schemaName: 'description',
                    icon: Icons.search,
                    actionTypes: ActionTypes.custom,
                    actionDone: ActionDone.getInput,
                    onActionTap: (schema) async {
                      print(schema.value);
                      String result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WikiSearchPage(),
                        ),
                      );
                      return result;
                    },
                  )
                ],
                onSubmit: (data) async {
                  data.removeWhere((k, v) => v == null);
                  try {
                    if (widget.id == null) {
                      await _postItem(data);
                    } else {
                      await _updateItem(data);
                    }
                  } catch (err) {}
                },
                onDeleteforeignKeyField: (String path, id) async {
                  var response = await homeProvider.deleteForeignKey(id, path);
                  return response;
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
