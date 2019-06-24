import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile/DataObj/StorageItem.dart';

class SeriesDetail extends StatelessWidget {
  final Series series;

  SeriesDetail(this.series);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(series.name),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text("Series name"),
            subtitle: Text(series.name),
          ),
          ListTile(
            title: Text("Series Description"),
            subtitle:
                Text(series.description == null ? "No content now" : series.description),
          )
        ],
      ),
    );
  }
}
