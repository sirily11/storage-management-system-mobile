import 'dart:io';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/DataObj/Setting.dart';
import 'package:mobile/DataObj/StorageItem.dart';
import '../DataObj/StorageItem.dart';

String getURL(String path) {
  String base = "http://192.168.43.21/storage_management";
  // String base = "https://serverless.sirileepage.com/storage_management";
  return "$base/$path";
}

String getWebSocket({String path}) {
  String base = "ws://192.168.31.91:8000/?type=scanner";
  return base;
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

/**
 * Get api url for each path
 */
String getAPIUrl(dynamic object) {}

Future<StorageItemAbstract> addItem(StorageItemDetail item) async {
  if (item == null) {
    throw Exception("Item should not be null");
  }
  var url = getURL("item/");
  var body = {
    "name": item.name,
    "category_id": item.category.id,
    "description": item.description,
    "price": item.price,
    "qr_code": item.qrCode,
    "column": item.column,
    "row": item.row,
    "author_id": item.author.id,
    "series_id": item.series.id,
    "location_id": item.location.id,
    "position_id": item.position.id
  };
  var jsonBody = json.encode(body);
  final response = await http.post(url,
      body: jsonBody,
      headers: {HttpHeaders.contentTypeHeader: "application/json"});

  if (response.statusCode == 201) {
    Utf8Decoder decode = Utf8Decoder();
    var data = json.decode(decode.convert(response.bodyBytes));
    var detailItem = StorageItemDetail.fromJson(data);
    return StorageItemAbstract(
        id: detailItem.id,
        name: detailItem.name,
        seriesName: detailItem.series.name,
        description: detailItem.description,
        authorName: detailItem.author.name,
        position: detailItem.position.name,
        column: detailItem.column,
        row: detailItem.row);
  } else {
    print("Failed to fetch");
  }
}

Future<bool> removeItem(StorageItemAbstract item) async {
  var url = getURL("item/${item.id}/");
  final response = await http.delete(url);
  if (response.statusCode == 204) {
    Utf8Decoder decode = Utf8Decoder();
    return true;
  } else {
    throw Exception();
  }
}

/**
 * Update item and sync with database
 */
Future<StorageItemDetail> UpdateItem(StorageItemDetail item) async {
  if (item == null) {
    throw Exception("Item should not be null");
  }
  var url = getURL("item/");
  var body = {
    "name": item.name,
    "category_id": item.category.id,
    "description": item.description,
    "price": item.price,
    "qr_code": item.qrCode,
    "column": item.column,
    "row": item.row,
    "author_id": item.author.id,
    "series_id": item.series.id,
    "location_id": item.location.id,
    "position_id": item.position.id
  };
  var jsonBody = json.encode(body);
  final response = await http.patch("$url${item.id}/",
      body: jsonBody,
      headers: {HttpHeaders.contentTypeHeader: "application/json"});

  if (response.statusCode == 200) {
    Utf8Decoder decode = Utf8Decoder();
    var data = json.decode(decode.convert(response.bodyBytes));
    var detailItem = StorageItemDetail.fromJson(data);
    return detailItem;
  } else {
    print("Failed to fetch");
  }
}

Future<StorageItemAbstract> searchByQR(String qrCode) async {
  var url = getURL("searchByQR?qr=$qrCode");
  final response = await http.get(url);

  if (response.statusCode == 200) {
    Utf8Decoder decode = Utf8Decoder();
    var data = json.decode(decode.convert(response.bodyBytes));
    var detailItem = StorageItemAbstract.fromJson(data);
    return detailItem;
  } else {
    throw Exception();
  }
}

String isEmpty(String value) {
  if (value.isEmpty) {
    return "This Should not be empty";
  }
  return null;
}

String isSelected(dynamic value) {
  if (value != null) {
    return null;
  }
  return "This should not be empty";
}
