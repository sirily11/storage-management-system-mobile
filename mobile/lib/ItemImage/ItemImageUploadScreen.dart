import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile/Home/Detail/HorizontalImage.dart';
import 'package:mobile/States/CameraState.dart';
import 'package:mobile/utils/utils.dart';
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
    final img.Image resized = img.copyResize(image, width: 1080);
    final List<int> resizedBytes = img.encodeJpg(resized, quality: 100);

    return resizedBytes;
  }

  void updateProgress(BuildContext context, num current, num total) {
    var imageState = Provider.of<CameraState>(context);
    imageState.progress = current / total;
    imageState.update();
  }

  Future upload(context) async {
    var imageState = Provider.of<CameraState>(context);
    var url = await getURL("item-image/");
    var dio = Dio();
    num done = 0;
    imageState.progress = 0;
    imageState.update();
    for (var path in imageState.imagePath) {
      var file = File(path);
      final bytes = await compute(_resizeImage, file);
      done = done + 0.5;
      updateProgress(context, done, imageState.imagePath.length);
      FormData formData = new FormData.from(
          {"item": this._id, "image": UploadFileInfo.fromBytes(bytes, path)});
      await dio.post(url, data: formData);
      done = done + 0.5;
      updateProgress(context, done, imageState.imagePath.length);
    }
    if (done == imageState.imagePath.length) {
      await Future.delayed(Duration(seconds: 2), () {
        imageState.progress = null;
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var imageState = Provider.of<CameraState>(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
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
          Card(
            child: Container(
              decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
              child: ListTile(
                title: Text(
                  "Item Name",
                  style: TextStyle(color: Colors.white),
                ),
                subtitle:
                    Text(this._name, style: TextStyle(color: Colors.white)),
              ),
            ),
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
