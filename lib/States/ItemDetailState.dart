import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../DataObj/StorageItem.dart';
import '../utils/utils.dart';

class ItemDetailState with ChangeNotifier {
  StorageItemDetail item;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  PersistentBottomSheetController _sheetController() {
    return scaffoldKey.currentState.showBottomSheet((context) {
      return Container(
        color: Color.fromRGBO(64, 75, 96, .9),
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

  Future<StorageItemDetail> _fetchItem(int id) async {
    var controller = _sheetController();
    try {
      var url = await getURL("item/$id");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        Utf8Decoder decode = Utf8Decoder();
        var data = json.decode(decode.convert(response.bodyBytes));
        var item = StorageItemDetail.fromJson(data);
        Future.delayed(Duration(milliseconds: 500), () {
          controller.close();
        });
        return item;
      } else {
        throw ("Error");
      }
    } on Exception catch (err) {
      print(err);
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Failed to fetch item details"),
      ));
      return null;
    }
  }

  /// Fetch data from  internet
  /// This will set up item
  ///
  /// @param id required
  Future fetchData({@required int id}) async {
    StorageItemDetail item = await _fetchItem(id);
    this.item = item;
    notifyListeners();
  }

  /// Update item
  updateItem(StorageItemDetail item) {
    this.item = item;
    notifyListeners();
  }
}
