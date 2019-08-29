import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile/DataObj/Decodeable.dart';
import 'package:mobile/DataObj/Schema.dart';
import 'package:mobile/DataObj/StorageItem.dart';
import 'package:mobile/Edit/details/GenericDetail.dart';
import 'package:mobile/utils/utils.dart';

class JsonForm<T> extends StatefulWidget {
  final String title;
  final String path;
  final bool isEdit;
  final Map<String, dynamic> data;

  JsonForm(
      {@required this.isEdit,
      @required this.title,
      @required this.path,
      this.data});

  @override
  _JsonFormState createState() => _JsonFormState<T>(
      isEdit: this.isEdit, data: this.data, title: this.title, path: this.path);
}

class _JsonFormState<T> extends State<JsonForm> with CreateAndUpdate<T> {
  final String path;
  final bool isEdit;
  final String title;
  final Map<String, dynamic> data;
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _values = {};

  _JsonFormState(
      {@required this.isEdit,
      @required this.path,
      @required this.title,
      this.data});

  List<Schema> schema = [];

  @override
  void initState() {
    super.initState();
    getForm().then((s) {
      setState(() {
        schema = s;
      });
    });
  }

  Future<List<Schema>> getForm() async {
    try {
      String url = await getURL(this.path);
      Dio dio = Dio();

      List<Schema> schemaList = [];
      Response response =
          await dio.request(url, options: Options(method: "OPTIONS"));

      Map<String, dynamic> schema = response.data['actions']['POST'];
      for (String key in schema.keys) {
        if (key != 'id') {
          Schema s = Schema.fromJson(schema[key]);
          s.key = key;
          if (isEdit) {
            s.value = data[key];
          }
          schemaList.add(s);
          _values.putIfAbsent(key, () => null);
        }
      }
      _values.putIfAbsent('id', () => data['id']);
      return schemaList;
    } on Exception catch (err) {
      print(err);
    }
  }

  Widget _bodyWidget() {
    return Form(
      key: _formKey,
      child: ListView(
          children: this.schema.map((s) {
        return Theme(
          data: ThemeData(
            hintColor: Colors.white,
            focusColor: Colors.white,
            accentColor: Colors.white,
            primaryColor: Colors.orange[300],
            primaryColorDark: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
                initialValue: s.value,
                maxLines: s.maxLength > 128 ? 8 : 1,
                minLines: s.maxLength > 128 ? 8 : 1,
                style: TextStyle(color: Colors.white),
                onSaved: (value) {
                  _values[s.key] = value;
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromRGBO(64, 75, 90, .8),
                  labelText: s.label,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.white, width: 0.0)),
                )),
          ),
        );
      }).toList()),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (schema.length == 0) {
      body = Center(child: CircularProgressIndicator());
    } else {
      body = _bodyWidget();
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        appBar: AppBar(
          title: Text(this.title),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.file_upload),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  if (isEdit) {
                    this.update(context, _values);
                  } else {
                    this.add(context, _values);
                  }
                }
              },
            )
          ],
        ),
        body: body,
      ),
    );
  }
}
