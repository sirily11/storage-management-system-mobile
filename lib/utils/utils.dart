
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
