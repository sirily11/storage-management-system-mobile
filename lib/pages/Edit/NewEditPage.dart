import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:json_schema_form/json_schema_form.dart' hide getURL;
import 'package:json_schema_form/json_textform/JSONForm.dart';
import 'package:json_schema_form/json_textform/models/Schema.dart';
import 'package:provider/provider.dart';

import 'package:storage_management_mobile/States/HomeProvider.dart';
import 'package:storage_management_mobile/States/urls.dart';

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
      HomeProvider homeProvider = Provider.of(context, listen: false);
      String url = "${homeProvider.baseURL}$itemURL/";
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
      HomeProvider homeProvider = Provider.of(context, listen: false);

      String url = "${homeProvider.baseURL}$itemURL/";
      Response response = await Dio().post(url, data: data);
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

      String url = "${homeProvider.baseURL}$itemURL/${widget.id}/";
      Response response = await Dio().patch(url, data: data);
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
        body: FutureBuilder<List<dynamic>>(
          future: _fetchSchema(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return LinearProgressIndicator();
            } else {
              List<Map<String, dynamic>> json =
                  snapshot.data.map((s) => s as Map<String, dynamic>).toList();
              return JSONSchemaForm(
                onAddForignKeyField: (path, values) async {
                  String basePath = path.split("/")[1];
                  await homeProvider.addForignKey(basePath, values);
                },
                onUpdateForignKeyField: (path, values, id) async {
                  String basePath = path.split("/")[1];
                  await homeProvider.updateForignKey(id, basePath, values);
                },
                onFetchingForignKeyChoices: (path) async {
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
                      actionDone: ActionDone.getInput),
                  FieldAction<File>(
                      schemaName: "name",
                      actionTypes: ActionTypes.image,
                      actionDone: ActionDone.getInput,
                      onDone: (file) async {
                        final ImageLabeler labeler =
                            FirebaseVision.instance.imageLabeler();
                        var result = await labeler.processImage(
                          FirebaseVisionImage.fromFile(file),
                        );
                        return result.first.text;
                      })
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
              );
            }
          },
        ),
      ),
    );
  }
}
