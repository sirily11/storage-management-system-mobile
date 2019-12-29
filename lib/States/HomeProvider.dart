import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:storage_management_mobile/DataObj/StorageItem.dart';
import 'package:storage_management_mobile/utils/utils.dart';

class HomeProvider with ChangeNotifier {
  List<StorageItemAbstract> items = [];
  List<Category> categories = [];
  GlobalKey<ScaffoldState> scaffoldKey;

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

  Future<void> fetchItems() async {
    var url = await getURL("item/");
    try {
      PersistentBottomSheetController controller = sheetController();
      final response = await Dio().get(url);
      List<StorageItemAbstract> list = [];
      response.data.forEach((data) {
        list.add(StorageItemAbstract.fromJson(data));
      });
      this.items = list;
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("数据已获取"),
        duration: Duration(seconds: 2),
      ));
      Future.delayed(Duration(milliseconds: 500), () {
        controller.close();
      });
      notifyListeners();
    } catch (err) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(err.toString()),
      ));
      throw ("Failed to fetch");
    }
  }

  Future<void> fetchCategories() async {
    var url = await getURL("category");
    final response = await Dio().get<List<dynamic>>(url);
    try {
      var categories = response.data
          .map((d) => Category.fromJson((d as Map<String, dynamic>)))
          .toList();
      this.categories = categories;
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
    var respnse = await Dio().delete(url);
    items.remove(item);
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("物品已经删除"),
    ));
    notifyListeners();
  }
}
