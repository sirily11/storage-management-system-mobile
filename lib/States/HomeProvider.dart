import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:json_schema_form/json_textform/models/Schema.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage_management_mobile/DataObj/Setting.dart';
import 'package:storage_management_mobile/DataObj/StorageItem.dart';
import 'package:storage_management_mobile/States/LoginProvider.dart';
import 'package:storage_management_mobile/States/urls.dart';

class HomeProvider with ChangeNotifier {
  /// Current selected category
  static Category allCategory = Category(id: null, name: "All");
  static Location allLocation = Location(id: null, name: "All");
  static Position allPosition = Position(id: null, name: "All");

  Category _selectedCategory = allCategory;
  Location _selectedLocation = allLocation;
  Position _selectedPosition = allPosition;

  /// Next page url
  String next;
  List<StorageItemAbstract> items = [];
  SettingObj settingObj;
  GlobalKey<ScaffoldState> scaffoldKey;
  String baseURL;
  Dio dio;

  HomeProvider({Dio networkProvider}) {
    this.dio = networkProvider ?? Dio();
    this.initURL();
  }

  Future<Choice> updateForeignKey(
      int id, String path, Map<String, dynamic> data) async {
    var header = await LoginProvider.getLoginAccessKey();
    var response = await dio.patch(
      "$baseURL/storage_management/$path/$id/",
      data: data,
      options: Options(headers: header),
    );
    return Choice(label: response.data['name'], value: response.data['id']);
  }

  Future<Choice> deleteForeignKey(int id, String path) async {
    var header = await LoginProvider.getLoginAccessKey();
    var response = await dio.delete(
      "$baseURL/storage_management/$path/$id/",
      options: Options(headers: header),
    );
    return Choice(label: response.data['name'], value: response.data['id']);
  }

  Future<Choice> addForeignKey(String path, Map<String, dynamic> data) async {
    try {
      var header = await LoginProvider.getLoginAccessKey();
      var response = await dio.post(
        "$baseURL/storage_management/$path/",
        data: data,
        options: Options(
          headers: header,
        ),
      );
      return Choice(label: response.data['name'], value: response.data['id']);
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future<List<Choice>> fetchChoices(String path) async {
    var response = await dio.get<List>("$baseURL/storage_management/$path");
    var choices = response.data
        .map((e) => Choice(label: e['name'], value: e['id']))
        .toList();
    return choices;
  }

  Future<List> fetchSchema(String path) async {
    try {
      var response = await dio.request(
        "$baseURL/storage_management/$path/",
        options: Options(method: "OPTIONS"),
      );

      return (response.data['fields'] as List)
          .map((e) => e as Map<String, dynamic>)
          .where((element) => element['label'] != "image")
          .toList();
    } catch (err) {
      print("$err");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchSchemaValues(String path, int id) async {
    try {
      var response = await dio.get(
        "$baseURL/storage_management/$path/$id/",
      );

      return response.data;
    } catch (err) {
      print("$err");
      rethrow;
    }
  }

  Future<void> initURL() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    this.baseURL = preferences.getString(serverPath) ?? "";
    notifyListeners();
  }

  Future<void> setURL(String url) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(serverPath, url);
  }

  set selectedCategory(Category c) {
    _selectedCategory = c;
    notifyListeners();
    fetchItems();
  }

  get selectedLocation => _selectedLocation;

  set selectedLocation(Location c) {
    _selectedLocation = c;
    notifyListeners();
    fetchItems();
  }

  get selectedPosition => _selectedPosition;

  set selectedPosition(Position c) {
    _selectedPosition = c;
    notifyListeners();
    fetchItems();
  }

  get selectedCategory => _selectedCategory;

  PersistentBottomSheetController sheetController() {
    return scaffoldKey.currentState.showBottomSheet((context) {
      return Container(
        height: 80,
        child: Column(
          children: <Widget>[
            ListTile(
              title: Center(
                child: Text(
                  "Loading...",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              subtitle: LinearProgressIndicator(),
            )
          ],
        ),
      );
    });
  }

  /// Fetch more
  Future<void> fetchMore() async {
    if (next == null) {
      return;
    }

    try {
      final response = await this.dio.get(next);
      Result result = Result<dynamic>.fromJSON(response.data);
      next = result.next;

      List<StorageItemAbstract> moreList = [];
      result.results?.forEach((data) {
        moreList.add(StorageItemAbstract.fromJson(data));
      });

      this.items = List.from(items)..addAll(moreList);

      notifyListeners();
    } catch (err) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(err.toString()),
      ));

      throw ("Failed to fetch");
    }
  }

  Future<List<StorageItemAbstract>> search(String keyword) async {
    String url = "$baseURL$itemURL";
    var response = await dio.get(url, queryParameters: {"search": keyword});
    return (response.data['results'] as List)
        .map((e) => StorageItemAbstract.fromJson(e))
        .toList();
  }

  /// Fetch list of items
  Future<void> fetchItems() async {
    String url = "$baseURL$itemURL";
    try {
      if (_selectedCategory != null ||
          _selectedLocation != null ||
          _selectedPosition != null) {
        url =
            "$url?category=${_selectedCategory?.id ?? ""}&location=${_selectedLocation?.id ?? ""}&detail_position=${_selectedPosition?.id ?? ""}";
      }

      final response = await this.dio.get(url);

      Result result = Result<dynamic>.fromJSON(response.data);
      next = result.next;

      List<StorageItemAbstract> list = [];
      result.results?.forEach((data) {
        list.add(StorageItemAbstract.fromJson(data));
      });

      this.items = list;

      notifyListeners();
    } catch (err) {
      print(err);
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(err.toString()),
      ));
      return [];
    }
  }

  Future<void> fetchSettings() async {
    var url = "$baseURL$settingsURL";
    final response = await this.dio.get(url);
    try {
      var settings = SettingObj.fromJson(response.data);
      settings.categories = List.from([allCategory])
        ..addAll(settings.categories);

      settings.positions = List.from([allPosition])..addAll(settings.positions);

      settings.locations = List.from([allLocation])..addAll(settings.locations);

      this.settingObj = settings;
      notifyListeners();
    } catch (err) {
      print(err);
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(err.toString()),
      ));
    }
  }

  addItem(StorageItemAbstract item) {
    items.add(item);
    notifyListeners();
  }

  remove(StorageItemAbstract item) async {
    var url = "$baseURL$itemURL/${item.id}/";
    var header = await LoginProvider.getLoginAccessKey();
    var respnse = await this.dio.delete(
          url,
          options: Options(headers: header),
        );
    items.remove(item);
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("物品已经删除"),
    ));
    notifyListeners();
  }
}
