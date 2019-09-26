import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


import '../../../DataObj/StorageItem.dart';
import 'DetailedCard.dart';

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
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
        title: Text("Location"),
      ),
      body: ListView(
        children: <Widget>[
          DetailedCard(
            title: "位置",
            subtitle: position.name,
          ),
          DetailedCard(title: "位置简介", subtitle: position.description),
        ],
      ),
    );
  }
}
