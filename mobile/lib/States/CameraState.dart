import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';

class CameraState with ChangeNotifier {
  CameraDescription cameraDescription;
  List<String> _imagePath = [];
  double progress;

  List<String> get imagePath => _imagePath;

  set imagePath(List<String> value) {
    _imagePath = value;
    notifyListeners();
  }

  removeImage(String image) async {
    _imagePath.remove(image);
    await File(image).delete();
    notifyListeners();
  }

  Future<void> clear() async{
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
