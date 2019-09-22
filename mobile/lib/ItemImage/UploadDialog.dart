import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile/utils/utils.dart';

class UploadDialog extends StatefulWidget {
  final File image;
  final int id;

  UploadDialog({this.id, this.image});

  @override
  _UploadDialogState createState() => _UploadDialogState();
}

class _UploadDialogState extends State<UploadDialog> {
  double progress;
  String err;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Upload image",
              style: TextStyle(fontSize: 20),
            ),
            err != null ? Text(err) : Container(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.file(
                widget.image,
                fit: BoxFit.cover,
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
                        if (response.statusCode == 201) {
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
