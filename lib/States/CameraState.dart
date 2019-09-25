import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';

class CameraState with ChangeNotifier {
  CameraDescription cameraDescription;
  List<String> _imagePath = [];
  double progress;

  final GlobalKey<AnimatedListState> listKey = GlobalKey();

  List<String> get imagePath => _imagePath;

  set imagePath(List<String> value) {
    _imagePath = value;
    notifyListeners();
  }

  addItem(String image) async {
    _imagePath.add(image);
    listKey.currentState.insertItem(this._imagePath.length - 1);
    notifyListeners();
  }

  removeImage(String image) async {
    var index = _imagePath.indexOf(image);
    _imagePath.remove(image);
    await File(image).delete();
    notifyListeners();
    return index;
  }

  Future<void> clear() async {
    _imagePath.forEach((path) async {
      await File(path).delete();
    });
    progress = null;
    _imagePath.clear();
  }

  update() {
    notifyListeners();
  }
}
