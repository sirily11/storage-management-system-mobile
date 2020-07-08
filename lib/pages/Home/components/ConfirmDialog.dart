import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final Function onConfirm;
  final Function onCancel;

  ConfirmDialog(
      {@required this.title,
      @required this.content,
      this.onConfirm,
      this.onCancel});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("$title"),
      content: Text("$content"),
      actions: <Widget>[
        FlatButton(
          child: Text("Cancel"),
          onPressed: () async {
            if (onCancel != null) {
              await onCancel();
            }
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text("OK"),
          onPressed: () async {
            if (onConfirm != null) {
              await onConfirm();
            }
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
