import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:json_schema_form/JSONSchemaForm.dart';
import 'package:mobile/utils/utils.dart';

class NewEditPage extends StatefulWidget {
  @override
  _NewWditPageState createState() => _NewWditPageState();
}

class _NewWditPageState extends State<NewEditPage> {
  GlobalKey<ScaffoldState> key = GlobalKey();

  Future<List<dynamic>> _fetchSchema() async {
    try {
      String url = await getURL("item/");
      Response response =
          await Dio().request(url, options: Options(method: "OPTIONS"));
      return response.data['fields'];
    } on DioError catch (e) {
      // key.currentState.showSnackBar(
      //   SnackBar(
      //     content: Text("Network issue:$e"),
      //   ),
      // );
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              rounded: false,
              schema: json,
            );
          }
        },
      ),
    );
  }
}
