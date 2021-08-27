import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:storage_management_mobile/States/ItemProvider.dart';
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

  Future<void> uploadImage(File image, List<String> labels) async {
    if (image != null)
      await showCupertinoModalBottomSheet(
        context: context,
        expand: true,
        builder: (context) => UploadDialog(
          id: widget.id,
          image: image,
          labels: labels,
        ),
      );
  }

  // Future<List<ImageLabel>> labelImage(File image) async {
  //   final ImageLabeler labeler = FirebaseVision.instance.imageLabeler();
  //   List<ImageLabel> labels =
  //       await labeler.processImage(FirebaseVisionImage.fromFile(image));
  //   return labels;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: AppBar(
        title: Text("Select image"),
      ),
      body: LayoutBuilder(
        builder: (c, _) {
          if (Platform.isMacOS) {
            return buildDesktop(context);
          }
          return buildMobile(context);
        },
      ),
    );
  }

  Widget buildMobile(BuildContext context) {
    ItemProvider itemProvider = Provider.of(context, listen: false);
    return Container(
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
                          var imageFile = await itemProvider.pickImage(
                            ImageSource.camera,
                          );
                          var labels = [];
                          await uploadImage(imageFile, labels);
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
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          var imageFile = await itemProvider.pickImage(
                            ImageSource.gallery,
                          );
                          var labels = [];
                          await uploadImage(imageFile, labels);
                        } catch (err) {
                          ScaffoldMessenger.of(context).showSnackBar(
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
    );
  }

  Widget buildDesktop(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 400,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 200,
                    child: RaisedButton(
                      onPressed: () async {
                        try {} catch (err) {
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
                            Icons.file_upload,
                            size: 40,
                          ),
                          Text("Image From Local"),
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
    );
  }
}
