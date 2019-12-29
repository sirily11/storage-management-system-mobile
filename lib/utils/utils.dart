import 'dart:io';
import 'dart:core';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import '../DataObj/StorageItem.dart';

List<String> currencyUnit = ["CNY", "JPY", "USD", "EUR", "HKD", "BKP"];

Future<String> getURL(String path, {bool onlyBase = false}) async {
  String base = "http://0.0.0.0:80";
  try {
    final prefs = await SharedPreferences.getInstance();

    String url = prefs.getString("server") ?? base;
    if (onlyBase) {
      return url;
    }
    return "$url/storage_management/$path";
  } on Exception catch (err) {
    if (onlyBase) {
      return base;
    }
    return "$base/storage_management/$path";
  }
}

Future<String> getWebSocket({String path}) async {
  String base = "ws://192.168.31.19:4000";
  final prefs = await SharedPreferences.getInstance();
  String url = prefs.getString("websocket") ?? base;
  return "$base/?type=scanner";
}

showErrorMessageSnackBar(BuildContext context, String message) {
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(message),
  ));
}

Future<List<StorageItemAbstract>> fetchItems() async {
  var url = await getURL("item/");
  try {
    final response = await Dio().get(url);
    List<StorageItemAbstract> list = [];
    response.data.forEach((data) {
      list.add(StorageItemAbstract.fromJson(data));
    });
    return list;
  } catch (err) {
    throw ("Failed to fetch");
  }
}

Future<List<Category>> fetchCategories() async {
  var url = await getURL("category");
  final response = await Dio().get<List<dynamic>>(url);
  if (response.statusCode == 200) {
    return response.data
        .map((d) => Category.fromJson((d as Map<String, dynamic>)))
        .toList();
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
  var url = await getURL("item/");
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
    "position_id": item.position.id,
    "unit": item.unit
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
        categoryName: detailItem.category.name,
        description: detailItem.description,
        authorName: detailItem.author.name,
        position: detailItem.position.name,
        column: detailItem.column,
        row: detailItem.row);
  } else {
    print("Failed to fetch");
  }
}


/**
 * Update item and sync with database
 */
Future<StorageItemDetail> UpdateItem(StorageItemDetail item) async {
  if (item == null) {
    throw Exception("Item should not be null");
  }
  var url = await getURL("item/");
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
    "position_id": item.position.id,
    "unit": item.unit
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
  var url = await getURL("searchByQR?qr=$qrCode");
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
