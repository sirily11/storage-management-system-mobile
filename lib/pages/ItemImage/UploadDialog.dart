import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:provider/provider.dart';
import 'package:storage_management_mobile/DataObj/StorageItem.dart';
import 'package:storage_management_mobile/States/ItemProvider.dart';
import 'package:storage_management_mobile/States/LoginProvider.dart';
import 'package:storage_management_mobile/States/urls.dart';

enum ImageDestination { detailPosition, itemImage }

class UploadDialog extends StatefulWidget {
  final File image;
  final int id;
  final List<ImageLabel> labels;
  final ImageDestination imageDestination;

  UploadDialog({
    this.id,
    @required this.image,
    this.labels,
    this.imageDestination = ImageDestination.itemImage,
  });

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
    ItemProvider state = Provider.of(context);
    return Material(
      child: Container(
        height: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Text(
                    "Upload image",
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              ),
            ),
            tags(),
            err != null ? Text(err) : Container(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: widget.image != null
                    ? Image.file(
                        widget.image,
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
            ),
            progress != null ? LinearProgressIndicator() : Container(),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      key: Key("Upload"),
                      onPressed: () async {
                        ItemProvider itemProvider =
                            Provider.of(context, listen: false);
                        try {
                          setState(() {
                            progress = 0;
                          });

                          FormData formData;
                          String url;
                          Response response;

                          if (itemProvider.isTest) {
                            Navigator.pop(context, "http://fakeimage.jpg");
                          }

                          if (widget.imageDestination ==
                              ImageDestination.itemImage) {
                            formData = FormData.fromMap({
                              "item": widget.id,
                              "image": await MultipartFile.fromFile(
                                  widget.image.path)
                            });
                            url = "${state.baseURL}$itemImageURL/";
                          } else {
                            formData = FormData.fromMap({
                              "image": await MultipartFile.fromFile(
                                  widget.image.path)
                            });
                            url =
                                "${state.baseURL}$detailPositionURL/${itemProvider.item.position.id}/";
                          }
                          var header = await LoginProvider.getLoginAccessKey();
                          if (widget.imageDestination ==
                              ImageDestination.itemImage) {
                            response = await itemProvider.dio.post(
                              url,
                              data: formData,
                              options: Options(headers: header),
                            );
                          } else {
                            response = await itemProvider.dio.patch(
                              url,
                              data: formData,
                              options: Options(headers: header),
                            );
                          }

                          if (Navigator.canPop(context)) {
                            Navigator.of(context).pop<String>(
                              response.data['image'],
                            );
                          }
                        } on DioError catch (e) {
                          setState(() {
                            err = e.toString();
                            progress = null;
                          });
                          print(e);
                        }
                      },
                      child: Text("Upload"),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Cancel"),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
