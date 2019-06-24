import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile/DataObj/StorageItem.dart';

class PositionDetail extends StatelessWidget {
  final Position position;

  PositionDetail(this.position);

  Widget item(String label, String value) {
    return ListTile(
      title: Text(label),
      subtitle: Text(value == null ? "Empty" : value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location"),
      ),
      body: ListView(
        children: <Widget>[
          item("Position", position.name),
          item("Description", position.description),
        ],
      ),
    );
  }
}
