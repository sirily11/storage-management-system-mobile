import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile/DataObj/StorageItem.dart';

import 'DetailedCard.dart';

class SeriesDetail extends StatelessWidget {
  final Series series;

  SeriesDetail(this.series);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
        title: Text(series.name),
      ),
      body: ListView(
        children: <Widget>[
          DetailedCard(
            title: "系列名",
            subtitle: series.name,
          ),
          DetailedCard(
            title: "系列简介",
            subtitle: series.description,
          ),
        ],
      ),
    );
  }
}
