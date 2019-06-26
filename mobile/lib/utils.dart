import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/DataObj/Setting.dart';
import 'package:mobile/DataObj/StorageItem.dart';
import 'DataObj/StorageItem.dart';

String getURL(String path) {
  String base = "http://192.168.31.90/storage_management";
//  String base = "https://serverless.sirileepage.com/storage_management";
  return "$base/$path";
}

showErrorMessageSnackBar(BuildContext context, String message) {
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(message),
  ));
}

Future<List<StorageItemAbstract>> fetchItems() async {
  var url = getURL("item/");
  final response = await http.get(url);
  if (response.statusCode == 200) {
    Utf8Decoder decode = Utf8Decoder();
    List<dynamic> data = json.decode(decode.convert(response.bodyBytes));
    List<StorageItemAbstract> list = [];
    data.forEach((data) {
      list.add(StorageItemAbstract.fromJson(data));
    });
    return list;
  } else {
    throw ("Failed to fetch");
  }
}

Future<SettingObj> fetchSetting() async {
  var url = getURL("settings");
  final response = await http.get(url);
  if (response.statusCode == 200) {
    Utf8Decoder decode = Utf8Decoder();
    var data = jsonDecode(decode.convert(response.bodyBytes));
    return SettingObj.fromJson(data);
  } else {
    throw ("Failed to fetch");
  }
}

Future<List<Category>> fetchCategory() async {
  var url = getURL("category/");
  final response = await http.get(url);
  if (response.statusCode == 200) {
    Utf8Decoder decode = Utf8Decoder();
    List<dynamic> data = json.decode(decode.convert(response.bodyBytes));
    List<Category> list = [];
    data.forEach((data) {
      list.add(Category.fromJson(data));
    });
    return list;
  } else {
    throw ("Failed to fetch");
  }
}

Future<List<Series>> fetchSeries() async {
  var url = getURL("series/");
  final response = await http.get(url);
  if (response.statusCode == 200) {
    Utf8Decoder decode = Utf8Decoder();
    List<dynamic> data = json.decode(decode.convert(response.bodyBytes));
    List<Series> list = [];
    data.forEach((data) {
      list.add(Series.fromJson(data));
    });
    return list;
  } else {
    throw ("Failed to fetch");
  }
}

Future<Author> addAuthor(Author author) async {
  var url = getURL("author/");
  var body = {"name": author.name, "description": author.description};
  final response = await http.post(url,
      body: json.encode(body),
      headers: {HttpHeaders.contentTypeHeader: "application/json"});

  if (response.statusCode == 201) {
    Utf8Decoder decode = Utf8Decoder();
    var data = json.decode(decode.convert(response.bodyBytes));
    return Author.fromJson(data);
  } else {
    throw ("Failed to post");
  }
}

Future<List<Location>> fetchLocation() async {
  var url = getURL("location/");
  final response = await http.get(url);
  if (response.statusCode == 200) {
    Utf8Decoder decode = Utf8Decoder();
    List<dynamic> data = json.decode(decode.convert(response.bodyBytes));
    List<Location> list = [];
    data.forEach((data) {
      list.add(Location.fromJson(data));
    });
    return list;
  } else {
    throw ("Failed to fetch");
  }
}

Future<List<Position>> fetchPosition() async {
  var url = getURL("detail-position/");
  final response = await http.get(url);
  if (response.statusCode == 200) {
    Utf8Decoder decode = Utf8Decoder();
    List<dynamic> data = json.decode(decode.convert(response.bodyBytes));
    List<Position> list = [];
    data.forEach((data) {
      list.add(Position.fromJson(data));
    });
    return list;
  } else {
    throw ("Failed to fetch");
  }
}

String isEmpty(String value) {
  if (value.isEmpty) {
    return "This Should not be empty";
  }
  return null;
}
