import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile/Home/Detail/HorizontalImage.dart';
import 'package:mobile/States/CameraState.dart';
import 'package:mobile/utils.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as img;

class ItemImageUploadScreen extends StatelessWidget {
  final int _id;
  final String _name;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  ItemImageUploadScreen(this._id, this._name);

  static Future<List<int>> _resizeImage(File file) async {
    final bytes = await file.readAsBytes();
    final img.Image image = img.decodeImage(bytes);
    final img.Image resized = img.copyResize(image, width: 800);
    final List<int> resizedBytes = img.encodeJpg(resized, quality: 90);

    return resizedBytes;
  }

  Future upload(context) async {
    var imageState = Provider.of<CameraState>(context);
    var url = getURL("item-image/");
    var dio = Dio();
    var done = 0;
    imageState.progress = 0;
    imageState.update();
    for (var path in imageState.imagePath) {
      var file = File(path);
      final bytes = await _resizeImage(file);
      print("File Size: ${bytes.length}, Orginal: ${file.lengthSync()}");
      FormData formData = new FormData.from(
          {"item": this._id, "image": UploadFileInfo.fromBytes(bytes, path)});
      var response = await dio.post(url, data: formData);
      print(response.statusCode);
      done = done + 1;
      imageState.progress = done / imageState.imagePath.length;
      imageState.update();
    }
    if (done == imageState.imagePath.length) {
      await Future.delayed(Duration(seconds: 2), () {
        imageState.progress = null;
        Navigator.pop(context);
      });
    }

    ;
  }

  @override
  Widget build(BuildContext context) {
    var imageState = Provider.of<CameraState>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Upload image"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.file_upload),
            onPressed: () async => await upload(context),
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text("Item Name"),
            subtitle: Text(this._name),
          ),
          HorizontalImage(
            imageState.imagePath,
            isLocal: true,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: imageState.progress != null
                ? LinearProgressIndicator(
                    value: imageState.progress,
                  )
                : Container(),
          )
        ],
      ),
    );
  }
}
