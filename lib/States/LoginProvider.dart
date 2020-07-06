import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider with ChangeNotifier {
  /// Get Login Access key
  static Future<Map<String, dynamic>> getLoginAccessKey() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String key = preferences.getString("access");

    return {"Authorization": "Bearer $key"};
  }

  /// Login
  Future<void> login(String username, String password) async {}

  /// Auto login
  Future<void> autoLogin() async {}
}
