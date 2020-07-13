import 'package:flutter/material.dart';

Future<bool> showConfirmDialog(BuildContext context,
    {String title, String content}) async {
  var result = await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => ConfirmDialog(
      content: content,
      title: title,
    ),
  );
  return result;
}

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;

  ConfirmDialog({this.title, this.content});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("$title"),
      content: Container(
        width: MediaQuery.of(context).size.width,
        child: Text("Content"),
      ),
      actions: [
        FlatButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text("Cancel"),
        ),
        FlatButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text("OK"),
        )
      ],
    );
  }
}
