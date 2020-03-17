import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:provider/provider.dart';
import 'package:storage_management_mobile/States/ItemDetailState.dart';

import '../utils/utils.dart';

class UploadDialog extends StatefulWidget {
  final File image;
  final int id;
  final List<ImageLabel> labels;

  UploadDialog({this.id, this.image, this.labels});

  @override
  _UploadDialogState createState() => _UploadDialogState();
}

class _UploadDialogState extends State<UploadDialog> {
  double progress;
  String err;
  String selectedLabel;

  Widget tags() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Tags(
        itemCount: widget.labels != null ? widget.labels.length : 0,
        itemBuilder: (index) {
          final _item = widget.labels[index].text;
          return ItemTags(
            index: index,
            title: _item,
            onPressed: (item) {
              if (!item.active) {
                setState(() {
                  selectedLabel = _item;
                });
              } else {
                setState(() {
                  selectedLabel = null;
                });
              }
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ItemDetailState state = Provider.of(context);
    return Dialog(
      child: Container(
        height: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Upload image",
              style: TextStyle(fontSize: 24),
            ),
            tags(),
            err != null ? Text(err) : Container(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.file(
                  widget.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            progress != null ? LinearProgressIndicator() : Container(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    onPressed: () async {
                      try {
                        setState(() {
                          progress = 0;
                        });
                        FormData data = FormData.fromMap({
                          "item": widget.id,
                          "image":
                              await MultipartFile.fromFile(widget.image.path)
                        });
                        String url = await getURL("itemimage/");
                        Response response = await Dio().post(url, data: data);
                        // if (selectedLabel != null) {
                        //   await state.updateCategory(selectedLabel, widget.id);
                        // }
                        if (Navigator.canPop(context)) {
                          Navigator.of(context).pop();
                        }
                      } on DioError catch (e) {
                        setState(() {
                          err = e.toString();
                        });
                        print(e);
                      }
                    },
                    child: Text("Upload"),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
