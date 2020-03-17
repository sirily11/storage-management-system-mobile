import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:storage_management_mobile/DataObj/Setting.dart';
import 'package:storage_management_mobile/DataObj/StorageItem.dart';
import 'package:storage_management_mobile/utils/utils.dart';

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
  Dio dio;

  HomeProvider({Dio networkProvider}) {
    this.dio = networkProvider ?? Dio();
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

  Future<void> fetchMore() async {
    if (next == null) {
      return;
    }

    try {
      final response = await this.dio.get(next);
      Result result = Result<dynamic>.fromJSON(response.data);
      next = result.next;

      List<StorageItemAbstract> moreList = [];
      result.results.forEach((data) {
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

  Future<void> fetchItems() async {
    String url = await getURL("item/");
    PersistentBottomSheetController controller = sheetController();
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
      result.results.forEach((data) {
        list.add(StorageItemAbstract.fromJson(data));
      });

      this.items = list;
      // scaffoldKey.currentState.showSnackBar(SnackBar(
      //   content: Text("数据已获取"),
      //   duration: Duration(seconds: 1),
      // ));
      Future.delayed(Duration(milliseconds: 500), () {
        controller.close();
      });
      notifyListeners();
    } catch (err) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(err.toString()),
      ));
      controller.close();
      throw ("Failed to fetch");
    }
  }

  Future<void> fetchSettings() async {
    var url = await getURL("settings");
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
    var url = await getURL("item/${item.id}/");
    var respnse = await this.dio.delete(url);
    items.remove(item);
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("物品已经删除"),
    ));
    notifyListeners();
  }
}
