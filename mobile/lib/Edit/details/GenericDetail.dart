import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/DataObj/Decodeable.dart';
import 'package:mobile/DataObj/Schema.dart';
import 'package:mobile/DataObj/Setting.dart';
import 'package:mobile/DataObj/StorageItem.dart';
import 'package:mobile/States/ItemDetailEditPageState.dart';
import 'package:mobile/utils/Uploader.dart';
import 'package:mobile/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class CreateAndUpdate<T> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  /// add updated/added objects to the setting
  void settingAdder(Decodeable object, ItemDetailEditPageState settings) {
    if (T == Category) {
      settings.categories.add(object);
    } else if (T == Series) {
      settings.series.add(object);
    } else if (T == Author) {
      settings.authors.add(object);
    } else if (T == Location) {
      settings.locations.add(object);
    } else if (T == Position) {
      settings.positions.add(object);
    }
  }

  void settingUpdater(Decodeable object, ItemDetailEditPageState settings) {
    if (object is Category) {
      settings.categories.removeWhere((category) => category.id == object.id);
      settings.categories.add(object);
    } else if (object is Series) {
      settings.series.removeWhere((s) => s.id == object.id);
      settings.series.add(object);
    } else if (object is Author) {
      settings.authors.removeWhere((author) => author.id == object.id);
      settings.authors.add(object);
    } else if (object is Location) {
      settings.locations.removeWhere((location) => location.id == object.id);
      settings.locations.add(object);
    } else if (object is Position) {
      settings.positions.removeWhere((position) => position.id == object.id);
      settings.positions.add(object);
    }
    settings.isLoading = false;
    settings.update();
  }

  PersistentBottomSheetController showProgressBar() {
    return _scaffoldKey.currentState.showBottomSheet((context) {
      return Container(
        height: 80,
        child: Column(
          children: <Widget>[
            ListTile(
              title: Center(
                child: Text(
                  "Loading...",
                ),
              ),
              subtitle: LinearProgressIndicator(),
            )
          ],
        ),
      );
    });
  }

  /// Add new item
  add(BuildContext context, Map<String, dynamic> object) async {
    ItemDetailEditPageState settings =
        Provider.of<ItemDetailEditPageState>(context);
    var uploader = Uploader<T>(client: http.Client());
    try {
      var newObject = await uploader.create(object);
      settingAdder(newObject, settings);
      settings.update();
      Navigator.pop(context);
    } on Exception catch (err) {
      settings.update();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(err.toString()),
        duration: Duration(seconds: 1),
      ));
    }
  }

  /// Update current item
  update<T>(BuildContext context, Map<String, dynamic> object) async {
    ItemDetailEditPageState settings =
        Provider.of<ItemDetailEditPageState>(context);
    var uploader = Uploader<T>(client: http.Client());
    try {
      var newObject = await uploader.update(object);
      settingUpdater(newObject, settings);
      Navigator.pop(context);
    } on Exception catch (err) {
      settings.update();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(err.toString()),
        duration: Duration(seconds: 1),
      ));
    }
  }
}
