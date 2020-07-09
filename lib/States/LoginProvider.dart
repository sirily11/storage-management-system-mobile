import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage_management_mobile/States/urls.dart';

class LoginProvider with ChangeNotifier {
  bool hasLogined = false;
  Dio dio;

  LoginProvider({Dio networkProvider}) {
    this.dio = networkProvider ?? Dio();
  }

  /// Get Login Access key
  static Future<Map<String, dynamic>> getLoginAccessKey() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String key = preferences.getString("access");

    return {"Authorization": "Bearer $key"};
  }

  /// Login
  Future<void> signIn(String username, String password) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      var response = await _sendSignInRequest(username, password);
      hasLogined = true;
      await preferences.setString(accessPath, response.data['access']);
      await preferences.setString(passwordPath, password);
      await preferences.setString(usernamePath, username);
      notifyListeners();
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future<Response> _sendSignInRequest(String username, String password) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String baseURL = preferences.getString(serverPath) ?? "";
    var response = await dio.post(
      "$baseURL$loginURL/",
      data: {"username": username, "password": password},
    );
    return response;
  }

  /// Sign out
  Future<void> signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(accessPath);
    await preferences.remove(passwordPath);
    await preferences.remove(usernamePath);
    hasLogined = false;
    notifyListeners();
  }

  /// Auto login
  Future<void> autoSignIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String password = preferences.getString(passwordPath);
    String username = preferences.getString(usernamePath);
    if (password != null && username != null) {
      var response = await _sendSignInRequest(username, password);
      await preferences.setString(accessPath, response.data['access']);
      hasLogined = true;
      notifyListeners();
    }
    return;
  }
}
