import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'UploadDialog.dart';


class ImageScreen extends StatefulWidget {
  /// item's id
  final int id;

  ImageScreen({this.id});

  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  final GlobalKey<ScaffoldState> key = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  void uploadImage(File image) async {
    if (image != null)
      await showDialog(
        context: context,
        builder: (context) => UploadDialog(
          id: widget.id,
          image: image,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: AppBar(
        title: Text("Select image"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 200,
                      child: RaisedButton(
                        onPressed: () async {
                          try {
                            File image = await ImagePicker.pickImage(
                                source: ImageSource.camera);
                            uploadImage(image);
                          } catch (err) {
                            key.currentState.showSnackBar(
                              SnackBar(
                                content: Text(err.toString()),
                              ),
                            );
                          }
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.camera_alt,
                              size: 40,
                            ),
                            Text("Image From Camera"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 200,
                      child: RaisedButton(
                        onPressed: () async {
                          try {
                            File image = await ImagePicker.pickImage(
                                source: ImageSource.gallery);
                            uploadImage(image);
                          } catch (err) {
                            key.currentState.showSnackBar(
                              SnackBar(
                                content: Text(err.toString()),
                              ),
                            );
                          }
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.camera,
                              size: 40,
                            ),
                            Text("Image From Library"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}